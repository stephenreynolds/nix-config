{ inputs, ... }:
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    lowLatency.enable = true;
  };

  hardware.pulseaudio.enable = false;

  environment.etc."pipewire/pipewire.conf.d/99-virtual-surround-7.1.conf".text = ''
      context.modules = [
      { name = libpipewire-module-filter-chain
        args = {
          node.description = "Virtual Surround Sink"
          media.name       = "Virtual Surround Sink"
          filter.graph = {
            nodes = [
              {
                type  = builtin
                name  = eq_band_0
                label = bq_highshelf
                control = { "Freq" = 0 "Q" = 1.0 "Gain" = -6.2 }
              }
              {
                type  = builtin
                name  = eq_band_1
                label = bq_lowshelf
                control = { "Freq" = 105.0 "Q" = 0.7 "Gain" = 4 }
              }
              {
                type  = builtin
                name  = eq_band_2
                label = bq_peaking
                control = { "Freq" = 66.0 "Q" = 1.13 "Gain" = -0.6 }
              }
              {
                type  = builtin
                name  = eq_band_3
                label = bq_peaking
                control = { "Freq" = 169.0 "Q" = 0.55 "Gain" = -7.4 }
              }
              {
                type  = builtin
                name  = eq_band_4
                label = bq_peaking
                control = { "Freq" = 268.0 "Q" = 1.81 "Gain" = -2.7 }
              }
              {
                type  = builtin
                name  = eq_band_5
                label = bq_peaking
                control = { "Freq" = 410.0 "Q" = 2.43 "Gain" = 1.9 }
              }
              {
                type  = builtin
                name  = eq_band_6
                label = bq_peaking
                control = { "Freq" = 434.0 "Q" = 1.2 "Gain" = 8.3 }
              }
              {
                type  = builtin
                name  = eq_band_7
                label = bq_peaking
                control = { "Freq" = 979.0 "Q" = 1.44 "Gain" = -2.2 }
              }
              {
                type  = builtin
                name  = eq_band_8
                label = bq_peaking
                control = { "Freq" = 3035.0 "Q" = 3.95 "Gain" = 3.6 }
              }
              {
                type  = builtin
                name  = eq_band_9
                label = bq_peaking
                control = { "Freq" = 7956.0 "Q" = 1.4 "Gain" = 2.6 }
              }
              {
                type  = builtin
                name  = eq_band_10
                label = bq_highshelf
                control = { "Freq" = 10000.0 "Q" = 0.7 "Gain" = 3.9 }
              }

              # duplicate inputs
              { type = builtin label = copy name = copyFL  }
              { type = builtin label = copy name = copyFR  }
              { type = builtin label = copy name = copyFC  }
              { type = builtin label = copy name = copyRL  }
              { type = builtin label = copy name = copyRR  }
              { type = builtin label = copy name = copySL  }
              { type = builtin label = copy name = copySR  }
              { type = builtin label = copy name = copyLFE }

              # apply hrir - HeSuVi 14-channel WAV (not the *-.wav variants) (note: */44/* in HeSuVi are the same, but resampled to 44100)
              { type = builtin label = convolver name = convFL_L config = { filename = "${./hrir.wav}" channel =  0 } }
              { type = builtin label = convolver name = convFL_R config = { filename = "${./hrir.wav}" channel =  1 } }
              { type = builtin label = convolver name = convSL_L config = { filename = "${./hrir.wav}" channel =  2 } }
              { type = builtin label = convolver name = convSL_R config = { filename = "${./hrir.wav}" channel =  3 } }
              { type = builtin label = convolver name = convRL_L config = { filename = "${./hrir.wav}" channel =  4 } }
              { type = builtin label = convolver name = convRL_R config = { filename = "${./hrir.wav}" channel =  5 } }
              { type = builtin label = convolver name = convFC_L config = { filename = "${./hrir.wav}" channel =  6 } }
              { type = builtin label = convolver name = convFR_R config = { filename = "${./hrir.wav}" channel =  7 } }
              { type = builtin label = convolver name = convFR_L config = { filename = "${./hrir.wav}" channel =  8 } }
              { type = builtin label = convolver name = convSR_R config = { filename = "${./hrir.wav}" channel =  9 } }
              { type = builtin label = convolver name = convSR_L config = { filename = "${./hrir.wav}" channel = 10 } }
              { type = builtin label = convolver name = convRR_R config = { filename = "${./hrir.wav}" channel = 11 } }
              { type = builtin label = convolver name = convRR_L config = { filename = "${./hrir.wav}" channel = 12 } }
              { type = builtin label = convolver name = convFC_R config = { filename = "${./hrir.wav}" channel = 13 } }

              # treat LFE as FC
              { type = builtin label = convolver name = convLFE_L config = { filename = "${./hrir.wav}" channel =  6 } }
              { type = builtin label = convolver name = convLFE_R config = { filename = "${./hrir.wav}" channel = 13 } }

              # stereo output
              { type = builtin label = mixer name = mixL }
              { type = builtin label = mixer name = mixR }
            ]
            links = [
              { output = "eq_band_0:Out" input = "eq_band_1:In" }
              { output = "eq_band_1:Out" input = "eq_band_2:In" }
              { output = "eq_band_2:Out" input = "eq_band_3:In" }
              { output = "eq_band_3:Out" input = "eq_band_4:In" }
              { output = "eq_band_4:Out" input = "eq_band_5:In" }
              { output = "eq_band_5:Out" input = "eq_band_6:In" }
              { output = "eq_band_6:Out" input = "eq_band_7:In" }
              { output = "eq_band_7:Out" input = "eq_band_8:In" }
              { output = "eq_band_8:Out" input = "eq_band_9:In" }
              { output = "eq_band_9:Out" input = "eq_band_10:In" }

              # input
              { output = "copyFL:Out"  input="convFL_L:In"  }
              { output = "copyFL:Out"  input="convFL_R:In"  }
              { output = "copySL:Out"  input="convSL_L:In"  }
              { output = "copySL:Out"  input="convSL_R:In"  }
              { output = "copyRL:Out"  input="convRL_L:In"  }
              { output = "copyRL:Out"  input="convRL_R:In"  }
              { output = "copyFC:Out"  input="convFC_L:In"  }
              { output = "copyFR:Out"  input="convFR_R:In"  }
              { output = "copyFR:Out"  input="convFR_L:In"  }
              { output = "copySR:Out"  input="convSR_R:In"  }
              { output = "copySR:Out"  input="convSR_L:In"  }
              { output = "copyRR:Out"  input="convRR_R:In"  }
              { output = "copyRR:Out"  input="convRR_L:In"  }
              { output = "copyFC:Out"  input="convFC_R:In"  }
              { output = "copyLFE:Out" input="convLFE_L:In" }
              { output = "copyLFE:Out" input="convLFE_R:In" }
              # output
              { output = "convFL_L:Out"  input="mixL:In 1" }
              { output = "convFL_R:Out"  input="mixR:In 1" }
              { output = "convSL_L:Out"  input="mixL:In 2" }
              { output = "convSL_R:Out"  input="mixR:In 2" }
              { output = "convRL_L:Out"  input="mixL:In 3" }
              { output = "convRL_R:Out"  input="mixR:In 3" }
              { output = "convFC_L:Out"  input="mixL:In 4" }
              { output = "convFC_R:Out"  input="mixR:In 4" }
              { output = "convFR_R:Out"  input="mixR:In 5" }
              { output = "convFR_L:Out"  input="mixL:In 5" }
              { output = "convSR_R:Out"  input="mixR:In 6" }
              { output = "convSR_L:Out"  input="mixL:In 6" }
              { output = "convRR_R:Out"  input="mixR:In 7" }
              { output = "convRR_L:Out"  input="mixL:In 7" }
              { output = "convLFE_R:Out" input="mixR:In 8" }
              { output = "convLFE_L:Out" input="mixL:In 8" }
            ]
            inputs  = [ "copyFL:In" "copyFR:In" "copyFC:In" "copyLFE:In" "copyRL:In" "copyRR:In", "copySL:In", "copySR:In" ]
            outputs = [ "mixL:Out" "mixR:Out" ]
          }
          capture.props = {
            node.name      = "effect_input.virtual-surround-7.1-hesuvi"
            media.class    = Audio/Sink
            audio.channels = 8
            audio.position = [ FL FR FC LFE RL RR SL SR ]
          }
          playback.props = {
            node.name      = "effect_output.virtual-surround-7.1-hesuvi"
            node.passive   = true
            audio.channels = 2
            audio.position = [ FL FR ]
          }
        }
      }
    ]
  '';
}
