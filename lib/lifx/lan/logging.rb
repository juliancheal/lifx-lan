module LIFX
  module LAN
    # @private
    module Logging
      def self.included(mod)
        mod.extend(self)
      end

      def logger
        LIFX::LAN::Config.logger
      end
    end
  end
end
