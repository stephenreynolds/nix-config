#!/usr/bin/env python3

import json
import os
import sys
import textwrap
from datetime import datetime
from enum import Enum
import shutil
import pathlib
import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop

import gi
gi.require_version("Gtk", "3.0")
gi.require_version("GdkPixbuf", "2.0")
from gi.repository import GdkPixbuf, GLib, Gtk

CACHE_DIR = "/tmp/eww"
HISTORY_PATH = os.path.expandvars("$XDG_CACHE_HOME/eww/notifications.json")
HISTORY_LIMIT = 20
POPUP_LIMIT = 5
EWW_CMD = "eww"


class Mode(Enum):
    ON = 0
    PRIORITY = 1
    DO_NOT_DISTURB = 2


def unwrap(value: dbus.Array
           | dbus.Boolean
           | dbus.Byte
           | dbus.Dictionary
           | dbus.Double
           | dbus.Int16
           | dbus.ByteArray
           | dbus.Int32
           | dbus.Int64
           | dbus.Signature
           | dbus.UInt16
           | dbus.UInt32
           | dbus.UInt64
           | dbus.String) -> str | int | list | tuple | float | dict | bool | bytes:
    if isinstance(value, dbus.ByteArray):
        return "".join([str(byte) for byte in value])
    if isinstance(value, (dbus.Array, list, tuple)):
        return [unwrap(item) for item in value]
    if isinstance(value, (dbus.Dictionary, dict)):
        return dict([(unwrap(x), unwrap(y)) for x, y in value.items()])
    if isinstance(value, (dbus.Signature, dbus.String)):
        return str(value)
    if isinstance(value, dbus.Boolean):
        return bool(value)
    if isinstance(
        value,
        (dbus.Int16, dbus.UInt16, dbus.Int32,
         dbus.UInt32, dbus.Int64, dbus.UInt64),
    ):
        return int(value)
    if isinstance(value, dbus.Byte):
        return bytes([int(value)])
    return value


def get_gtk_icon_path(icon_name: str, size: int = 128) -> str:
    if size < 32:
        return None
    if info := Gtk.IconTheme.get_default().lookup_icon(icon_name, size, 0):
        return info.get_filename()
    return get_gtk_icon_path(icon_name, size - 1)


def save_img_byte(pix, path):
    GdkPixbuf.Pixbuf.new_from_bytes(width=pix[0],
                                    height=pix[1],
                                    has_alpha=pix[3],
                                    data=GLib.Bytes(pix[6]),
                                    colorspace=GdkPixbuf.Colorspace.RGB,
                                    rowstride=pix[2],
                                    bits_per_sample=pix[4]).savev(path, "png")


def handle_app_rules(notification):
    appname = notification["appname"]
    match appname:
        case "Music Player Daemon":
            notification["hints"]["image-path"] = notification["icon"]
            del notification["icon"]
        case "Mailspring":
            notification["icon"] = notification["hints"]["image-path"]
            del notification["hints"]["image-path"]
        case "udiskie":
            if notification["summary"] == "Device mounted":
                notification["hints"]["sound-name"] = "device-added"
            elif notification["summary"] == "Device removed":
                notification["hints"]["sound-name"] = "device-removed"


# DOCS: https://specifications.freedesktop.org/notification-spec/latest/ar01s08.html
def parse_hints(hints_list, appname, id):
    hints = {}

    if action_icons := hints_list.get("action-icons"):
        hints["action-icons"] = action_icons

    if category := hints_list.get("category"):
        hints["category"] = category

    if desktop_entry := hints_list.get("desktop-entry"):
        hints["desktop-entry"] = desktop_entry

    if image_data := hints_list.get("icon_data"):
        hints["image-path"] = f"{CACHE_DIR}/{appname}-{id}.png"
        save_img_byte(image_data, hints["image-path"])

    if image_path := hints_list.get("image-path"):
        image_path = image_path.replace("file://", "")
        filename = os.path.basename(image_path)
        new_path = f"{CACHE_DIR}/{filename}"
        shutil.copy(image_path, new_path)
        hints["image-path"] = new_path

    if image_data := hints_list.get("image-data"):
        hints["image-path"] = f"{CACHE_DIR}/{appname}-{id}.png"
        save_img_byte(image_data, hints["image-path"])

    if sound_file := hints_list.get("sound-file"):
        hints["sound-file"] = sound_file

    if sound_name := hints_list.get("sound-name"):
        hints["sound-name"] = sound_name

    if transient := hints_list.get("transient"):
        hints["transient"] = transient

    if urgency := hints_list.get("urgency"):
        match hints_list["urgency"]:
            case b"\x00":
                urgency = "low"
            case b"\x01":
                urgency = "normal"
            case b"\x02":
                urgency = "critical"
            case _:
                urgency = "normal"
        hints["urgency"] = urgency

    return hints


def get_notification_icon(appname, app_icon, id):
    if app_icon.strip():
        if "/" in app_icon or "." in app_icon:
            icon_path = app_icon
            icon_path = icon_path.replace("file://", "")
            extension = pathlib.Path(icon_path).suffix
            new_path = f"{CACHE_DIR}/{appname}-{id}{extension}"
            shutil.copy(icon_path, new_path)
            return new_path
        return get_gtk_icon_path(app_icon)


def parse_notification(id, app_name, replaces_id, app_icon, summary,
                       body, actions, hints, expire_timeout):

    max_text_length = 36

    notification = {
        "id": id,
        "timestamp": int(datetime.now().timestamp()),
        "appname": app_name,
        "replaces-id": replaces_id,
        "icon": get_notification_icon(app_name, app_icon, id),
        "summary": summary,
        "body": textwrap.fill(GLib.markup_escape_text(body), max_text_length),
        "actions": actions,
        "hints": parse_hints(hints, app_name, id),
        "timeout": expire_timeout
    }

    # Special rules
    handle_app_rules(notification)

    return notification


def escape_quotes(s):
    return s.replace('"', '\\"').replace('\\\\"', '\\\\\\"').replace('`', '\\`')


def get_hint(notification, hint, default=None):
    return notification["hints"].get(hint, default)


class NotificationServer(dbus.service.Object):
    def __init__(self):
        bus_name = dbus.service.BusName(
            "org.freedesktop.Notifications", bus=dbus.SessionBus())
        dbus.service.Object.__init__(
            self, bus_name, "/org/freedesktop/Notifications")

        pathlib.PosixPath(os.path.dirname(HISTORY_PATH)).mkdir(
            parents=True, exist_ok=True)
        pathlib.PosixPath(HISTORY_PATH).touch(exist_ok=True)
        pathlib.PosixPath(CACHE_DIR).mkdir(parents=True, exist_ok=True)

        self.notifications = []
        self.popups = []
        self.next_id = 1
        self.mode = Mode.ON

        self.load_notifications_from_json()
        self.update_notifications()

    def load_notifications_from_json(self):
        if not os.path.exists(HISTORY_PATH):
            with open(HISTORY_PATH, "w") as f:
                json.dump([], f)

        with open(HISTORY_PATH, "r") as f:
            try:
                self.notifications = json.load(f)
                if self.notifications:
                    max_id = max(notification["id"]
                                 for group in self.notifications
                                 for notification in group["notifications"])
                    self.next_id = max(max_id + 1, self.next_id)
                else:
                    self.next_id = 1
            except json.JSONDecodeError:
                pass

    def save_notifications_to_json(self):
        with open(HISTORY_PATH, "w") as f:
            json.dump(self.notifications, f)

    def append_notification(self, notification):
        appname = notification['appname']
        found_group = None
        for group in self.notifications:
            if group['appname'] == appname:
                found_group = group
                break

        if found_group:
            found_group['notifications'].insert(0, notification)
            self.notifications.remove(found_group)
            self.notifications.insert(0, found_group)
        else:
            new_group = {'appname': appname, 'notifications': [notification]}
            self.notifications.insert(0, new_group)

        if len(self.notifications) > 20:
            self.notifications.pop()

        for group in self.notifications:
            if len(group['notifications']) > 20:
                group['notifications'].pop()

    def update_notifications(self):
        # Update the popup notifications
        output_str = json.dumps(self.popups)
        output_str = escape_quotes(output_str)
        os.system(f"{EWW_CMD} update notification-popup-list=\"{output_str}\"")

        # Update the persistant notifications
        output_str = json.dumps(self.notifications)
        output_str = escape_quotes(output_str)
        os.system(f"{EWW_CMD} update notifications=\"{output_str}\"")

    def add_popup_notification(self, notification):
        self.popups.insert(0, notification)
        if len(self.popups) > POPUP_LIMIT:
            self.popups.pop()

    def remove_popup(self, id):
        for notification in self.popups:
            if notification["id"] == id:
                self.popups.remove(notification)
                break

    def remove_by_id(self, id):
        self.remove_popup(id)
        for group in self.notifications:
            for i, notification in enumerate(group["notifications"]):
                if notification["id"] == id:
                    if len(group["notifications"]) == 1:
                        self.notifications.remove(group)
                    else:
                        group["notifications"].pop(i)
                    return

    def get_new_id(self, replaces_id):
        if replaces_id != 0:
            return replaces_id
        while self.next_id in (notification["id"]
                               for group in self.notifications
                               for notification in group["notifications"]):
            self.next_id += 1
        if self.next_id >= sys.maxsize:
            self.next_id = replaces_id
        return self.next_id

    def find_by_id(self, id):
        for group in self.notifications:
            for notification in group["notifications"]:
                if notification["id"] == id:
                    return notification
        return None

    def on_expired(self, id):
        self.remove_popup(id)
        self.update_notifications()

    def do_popup(self, notification):
        self.add_popup_notification(notification)
        id = notification["id"]
        expire_timeout = notification["timeout"]

        if expire_timeout > 0:
            GLib.timeout_add_seconds(expire_timeout // 1000, self.on_expired, id)
        elif expire_timeout < 0:
            urgency = get_hint(notification, "urgency", "normal")
            timeout = {"low": 5, "normal": 10}.get(urgency, 10)
            GLib.timeout_add_seconds(timeout, self.on_expired, id)

        if sound_name := get_hint(notification, "sound-name"):
            os.system(f"canberra-gtk-play -f /usr/share/sounds/freedesktop/stereo/{sound_name}.oga")

        if sound_file := get_hint(notification, "sound-file"):
            os.system(f"canberra-gtk-play -f {sound_file}")

    @dbus.service.method("org.freedesktop.Notifications",
                         in_signature='', out_signature='as')
    def GetCapabilities(self):
        return ['body', 'body-markup', 'actions', 'action-icons',
                'icon-static', 'persistence', 'sound']

    @dbus.service.method("org.freedesktop.Notifications",
                         in_signature='', out_signature='ssss')
    def GetServerInformation(self):
        name = "JSON Notification Server"
        vendor = "github.com/stephenreynolds"
        version = "git"
        spec_version = "1.2"
        return [name, vendor, version, spec_version]

    @dbus.service.method("org.freedesktop.Notifications",
                         in_signature='susssasa{sv}i', out_signature='u')
    def Notify(self, app_name, replaces_id, app_icon, summary, body, actions, hints, expire_timeout):
        id = self.get_new_id(replaces_id)

        assert id > 0, "Notification ID must be greater than zero."

        args = [unwrap(a) for a in [app_name, replaces_id, app_icon, summary, body, actions, hints, expire_timeout]]

        notification = parse_notification(id, *args)

        if replaces_id != 0:
            self.remove_by_id(replaces_id)

        if not get_hint(notification, "transient"):
            self.append_notification(notification)
            self.save_notifications_to_json()

        urgency = get_hint(notification, "urgency", "normal")
        if self.mode == Mode.ON or (self.mode == Mode.PRIORITY and urgency == "critical"):
            self.do_popup(notification)

        self.update_notifications()

        return id

    @dbus.service.method("org.freedesktop.Notifications",
                         in_signature='u', out_signature='')
    def CloseNotification(self, id):
        self.remove_by_id(id)
        self.save_notifications_to_json()
        self.update_notifications()

    @dbus.service.method("org.freedesktop.Notifications",
                         in_signature='s', out_signature='')
    def CloseNotificationGroup(self, appname):
        for group in self.notifications:
            if group["appname"] == appname:
                self.notifications.remove(group)
                for popup in self.popups:
                    if popup["appname"] == appname:
                        self.popups.remove(popup)
                self.save_notifications_to_json()
                self.update_notifications()
                return

    @dbus.service.method("org.freedesktop.Notifications",
                         in_signature='', out_signature='')
    def ClearNotifications(self):
        self.notifications.clear()
        self.popups.clear()
        self.save_notifications_to_json()
        self.update_notifications()

    @dbus.service.signal("org.freedesktop.Notifications", signature='uu')
    def NotificationClosed(self, id, reason):
        pass

    @dbus.service.method("org.freedesktop.Notifications", signature='us')
    def InvokeAction(self, id, action_key):
        if self.find_by_id(id) is None:
            return
        self.remove_by_id(id)
        self.save_notifications_to_json()
        self.update_notifications()
        self.ActionInvoked(id, action_key)

    @dbus.service.signal("org.freedesktop.Notifications", signature='us')
    def ActionInvoked(self, id, action_key):
        pass

    @dbus.service.signal("org.freedesktop.Notifications", signature='us')
    def ActivationToken(self, id, activation_token):
        pass

    """
    Sets the mode of the notification system.

    Args:
        value (int): The mode to set. Valid values are:
            * 0: on
            * 1: priority only
            * 2: do not disturbed

    Raises:
        TypeError: If the value is not an integer.
        ValueError: If the value is not one of the valid modes.

    Returns:
        None
    """
    @dbus.service.method("org.freedesktop.Notifications", signature='u')
    def SetMode(self, value):
        if not isinstance(value, int):
            raise TypeError("Value must be an integer.")
        if value not in [mode.value for mode in Mode]:
            raise ValueError("Invalid mode value.")
        self.mode = Mode(value)


if __name__ == "__main__":
    DBusGMainLoop(set_as_default=True)

    server = NotificationServer()

    loop = GLib.MainLoop()
    loop.run()
