require 'lifx/lan/protocol/header'
require 'lifx/lan/protocol/address'
require 'lifx/lan/protocol/metadata'

module LIFX
  module LAN
    module Protocol
      class Message < BinData::Record
        endian :little

        include HeaderFields
        include AddressFields
        include MetadataFields

        rest :payload
      end
    end
  end
end
