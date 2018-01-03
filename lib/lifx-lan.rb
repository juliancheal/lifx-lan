require "lifx/lan/version"
require "bindata"
require "bindata_ext/bool"
require "bindata_ext/record"

require "lifx/lan/required_keyword_arguments"
require "lifx/lan/utilities"
require "lifx/lan/logging"

require "lifx/lan/thread"

require "lifx/lan/protocol/payload"
%w(device light sensor wan wifi message).each { |f| require "lifx/lan/protocol/#{f}" }
require "lifx/lan/protocol/type"
require "lifx/lan/message"
require "lifx/lan/transport"

require "lifx/lan/config"
require "lifx/lan/client"

module LIFX
  module LAN
    NULL_SITE_ID = "000000000000"

    class TimeoutError < StandardError; end
  end
end
