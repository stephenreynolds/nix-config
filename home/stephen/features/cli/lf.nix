{ config, pkgs, ... }:
let
  vidthumb = pkgs.writeShellScript "vidthumb" ''
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

    if ! ${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer -i "$movie" -o "$cache/$thumbnail" -s 0 2>/dev/null; then
      exit 1
    fi

    if [[ ! -f "$index" ]]; then
      echo "{\"$movie\": \"$thumbnail\"}" >"$index"
    fi
    json="$(${pkgs.jq}/bin/jq -r --arg "$movie" "$thumbnail" ". + {\"$movie\": \"$thumbnail\"}" <"$index")"
    echo "$json" >"$index"

    echo "$cache/$thumbnail"
  '';

  previewer = pkgs.writeShellScript "previewer" ''
    file=$1
    w=$2
    h=$3
    x=$4
    y=$5

    case "$file" in
      *.tar*) tar tf "$file";;
      *.zip) ${pkgs.unzip}/bin/unzip -l "$file";;
      *.rar) ${pkgs.unrar}/bin/unrar l "$file";;
      *.7z) ${pkgs.p7zip}/bin/7z l "$file";;
      *.pdf) ${pkgs.poppler_utils}/bin/pdftotext "$file" -;;
      *.epub) ${pkgs.epub2txt2}/bin/epub2txt "$file";;
      *) ${pkgs.highlight}/bin/highlight -O ansi "$file" || cat "$file";;
    esac

    filetype="$(${pkgs.file}/bin/file -Lb --mime-type "$file")"

    # TODO: Check if kitty is enabled
    if [[ "$filetype" =~ ^image ]]; then
      ${config.programs.kitty.package}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
      exit 1
    fi

    if [[ "$filetype" =~ ^video ]]; then
       ${config.programs.kitty.package}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$(${vidthumb} "$file")" < /dev/null > /dev/tty
       exit 1
    fi

    ${pkgs.pistol}/pin/pistol "$file"
  '';

  cleaner = pkgs.writeShellScript "cleaner" ''
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
    extraConfig =
      # https://github.com/gokcehan/lf/wiki/Tips#dynamically-set-number-of-columns
      ''
        ''${{
            w=$(tput cols)
            if [ $w -le 80 ]; then
                lf -remote "send $id set ratios 1:2"
            elif [ $w -le 160 ]; then
                lf -remote "send $id set ratios 1:2:3"
            else
                lf -remote "send $id set ratios 1:2:3:5"
            fi
        }}
      '';
  };
}
