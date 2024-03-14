{ config, lib, pkgs, ... }:

let
  cfg = config.modules.cli.lf;

  vidthumb = pkgs.writeShellScript "vidthumb" ''
    if ! [ -f "$1" ]; then
      exit 1
    fi

    cache="${config.hm.xdg.cacheHome}/vidthumb"
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

    ${lib.optionalString config.hm.programs.kitty.enable ''
      if [[ "$filetype" =~ ^image ]]; then
        ${config.hm.programs.kitty.package}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
        exit 1
      fi

      if [[ "$filetype" =~ ^video ]]; then
        ${config.hm.programs.kitty.package}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$(${vidthumb} "$file")" < /dev/null > /dev/tty
        exit 1
      fi
    ''}

    ${pkgs.pistol}/pin/pistol "$file"
  '';

  cleaner = pkgs.writeShellScript "cleaner" ''
    kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
  '';
in {
  options.modules.cli.lf = {
    enable = lib.mkEnableOption "Enable lf file manager";
    enableIcons = lib.mkEnableOption "Enable icons";
    commands = {
      # TODO: Enable swww command when swww is installed
      swww = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set wallpaper using swww.";
      };
      zoxide = lib.mkOption {
        type = lib.types.bool;
        default = config.modules.cli.zoxide.enable;
        description = "Enable zoxide integration.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hm.programs.lf = {
      enable = true;
      previewer = { source = previewer; };
      settings = {
        cleaner = "${cleaner}";
        ignorecase = true;
        icons = true;
      };
      commands = {
        unarchive = ''
          ''${{
                  case "$f" in
                    *.zip) ${pkgs.unzip}/bin/unzip "$f";;
                    *.tar) tar -xvf "$f";;
                    *.tar.gz) tar -xzvf "$f";;
                    *.tar.xz) tar -xJvf "$f";;
                    *.tar.bz2) tar -zjvf "$f";;
                    *.rar) ${pkgs.unrar}/bin/unrar "$f";;
                    *) echo "Unsupported format";;
                  esac
                }}'';
        trash = ''
          ''${{
                  ${pkgs.trash-cli}/bin/trash-put "$fx"
                }}'';
        setwallpaper = lib.mkIf cfg.commands.swww ''
          ''${{
                  ln -sf "$f" ${config.hm.xdg.configHome}/wallpaper
                  ${pkgs.swww}/bin/swww img ${config.hm.xdg.configHome}/wallpaper --transition-type random --transition-step 90
                }}'';
        z = lib.mkIf cfg.commands.zoxide ''
          %{{
                  result="$(${pkgs.zoxide}/bin/zoxide query --exclude $PWD $@ | sed 's/\\/\\\\/g;s/"/\\"/g')"
                  lf -remote "send $id cd \"$result\""
                }}'';
        zi = lib.mkIf cfg.commands.zoxide ''
          ''${{
                  result="$(${pkgs.zoxide}/bin/zoxide query -i | sed 's/\\/\\\\/g;s/"/\\"/g')"
                  lf -remote "send $id cd \"$result\""
                }}'';
        git_branch = ''
          ''${{
                    git branch | ${pkgs.fzf}/bin/fzf | xargs git checkout
                    pwd_shell=$(pwd | sed 's/\\/\\\\/g;s/"/\\"/g')
                    lf -remote "send $id updir"
                    lf -remote "send $id cd \"$pwd_shell\""
                }}'';
        fzf_jump = ''
          ''${{
                    res="$(find . -maxdepth 1 | ${pkgs.fzf}/bin/fzf --reverse --header='Jump to location')"
                    if [ -n "$res" ]; then
                        if [ -d "$res" ]; then
                            cmd="cd"
                        else
                            cmd="select"
                        fi
                        res="$(printf '%s' "$res" | sed 's/\\/\\\\/g;s/"/\\"/g')"
                        lf -remote "send $id $cmd \"$res\""
                    fi
              }}'';
        fzf_search = ''
          ''${{
                    RG_PREFIX="${pkgs.ripgrep}/bin/rg --column --line-number --no-heading --color=always --smart-case "
                    res="$(
                        FZF_DEFAULT_COMMAND="$RG_PREFIX '''" \
                            ${pkgs.fzf}/bin/fzf --bind "change:reload:$RG_PREFIX {q} || true" \
                            --ansi --layout=reverse --header 'Search in files' \
                            | cut -d':' -f1 | sed 's/\\/\\\\/g;s/"/\\"/g'
                    )"
                    [ -n "$res" ] && lf -remote "send $id select \"$res\""
                }}'';
      };
      keybindings = {
        DD = "trash";
        xx = "unarchive";
        sw = "setwallpaper";
        zz = "z";
        zi = "zi";
        gb = "git_branch";
        gp =
          "\${{clear; git pull --rebase || true; echo ' press ENTER '; read ENTER}}";
        gs = "\${{clear; git status; echo ' press ENTER '; read ENTER}}";
        gl =
          "\${{clear; git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit}}";
        "<c-f>" = "push :fzf_jump<space>";
        "<c-s>" = ":fzf_search";
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

    modules.system.persist.state.home.directories = [ ".local/share/lf" ];

    hm.home.sessionVariables = lib.mkIf cfg.enableIcons {
      LF_ICONS = ''
        tw=:\
        st=:\
        ow=:\
        dt=:\
        di=:\
        fi=:\
        ln=:\
        or=:\
        ex=:\
        *.c=:\
        *.cc=:\
        *.clj=:\
        *.coffee=:\
        *.cpp=:\
        *.css=:\
        *.d=:\
        *.dart=:\
        *.erl=:\
        *.exs=:\
        *.fs=:\
        *.go=:\
        *.h=:\
        *.hh=:\
        *.hpp=:\
        *.hs=:\
        *.html=:\
        *.java=:\
        *.jl=:\
        *.js=:\
        *.json=:\
        *.lua=:\
        *.md=:\
        *.php=:\
        *.pl=:\
        *.pro=:\
        *.py=:\
        *.rb=:\
        *.rs=:\
        *.scala=:\
        *.ts=:\
        *.vim=:\
        *.cmd=:\
        *.ps1=:\
        *.sh=:\
        *.bash=:\
        *.zsh=:\
        *.fish=:\
        *.tar=:\
        *.tgz=:\
        *.arc=:\
        *.arj=:\
        *.taz=:\
        *.lha=:\
        *.lz4=:\
        *.lzh=:\
        *.lzma=:\
        *.tlz=:\
        *.txz=:\
        *.tzo=:\
        *.t7z=:\
        *.zip=:\
        *.z=:\
        *.dz=:\
        *.gz=:\
        *.lrz=:\
        *.lz=:\
        *.lzo=:\
        *.xz=:\
        *.zst=:\
        *.tzst=:\
        *.bz2=:\
        *.bz=:\
        *.tbz=:\
        *.tbz2=:\
        *.tz=:\
        *.deb=:\
        *.rpm=:\
        *.jar=:\
        *.war=:\
        *.ear=:\
        *.sar=:\
        *.rar=:\
        *.alz=:\
        *.ace=:\
        *.zoo=:\
        *.cpio=:\
        *.7z=:\
        *.rz=:\
        *.cab=:\
        *.wim=:\
        *.swm=:\
        *.dwm=:\
        *.esd=:\
        *.jpg=:\
        *.jpeg=:\
        *.mjpg=:\
        *.mjpeg=:\
        *.gif=:\
        *.bmp=:\
        *.pbm=:\
        *.pgm=:\
        *.ppm=:\
        *.tga=:\
        *.xbm=:\
        *.xpm=:\
        *.tif=:\
        *.tiff=:\
        *.png=:\
        *.svg=:\
        *.svgz=:\
        *.mng=:\
        *.pcx=:\
        *.mov=:\
        *.mpg=:\
        *.mpeg=:\
        *.m2v=:\
        *.mkv=:\
        *.webm=:\
        *.ogm=:\
        *.mp4=:\
        *.m4v=:\
        *.mp4v=:\
        *.vob=:\
        *.qt=:\
        *.nuv=:\
        *.wmv=:\
        *.asf=:\
        *.rm=:\
        *.rmvb=:\
        *.flc=:\
        *.avi=:\
        *.fli=:\
        *.flv=:\
        *.gl=:\
        *.dl=:\
        *.xcf=:\
        *.xwd=:\
        *.yuv=:\
        *.cgm=:\
        *.emf=:\
        *.ogv=:\
        *.ogx=:\
        *.aac=:\
        *.au=:\
        *.flac=:\
        *.m4a=:\
        *.mid=:\
        *.midi=:\
        *.mka=:\
        *.mp3=:\
        *.mpc=:\
        *.ogg=:\
        *.ra=:\
        *.wav=:\
        *.oga=:\
        *.opus=:\
        *.spx=:\
        *.xspf=:\
        *.pdf=:\
        *.nix=:\
      '';
    };
  };
}
