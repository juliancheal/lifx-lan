require "lifx/lan/protocol/light"

module LIFX
  module LAN
    module Protocol
      # @api private
      module MultiZone
        module ApplicationRequest
          NO_APPLY   = 0 # Don't apply the requested changes until a message with APPLY or APPLY_ONLY is sent.
          APPLY      = 1 # Apply the changes immediately and apply any pending changes.
          APPLY_ONLY = 2 # Ignore the requested changes in this message and only apply pending changes.
        end

        # #####
        # Extended Multizone requests: Unsupported by LIFX Z gen 1
        # #####

        # Change all the zones on your device in one message
        class SetExtendedColorZones < Payload
          endian :little

          uint32 :duration         # Transition duration in milliseconds
          uint8  :apply            # ApplicationRequest
          uint16 :start_index      # Zone we start applying the colors from. The first zone is 0.
          uint8  :colors_count     # Number of colors from colors will be applied sequentially from index
          array  :colors, :initial_length => 82 do
            hsbk
          end
        end

        # Ask the device to return a StateExtendedColorZones
        class GetExtendedColorZones < Payload
          endian :little
        end

        # StateExtendedColorZones
        class StateExtendedColorZones < Payload
          endian :little

          uint16 :total_zones
          uint16 :start_index
          uint8  :colors_count
          array  :colors, :initial_length => 82 do
            hsbk
          end
        end


        # #####
        # All LIFX Z and LIFX Beam products supported:
        # #####

        class SetColorZones < Payload
          endian :little

          uint8  :start_index
          uint8  :end_index
          hsbk   :color
          uint32 :duration         # Transition duration in milliseconds
          uint8  :apply            # ApplicationRequest
        end

        class GetColorZones < Payload
          endian :little

          uint8  :start_index
          uint8  :end_index
        end

        class StateZone < Payload
          endian :little

          uint8  :total_zones
          uint8  :color_index
          hsbk   :color
        end

        class StateMultiZone < Payload
          endian :little

          uint8  :total_zones
          uint8  :start_index
          array  :colors, :initial_length => 8 do
            hsbk
          end
        end
      end
    end
  end
end
