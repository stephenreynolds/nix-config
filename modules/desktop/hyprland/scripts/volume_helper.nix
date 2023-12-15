{ pkgs, inputs, ... }:

let
  pactl = "${pkgs.pulseaudio}/bin/pactl"; 
  ags = "${inputs.ags.packages.${pkgs.system}.default}/bin/ags -b hyprland";
in
pkgs.writeShellScript "volumehelper" ''
  if ! command -v ${pactl} >/dev/null; then
    exit 0
  fi

  DEFAULT_STEP=5
  LIMIT=''${LIMIT:-100}
  SINK="@DEFAULT_SINK@"

  clamp() {
    if [ "$1" -lt 0 ]; then
      echo "0"
    elif [ "$1" -gt "$LIMIT" ]; then
      echo "$LIMIT"
    else
      echo "$1"
    fi
  }

  get_sink_volume() {
    ret=$(${pactl} get-sink-volume "$1")
    ret=''${ret%%%*}
    ret=''${ret##* }
    echo "$ret"
    unset ret
  }

  CHANGE=0
  VOLUME=-1

  while true; do
    case $1 in
    --sink)
      SINK=''${2:-$SINK}
      shift
      ;;
    -l | --limit)
      LIMIT=$((''${2:-$LIMIT}))
      shift
      ;;
    --set-volume)
      VOLUME=$(($2))
      shift
      ;;
    -i | --increase)
      CHANGE=$((''${2:-$DEFAULT_STEP}))
      shift
      ;;
    -d | --decrease)
      CHANGE=$((-''${2:-$DEFAULT_STEP}))
      shift
      ;;
    *)
      break
      ;;
    esac
    shift
  done

  GTK_PLAY=${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play
  VOLUME_CHANGE_SOUND=${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga
  if [ "$CHANGE" -ne 0 ]; then
    VOLUME=$(get_sink_volume "$SINK")
    VOLUME=$((VOLUME + CHANGE))
    ${pactl} set-sink-volume "$SINK" "$(clamp "$VOLUME")%"
    $GTK_PLAY -f $VOLUME_CHANGE_SOUND
  elif [ "$VOLUME" -ge 0 ]; then
    ${pactl} set-sink-volume "$SINK" "$(clamp "$VOLUME")%"
    $GTK_PLAY -f $VOLUME_CHANGE_SOUND
  fi

  # Display desktop notification

  if ! command -v notify-send >/dev/null; then
    exit 0
  fi

  VOLUME=$(get_sink_volume "$SINK")
  TEXT="Volume: ''${VOLUME}%"
  case $(${pactl} get-sink-mute "$SINK") in
  *yes)
    TEXT="Volume: muted"
    VOLUME=0
    ;;
  esac

  ${ags} -r 'indicator.speaker()' 
''
