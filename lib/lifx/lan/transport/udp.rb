require 'socket'
module LIFX
  module LAN
    class Transport
      # @api private
      # @private
      class UDP < Transport
        def initialize(*args)
          super
          @socket = create_socket
        end

        def connected?
          !!@socket
        end

        def write_raw(data)
          logger.debug("-> #{data}")
          @socket.send(data.scan(/../).map { |x| x.hex.chr }.join, 0, host, port)
          true
        rescue => ex
          logger.warn("#{self}: Error on #write: #{ex}")
          logger.debug("#{self}: Backtrace: #{ex.backtrace.join("\n")}")
          close
          false
        end

        def write(message)
          logger.debug("-> Broadcast UDP message: #{message}")
          logger.debug("-> #{message.to_hex}")
          data = message.pack
          @socket.send(data, 0, host, port)
          true
        rescue => ex
          logger.warn("#{self}: Error on #write: #{ex}")
          logger.debug("#{self}: Backtrace: #{ex.backtrace.join("\n")}")
          close
          false
        end

        def listen(ip: self.host, port: self.port)
          if @listener
            raise "Socket already being listened to"
          end

          @listener = Thread.start do
            reader = UDPSocket.new
            reader.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
            reader.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEPORT, true) if Socket.const_defined?('SO_REUSEPORT')
            reader.bind(ip, port)
            loop do
              begin
                bytes, (_, _, ip, _) = reader.recvfrom(1280)
                logger.debug("<- #{bytes.each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join}")
                message = Message.unpack(bytes)
                logger.debug("<- Incoming message: #{message}")
                notify_observers(:message_received, {message: message, ip: ip, transport: self})
              rescue Message::UnpackError
                if Config.log_invalid_messages
                  logger.warn("#{self}: Unrecognised bytes: #{bytes.bytes.map { |b| '%02x ' % b }.join}")
                end
              end
            end
          end
        end

        def close
          super
          return if !@socket
          @socket.close
          @socket = nil
          if @listener
            @listener.abort
          end
        end

        protected

        def create_socket
          UDPSocket.new.tap do |socket|
            socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
          end
        end
      end
    end
  end
end
