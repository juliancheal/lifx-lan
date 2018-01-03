module LIFX
  module LAN
    module Protocol
      # @api private
      module Device

        # Describes the services exposed by the device
        module Service
          UDP = 1        # Datagram transport on specified port
          TCP = 2        # Reliable transport on specified port
          ONBOARDING = 3 # Onboarding service on specified port
          OTA = 4        # Active over-the-air update service on specified port. This is only exposed when the device is in active OTA mode with degraded service
        end

        # class SetSite < Payload
        #   endian :little

        #   string :site, length: 6
        # end


        # class GetPanGateway < Payload
        #   endian :little

        # end

        # class StatePanGateway < Payload
        #   endian :little

        #   uint8 :service
        #   uint32 :port
        # end

        # Discover devices and services exposed
        class GetService < Payload
          endian :little
        end

        # Response to GetService. Specifies service and port. Service temporarily unavailable if port is 0
        class StateService < Payload
          endian :little

          uint8  :service # maps to Service enumerated type above
          uint32 :port
        end

        # Gets device current time
        class GetTime < Payload
          endian :little
        end

        # Set the device time
        class SetTime < Payload
          endian :little

          uint64 :time # Nanoseconds since epoch.
        end

        # Returns the time at device when message was sent
        class StateTime < Payload
          endian :little

          uint64 :time # Nanoseconds since epoch.
        end

        # class GetResetSwitch < Payload
        #   endian :little

        # end

        # class StateResetSwitch < Payload
        #   endian :little

        #   uint8 :position
        # end

        # class GetMeshInfo < Payload
        #   endian :little

        # end

        # class StateMeshInfo < Payload
        #   endian :little

        #   float :signal # Milliwatts.
        #   uint32 :tx # Bytes.
        #   uint32 :rx # Bytes.
        #   int16 :mcu_temperature # Deci-celsius. 25.45 celsius is 2545
        # end

        # class GetMeshFirmware < Payload
        #   endian :little

        # end

        # class StateMeshFirmware < Payload
        #   endian :little

        #   uint64 :build # Firmware build nanoseconds since epoch.
        #   uint64 :install # Firmware install nanoseconds since epoch.
        #   uint32 :version # Firmware human readable version.
        # end

        # Get Host MCU information
        class GetHostInfo < Payload
          endian :little
        end

        # Host MCU information
        class StateHostInfo < Payload
          endian :little

          float  :signal          # radio receive signal strength in Milliwatts (mw)
          uint32 :tx              # bytes transmitted since power on
          uint32 :rx              # bytes received since power on
          int16  :mcu_temperature # internal temperature (deci-celsius). 25.45 celsius is 2545
        end

        # Gets Host MCU firmware
        class GetHostFirmware < Payload
          endian :little
        end

        class StateHostFirmware < Payload
          endian :little

          uint64 :build   # build time in nanonseconds since epoch
          uint64 :install # install time, depricated
          uint32 :version # firmware version
        end

        # Get Wifi subsystem information
        class GetWifiInfo < Payload
          endian :little
        end

        # Wifi subsystem information
        class StateWifiInfo < Payload
          endian :little

          float  :signal          # radio receive signal strength in Milliwatts (mw)
          uint32 :tx              # bytes transmitted since power on
          uint32 :rx              # bytes received since power on
          int16  :mcu_temperature # internal temperature (deci-celsius). 25.45 celsius is 2545
        end

        # Get Wifi subsystem firmware
        class GetWifiFirmware < Payload
          endian :little
        end

        class StateWifiFirmware < Payload
          endian :little

          uint64 :build   # build time in nanonseconds since epoch
          uint64 :install # install time, depricated
          uint32 :version # firmware version
        end

        # Get device power level
        class GetPower < Payload
          endian :little
        end

        # Set device power level
        class SetPower < Payload
          endian :little

          uint16 :level # Zero implies standby and non-zero sets a corresponding power draw level on device. Currently only 0 and 65535 are supported
        end

        # Device power level
        class StatePower < Payload
          endian :little

          uint16 :level # 0 Standby. > 0 On.
        end

        # Introspect the device label. Returns StateLabel
        class GetLabel < Payload
          endian :little
        end

        # Set the device label text
        class SetLabel < Payload
          endian :little

          string :label, length: 32, trim_padding: true
        end

        # Device label
        class StateLabel < Payload
          endian :little

          string :label, length: 32, trim_padding: true
        end

        # Get the device tags. Returns StateTags
        class GetTags < Payload
          endian :little
        end

        # Set the device tags
        class SetTags < Payload
          endian :little

          uint64 :tags # Bitfield, allows 64 tags. A device can be tagged with one or more of them
        end

        # Device tags
        class StateTags < Payload
          endian :little

          uint64 :tags
        end

        # Get the text labels describing the tags. Returns StateTagLabels
        class GetTagLabels < Payload
          endian :little

          uint64 :tags # Retrieve the labels for tags selected in the bitfield
        end

        # Sets the text label for the corresponding tags. Note you can label or reset multiple labels at the same time
        class SetTagLabels < Payload
          endian :little

          uint64 :tags # Set labels for tags selected in the bitfield
          string :label, length: 32, trim_padding: true
        end

        # The tag label for tags in the bitfield
        class StateTagLabels < Payload
          endian :little

          uint64 :tags
          string :label, length: 32, trim_padding: true
        end

        # Get the hardware version. Returns StateVersion
        class GetVersion < Payload
          endian :little
        end

        # The hardware version of the device
        class StateVersion < Payload
          endian :little

          uint32 :vendor  # Vendor ID
          uint32 :product # Product ID
          uint32 :version # Hardware version
        end

        # Get runtime information. Returns StateInfo
        class GetInfo < Payload
          endian :little
        end

        # Runtime information of device
        class StateInfo < Payload
          endian :little

          uint64 :time     # wallclock time on device, nanoseconds since epoch
          uint64 :uptime   # device uptime, nanoseconds since boot
          uint64 :downtime # last measured downtime, accurate to 5s, nanoseconds off last power cycle
        end

        # class GetMcuRailVoltage < Payload
        #   endian :little
        # end

        # class StateMcuRailVoltage < Payload
        #   endian :little

        #   uint32 :voltage
        # end

        # class Reboot < Payload
        #   endian :little
        # end

        # Soft reboot the device in 1000ms from time received
        class SetReboot < Payload
          endian :little
        end

        # Sent back if reboot is pending on SetReboot
        class StateReboot < Payload
          endian :little
        end

        # Sent back from device on receipt of a message with ack_required set to 1
        class Acknowledgement < Payload
          endian :little
        end

        # Clear all settings from the device
        class SetFactoryReset < Payload
          endian :little
        end

        # Signifies pending reset
        class StateFactoryReset < Payload
          endian :little
        end

        # Get the device location
        class GetLocation < Payload
          endian :little
        end

        # Set the device location
        class SetLocation < Payload
          endian :little

          string :location, length: 16                  # guid byte array
          string :label, length: 32, trim_padding: true # text label for location
        end

        # Device location
        class StateLocation < Payload
          endian :little

          string :location, length: 16                  # guid byte array
          string :label, length: 32, trim_padding: true # text label for location
        end

        # Get the device group. A device can belong to a single logical group
        class GetGroup < Payload
          endian :little
        end

        # Set the device group
        class SetGroup < Payload
          endian :little

          string :group, length: 16                     # guid byte array
          string :label, length: 32, trim_padding: true # text label for group
        end

        # Set the device group
        class StateGroup < Payload
          endian :little

          string :group, length: 16                     # guid byte array
          string :label, length: 32, trim_padding: true # text label for group
        end

        # Introspect the device owner. Returns StateOwner
        class GetOwner < Payload
          endian :little
        end

        # Set the device owner
        class SetOwner < Payload
          endian :little

          string :owner, length: 16                     # guid byte array
          string :label, length: 32, trim_padding: true # text label of owner details
        end

        # Return the device owner information
        class StateOwner < Payload
          endian :little

          string :owner, length: 16                     # guid byte array
          string :label, length: 32, trim_padding: true # text label of owner details
        end

        # Request an arbitrary payload be echoed back
        class EchoRequest < Payload
          endian :little

          string :payload, length: 64 # byte array
        end

        # Echo response with payload sent in request
        class EchoResponse < Payload
          endian :little

          string :payload, length: 64 # byte array
        end

      end
    end
  end
end
