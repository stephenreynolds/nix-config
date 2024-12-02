# TODO: Delete once https://github.com/NixOS/nixpkgs/pull/359604 is merged into unstable
final: prev: {
  bibata-cursors = prev.bibata-cursors.overrideAttrs (old: {
    buildPhase = ''
      runHook preBuild

      ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Amber -n 'Bibata-Modern-Amber' -c 'Yellowish and rounded edge Bibata XCursors'
      ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Classic -n 'Bibata-Modern-Classic' -c 'Black and rounded edge Bibata XCursors'
      ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Ice -n 'Bibata-Modern-Ice' -c 'White and rounded edge Bibata XCursors'

      ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Amber-Right -n 'Bibata-Modern-Amber-Right' -c 'Yellowish and rounded edge right-hand Bibata XCursors'
      ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Classic-Right -n 'Bibata-Modern-Classic-Right' -c 'Black and rounded edge right-hand Bibata XCursors'
      ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Ice-Right -n 'Bibata-Modern-Ice-Right' -c 'White and rounded edge right-hand Bibata XCursors'

      ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Amber -n 'Bibata-Original-Amber' -c 'Yellowish and sharp edge Bibata XCursors'
      ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Classic -n 'Bibata-Original-Classic' -c 'Black and sharp edge Bibata XCursors'
      ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Ice -n 'Bibata-Original-Ice' -c 'White and sharp edge Bibata XCursors'

      ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Amber-Right -n 'Bibata-Original-Amber-Right' -c 'Yellowish and sharp edge right-hand Bibata XCursors'
      ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Classic-Right -n 'Bibata-Original-Classic-Right' -c 'Black and sharp edge right-hand Bibata XCursors'
      ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Ice-Right -n 'Bibata-Original-Ice-Right' -c 'White and sharp edge right-hand Bibata XCursors'

      runHook postBuild
    '';
  });
}
