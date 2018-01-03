module LIFX
  module LAN
    module Protocol
      # @api private
      module Wifi
        module Interface
          SOFT_AP = 1
          STATION = 2
        end

        module Security
          UNKNOWN = 0
          OPEN = 1
          WEP_PSK = 2
          WPA_TKIP_PSK = 3
          WPA_AES_PSK = 4
          WPA2_AES_PSK = 5
          WPA2_TKIP_PSK = 6
          WPA2_MIXED_PSK = 7
        end

        module Status
          CONNECTING = 0
          CONNECTED = 1
          FAILED = 2
          OFF = 3
        end

        # Gets interface status
        class Get < Payload
          endian :little

          uint8 :interface # Interface to introspect
        end

        # Switch interface on/off
        class Set < Payload
          endian :little

          uint8 :interface # Interface to introspect
          bool  :active    # Turns off interface if active is false
        end

        # Describes interface state
        class State < Payload
          endian :little

          uint8  :interface         # Interface to introspect
          uint8  :status            # Interface status
          uint32 :ipv4              # IPv4 address if interface is active
          string :ipv6, length: 16  # IPv6 address if interface is active and is IPv6 addressable
        end

        # Scan for WiFi access points. Returns StateAccessPoints
        class GetAccessPoints < Payload
          endian :little

        end

        # The AP scan results for an interface
        class StateAccessPoints < Payload
          endian :little

          uint8  :interface                            # Interface to introspect
          string :ssid, length: 32, trim_padding: true # SSID of Access Point
          uint8  :security                             # Security mode
          int16  :strength                             # Signal strength in dB
          uint16 :channel                              # Frequency channel
        end

        # Get WiFi access point information. Returns StateAccessPoint
        class GetAccessPoint < Payload
          endian :little

          uint8 :interface          # Interface to introspect
        end

        # Configure interface, should return StateAccessPoint
        class SetAccessPoint < Payload
          endian :little

          uint8  :interface                            # Interface to introspect
          string :ssid, length: 32, trim_padding: true # SSID of Access Point
          string :pass, length: 64, trim_padding: true # Passphrase used to authenticate
          uint8  :security                             # Security mode
        end

        # Interface configuration
        class StateAccessPoint < Payload
          endian :little

          uint8  :interface                            # Interface to introspect
          string :ssid, length: 32, trim_padding: true # SSID of Access Point
          uint8  :security                             # Security mode
          int16  :strength                             # Signal strength in dB
          uint16 :channel                              # Frequency channel
        end

      end
    end
  end
end
