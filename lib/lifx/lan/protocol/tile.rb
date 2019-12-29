require "lifx/lan/protocol/light"

module LIFX
  module LAN
    module Protocol
      # @api private
      module Tile
        class Tile < Payload
          endian :little

          # 55 bytes
          int16  :accel_meas_x            # Gravity measurements for determining orientation
          int16  :accel_meas_y            # Gravity measurements for determining orientation
          int16  :accel_meas_z            # Gravity measurements for determining orientation
          int16  :reserved_0              #
          float  :user_x                  # Position of the tile relative to the chain
          float  :user_y                  # Position of the tile relative to the chain
          uint8  :width                   # Number of pixels that are on each axis of the tile
          uint8  :height                  # Number of pixels that are on each axis of the tile
          uint8  :reserved_1              #
          uint32 :device_version_vendor   # Same as in Device::StateVersion
          uint32 :device_version_product  # Same as in Device::StateVersion
          uint32 :device_version_version  # Same as in Device::StateVersion
          uint64 :firmware_build          # Same as in Device::StateHostFirmware
          uint64 :reserved_2              #
          uint16 :firmware_version_minor  # Same as in Device::StateHostFirmware
          uint16 :firmware_version_major  # Same as in Device::StateHostFirmware
          uint32 :reserved_3              #
        end

        class GetDeviceChain < Payload
          endian :little
        end

        class StateDeviceChain < Payload
          endian :little

          uint8  :start_index
          array  :tile_devices, :initial_length => 5 do
            tile
          end
          uint8  :total_count
        end

        # Read this before using: https://lan.developer.lifx.com/v2.0/docs/tile-control
        class SetUserPosition < Payload
          endian :little

          uint8  :tile_index
          uint16 :reserved
          float  :user_x
          float  :user_y
        end

        class GetTileState64 < Payload
          endian :little

          uint8  :tile_start_index
          uint8  :tile_end_index
          uint8  :reserved
          uint8  :x
          uint8  :y
          uint8  :width
        end

        class StateTileState64 < Payload
          endian :little

          uint8  :tile_index
          uint8  :reserved
          uint8  :x
          uint8  :y
          uint8  :width
          array  :colors, :initial_length => 64 do
            hsbk
          end
        end

        class SetTileState64 < Payload
          endian :little

          uint8  :tile_start_index
          uint8  :tile_end_index
          uint8  :reserved
          uint8  :x
          uint8  :y
          uint8  :width
          uint32 :duration
          array  :colors, :initial_length => 64 do
            hsbk
          end
        end
      end
    end
  end
end
