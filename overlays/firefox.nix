final: prev: {
  firefox = prev.firefox.override {
    overrides = final: prev: { cfg.speechSynthesisSupport = true; };
  };
}
