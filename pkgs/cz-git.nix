{ stdenv, stdenvNoCC, fetchFromGitHub, jq, moreutils, cacert, nodePackages }:

stdenv.mkDerivation (finalAttrs: {
  pname = "cz-git";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "Zhengqbbb";
    repo = "cz-git";
    rev = "v${finalAttrs.version}";
    sha256 = "imPgL7AZT1WsXPTz+0EwJFGeRWXITCneteAbwrDE2A4=";
  };

  pnpmDeps = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-pnpm-deps";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [ jq moreutils nodePackages.pnpm cacert ];

    pnpmPatch = builtins.toJSON {
      pnpm.supportedArchitectures = {
        os = [ "linux" ];
        cpu = [ "x64" "arm64" ];
      };
    };

    postPatch = ''
      mv package.json package.json.orig
      jq --raw-output ". * $pnpmPatch" package.json.orig > package.json
    '';

    installPhase = ''
      export HOME=$(mktemp -d)

      pnpm config set store-dir $out
      pnpm install --frozen-lockfile --ignore-script

      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    dontBuild = true;
    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-kIeeuRbNX4YhvxJHOXkPZ1Ri4KGIftuOTNQC7OnhnRI=";
  };

  nativeBuildInputs = [ nodePackages.pnpm ];

  preBuild = ''
    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    cp -Tr "$pnpmDeps" "$STORE_PATH"
    chmod -R +w "$STORE_PATH"

    pnpm config set store-dir "$STORE_PATH"
    pnpm install --offline --frozen-lockfile --ignore-script
    patchShebangs node_modules/{*,.*}
  '';

  postBuild = ''
    pnpm build
  '';

  buildInputs = [ nodePackages.nodejs ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp packages/cli/bin/index.js $out/bin/czg
    cp -r packages/cli/lib $out

    chmod +x $out/bin/czg

    runHook postInstall
  '';

  passthru = { inherit (finalAttrs) pnpmDeps; };
})
