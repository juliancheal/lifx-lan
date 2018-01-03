require 'thread'

module LIFX
  module LAN
    class Thread < ::Thread
      def abort
        if alive?
          kill.join
        end
      end
    end
  end
end
