module LIFX
  module Protocol
    module AddressFields
      def AddressFields.included(mod)
        mod.instance_eval do
          hide :_reserved2
          string    :raw_target, length: 8
          string    :raw_site, length: 6 # Deprecated, should be zeros or "LIFXV2"
          bit6le    :_reserved2
          bool_bit1 :acknowledge  # Acknowledgement required
          bool_bit1 :res_required # Response required
          uint8     :sequence     # Wrap around message sequence number
        end
      end
    end

    class Address < BinData::Record
      endian :little

      include AddressFields
    end
  end
end
