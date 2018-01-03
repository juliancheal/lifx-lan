module LIFX
  module Protocol
    module HeaderFields
      def HeaderFields.included(mod)
        mod.instance_eval do
          uint16    :msg_size # Size of entire message in bytes including this field.
          bit12le   :protocol, value: 1024 # Protocol number, always 1024 for LIFX Protocol messages
          bool_bit1 :addressable, value: true # Message includes an address, always true for LIFX Protocol messages
          bool_bit1 :tagged # Indicates that the message addresses device tagged with specified tags
          bit2le    :origin, value: 0 # Message origin indicator, should be zero
          uint32    :source # Source identifier. Unique 32 bit value sent by the client, used for NAT and responses
        end
      end
    end

    class Header < BinData::Record
      endian :little

      include HeaderFields
    end
  end
end
