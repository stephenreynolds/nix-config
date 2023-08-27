{ pkgs, ... }:
let
  vidthumb = pkgs.writeShellScript "vidthumb" ''
    #!/usr/bin/env bash

    if ! [ -f "$1" ]; then
      exit 1
    fi

    cache="$HOME/.cache/vidthumb"
    index="$cache/index.json"
    movie="$(realpath "$1")"

    mkdir -p "$cache"

    if [ -f "$index" ]; then
      thumbnail="$(jq -r ". \"$movie\"" <"$index")"
      if [[ "$thumbnail" != "null" ]]; then
        if [[ ! -f "$cache/$thumbnail" ]]; then
          exit 1
        fi
        echo "$cache/$thumbnail"
        exit 0
      fi
    fi

    thumbnail="$(uuidgen).jpg"

    if ! ffmpegthumbnailer -i "$movie" -o "$cache/$thumbnail" -s 0 2>/dev/null; then
      exit 1
    fi

    if [[ ! -f "$index" ]]; then
      echo "{\"$movie\": \"$thumbnail\"}" >"$index"
    fi
    json="$(jq -r --arg "$movie" "$thumbnail" ". + {\"$movie\": \"$thumbnail\"}" <"$index")"
    echo "$json" >"$index"

    echo "$cache/$thumbnail"
  '';

  previewer = pkgs.writeShellScript "previewer" ''
    #!/usr/bin/env bash
    file=$1
    w=$2
    h=$3
    x=$4
    y=$5

    filetype="$( file -Lb --mime-type "$file")"

    if [[ "$filetype" =~ ^image ]]; then
      kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
      exit 1
    fi

    if [[ "$filetype" =~ ^video ]]; then
       kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$(${vidthumb} "$file")" < /dev/null > /dev/tty
       exit 1
    fi

    pistol "$file"
  '';

  cleaner = pkgs.writeShellScript "cleaner" ''
    #!/usr/bin/env bash
    kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
  '';
in
{
  programs.lf = {
    enable = true;
    previewer = {
      source = previewer;
    };
    settings = {
      cleaner = "${cleaner}";
    };
  };

  home.packages = with pkgs; [
    file
    pistol
    ffmpegthumbnailer
  ];
}
