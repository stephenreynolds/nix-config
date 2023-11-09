final: prev: {
  discocss = prev.discocss.overrideAttrs
    (oldAttrs: { patches = (oldAttrs.patches or [ ]) ++ [ ./discocss.diff ]; });
}
