{
  # Source: https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/master/src/daemon/filter-chain/spatializer-7.1.conf
  xdg.configFile."pipewire/filter-chain.conf.d/spatializer-7.1.conf" = {
    text = ''
      context.modules = [
        { name = libpipewire-module-filter-chain
            args = {
              node.description = "Spatial Sink"
              media.name       = "Spatial Sink"
              filter.graph = {
                nodes = [
                  {
                    type = sofa
                    label = spatializer
                    name = spFL
                    config = {
                      filename = "${./EAC_48kHz.sofa}"
                    }
                    control = {
                      "Azimuth"    = 30.0
                      "Elevation"  = 0.0
                      "Radius"     = 3.0
                    }
                  }
                  {
                    type = sofa
                    label = spatializer
                    name = spFR
                    config = {
                      filename = "${./EAC_48kHz.sofa}"}"
                    }
                    control = {
                      "Azimuth"    = 330.0
                      "Elevation"  = 0.0
                      "Radius"     = 3.0
                    }
                  }
                  {
                    type = sofa
                    label = spatializer
                    name = spFC
                    config = {
                      filename = "${./EAC_48kHz.sofa}"
                    }
                    control = {
                      "Azimuth"    = 0.0
                      "Elevation"  = 0.0
                      "Radius"     = 3.0
                    }
                  }
                  {
                    type = sofa
                    label = spatializer
                    name = spRL
                    config = {
                      filename = "${./EAC_48kHz.sofa}"
                    }
                    control = {
                      "Azimuth"    = 150.0
                      "Elevation"  = 0.0
                      "Radius"     = 3.0
                    }
                  }
                  {
                    type = sofa
                    label = spatializer
                    name = spRR
                    config = {
                      filename = "${./EAC_48kHz.sofa}"
                    }
                    control = {
                      "Azimuth"    = 210.0
                      "Elevation"  = 0.0
                      "Radius"     = 3.0
                    }
                  }
                  {
                    type = sofa
                    label = spatializer
                    name = spSL
                    config = {
                      filename = "${./EAC_48kHz.sofa}"
                    }
                    control = {
                      "Azimuth"    = 90.0
                      "Elevation"  = 0.0
                      "Radius"     = 3.0
                    }
                  }
                  {
                    type = sofa
                    label = spatializer
                    name = spSR
                    config = {
                      filename = "${./EAC_48kHz.sofa}"
                    }
                    control = {
                      "Azimuth"    = 270.0
                      "Elevation"  = 0.0
                      "Radius"     = 3.0
                    }
                  }
                  {
                    type = sofa
                    label = spatializer
                    name = spLFE
                    config = {
                      filename = "${./EAC_48kHz.sofa}"
                    }
                    control = {
                      "Azimuth"    = 0.0
                      "Elevation"  = -60.0
                      "Radius"     = 3.0
                    }
                  }
                  { type = builtin label = mixer name = mixL }
                  { type = builtin label = mixer name = mixR }
                ]
                links = [
                  # output
                  { output = "spFL:Out L"  input="mixL:In 1" }
                  { output = "spFL:Out R"  input="mixR:In 1" }
                  { output = "spFR:Out L"  input="mixL:In 2" }
                  { output = "spFR:Out R"  input="mixR:In 2" }
                  { output = "spFC:Out L"  input="mixL:In 3" }
                  { output = "spFC:Out R"  input="mixR:In 3" }
                  { output = "spRL:Out L"  input="mixL:In 4" }
                  { output = "spRL:Out R"  input="mixR:In 4" }
                  { output = "spRR:Out L"  input="mixL:In 5" }
                  { output = "spRR:Out R"  input="mixR:In 5" }
                  { output = "spSL:Out L"  input="mixL:In 6" }
                  { output = "spSL:Out R"  input="mixR:In 6" }
                  { output = "spSR:Out L"  input="mixL:In 7" }
                  { output = "spSR:Out R"  input="mixR:In 7" }
                  { output = "spLFE:Out L" input="mixL:In 8" }
                  { output = "spLFE:Out R" input="mixR:In 8" }
                ]
                inputs  = [ "spFL:In" "spFR:In" "spFC:In" "spLFE:In" "spRL:In" "spRR:In", "spSL:In", "spSR:In" ]
                outputs = [ "mixL:Out" "mixR:Out" ]
              }
              capture.props = {
                node.name      = "effect_input.spatializer"
                media.class    = Audio/Sink
                audio.channels = 8
                audio.position = [ FL FR FC LFE RL RR SL SR ]
              }
              playback.props = {
                node.name      = "effect_output.spatializer"
                node.passive   = true
                audio.channels = 2
                audio.position = [ FL FR ]
              }
            }
          }
        ]
    '';
  };
}
