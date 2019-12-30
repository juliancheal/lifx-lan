module LIFX
  module LAN
    # LightTarget is a module that contains Light commands that can work
    # with either a single {Light} or multiple Lights via a {LightCollection}
    module LightTarget
      MSEC_PER_SEC   = 1000

      # Attempts to set the color of the light(s) to `color` asynchronously.
      # This method cannot guarantee that the message was received.
      # @param color [Color] The color to be set
      # @param duration: [Numeric] Transition time in seconds
      # @return [Light, LightCollection] self for chaining
      def set_color(color, duration: LIFX::LAN::Config.default_duration)
        send_message(Protocol::Light::SetColor.new(
          color: color.to_hsbk,
          duration: (duration * MSEC_PER_SEC).to_i,
          stream: 0,
        ))
        self
      end

      # Attempts to set multiple zones on the light(s) to `color` asynchronously.
      # This method cannot guarantee that the message was received.
      # @param color [Color] The color to be set
      # @param start_index [Numeric] The index of the first zone to be set
      # @param end_index [Numeric] The index of the last zone to be set
      # @param duration: [Numeric] Transition time in seconds
      # @return [Light, LightCollection] self for chaining
      def set_multizone_color(color, start_index: 0, end_index: 7, duration: LIFX::LAN::Config.default_duration)
        send_message(Protocol::MultiZone::SetColorZones.new(
          start_index: start_index,
          end_index: end_index,
          color: color.to_hsbk,
          duration: (duration * MSEC_PER_SEC).to_i,
          apply: 1,
        ))
        self
      end

      # Attempts to set every pixel on the tile(s) to `colors` asynchronously.
      # This method cannot guarantee that the message was received.
      # @param colors [Array<Color>] The 64 Colors to be set as a 1-d array
      # @param tile_start_index [Numeric] The index of the first tile to be set
      # @param length [Numeric] The number of tiles to set starting from the index
      # @param duration: [Numeric] Transition time in seconds
      # @return [Light, LightCollection] self for chaining
      def set_tile_colors(colors, tile_start_index: 0, length: 1, duration: LIFX::LAN::Config.default_duration)
        send_message(Protocol::Tile::SetTileState64.new(
          colors: colors.map(&:to_hsbk),
          tile_start_index: tile_start_index,
          tile_length: [length, 1].min,
          x: 0,
          y: 0,
          width: 8,
          duration: (duration * MSEC_PER_SEC).to_i
        ))
        self
      end

      # @return [Numeric] Number of zones supported
      def zone_count
        send_message!(Protocol::MultiZone::GetColorZones.new(start_index: 0, end_index: 0),
            wait_for: Protocol::MultiZone::StateZone) do |payload|
          payload.total_zones
        end
      end

      # @return [Hash] Raw tile info
      def tile_info
        send_message!(Protocol::Tile::GetDeviceChain.new,
            wait_for: Protocol::Tile::StateDeviceChain) do |payload|
          payload
        end
      end

      # Attempts to apply a waveform to the light(s) asynchronously.
      # @note Don't use this directly.
      # @api private
      def set_waveform(color, waveform: required!(:waveform),
                              cycles: required!(:cycles),
                              stream: 0,
                              transient: true,
                              period: 1.0,
                              skew_ratio: 0.5,
                              acknowledge: false)
        send_message(Protocol::Light::SetWaveform.new(
          color: color.to_hsbk,
          waveform: waveform,
          cycles: cycles,
          stream: stream,
          transient: transient,
          period: (period * 1_000).to_i,
          skew_ratio: (skew_ratio * 65535).round - 32768,
        ), acknowledge: acknowledge)
      end

      # Attempts to make the light(s) pulse `color` and then back to its original color. Asynchronous.
      # @param color [Color] Color to pulse
      # @param duty_cycle: [Float] Ratio of a cycle the light(s) is set to `color`
      # @param cycles: [Integer] Number of cycles
      # @param transient: [Boolean] If false, the light will remain at the color the waveform is at when it ends
      # @param period: [Integer] Number of seconds a cycle. Must be above 1.0 (?)
      # @param stream: [Integer] Unused
      def pulse(color, cycles: 1,
                       duty_cycle: 0.5,
                       transient: true,
                       period: 1.0,
                       stream: 0)
        set_waveform(color, waveform: Protocol::Light::Waveform::PULSE,
                            cycles: cycles,
                            skew_ratio: 1 - duty_cycle,
                            stream: stream,
                            transient: transient,
                            period: period)
      end

      # Attempts to make the light(s) transition to `color` and back in a smooth sine wave. Asynchronous.
      # @param color [Color] Color
      # @param cycles: [Integer] Number of cycles
      # @param peak: [Float] Defines the peak point of the wave. Defaults to 0.5 which is a standard sine
      # @param transient: [Boolean] If false, the light will remain at the color the waveform is at when it ends
      # @param period: [Integer] Number of seconds a cycle. Must be above 1.0 (?)
      # @param stream: [Integer] Unused
      def sine(color, cycles: 1,
                      period: 1.0,
                      peak: 0.5,
                      transient: true,
                      stream: 0)
        set_waveform(color, waveform: Protocol::Light::Waveform::SINE,
                            cycles: cycles,
                            skew_ratio: peak,
                            stream: stream,
                            transient: transient,
                            period: period)
      end

      # Attempts to make the light(s) transition to `color` smoothly, then immediately back to its original color. Asynchronous.
      # @param color [Color] Color
      # @param cycles: [Integer] Number of cycles
      # @param transient: [Boolean] If false, the light will remain at the color the waveform is at when it ends
      # @param period: [Integer] Number of seconds a cycle. Must be above 1.0 (?)
      # @param stream: [Integer] Unused
      def half_sine(color, cycles: 1,
                           period: 1.0,
                           transient: true,
                           stream: 0)
        set_waveform(color, waveform: Protocol::Light::Waveform::HALF_SINE,
                            cycles: cycles,
                            stream: stream,
                            transient: transient,
                            period: period)
      end

      # Attempts to make the light(s) transition to `color` linearly and back. Asynchronous.
      # @param color [Color] Color to pulse
      # @param cycles: [Integer] Number of cycles
      # @param transient: [Boolean] If false, the light will remain at the color the waveform is at when it ends
      # @param period: [Integer] Number of seconds a cycle. Must be above 1.0 (?)
      # @param stream: [Integer] Unused
      def triangle(color, cycles: 1,
                       period: 1.0,
                       peak: 0.5,
                       transient: true,
                       stream: 0)
        set_waveform(color, waveform: Protocol::Light::Waveform::TRIANGLE,
                            cycles: cycles,
                            skew_ratio: peak,
                            stream: stream,
                            transient: transient,
                            period: period)
      end

      # Attempts to make the light(s) transition to `color` linearly, then instantly back. Asynchronous.
      # @param color [Color] Color to saw wave
      # @param cycles: [Integer] Number of cycles
      # @param transient: [Boolean] If false, the light will remain at the color the waveform is at when it ends
      # @param period: [Integer] Number of seconds a cycle. Must be above 1.0 (?)
      # @param stream: [Integer] Unused
      def saw(color, cycles: 1,
                     period: 1.0,
                     transient: true,
                     stream: 0)
        set_waveform(color, waveform: Protocol::Light::Waveform::SAW,
                            cycles: cycles,
                            stream: stream,
                            transient: transient,
                            period: period)
      end

      # Attempts to set the power state to `state` asynchronously.
      # This method cannot guarantee the message was received.
      # @param state [:on, :off]
      # @return [Light, LightCollection] self for chaining
      def set_power(state)
        level = case state
        when :on
          1
        when :off
          0
        else
          raise ArgumentError.new("Must pass in either :on or :off")
        end
        send_message(Protocol::Device::SetPower.new(level: level))
        self
      end

      # Attempts to turn the light(s) on asynchronously.
      # This method cannot guarantee the message was received.
      # @return [Light, LightCollection] self for chaining
      def turn_on
        set_power(:on)
      end

      # Attempts to turn the light(s) off asynchronously.
      # This method cannot guarantee the message was received.
      # @return [Light, LightCollection] self for chaining
      def turn_off
        set_power(:off)
      end

      # Requests light(s) to report their state
      # This method cannot guarantee the message was received.
      # @return [Light, LightCollection] self for chaining
      def refresh
        send_message(Protocol::Light::Get.new)
        self
      end

      NSEC_IN_SEC = 1_000_000_000
      # Attempts to set the device time on the targets
      # @api private
      # @param time [Time] The time to set
      # @return [void]
      def set_time(time = Time.now)
        send_message(Protocol::Device::SetTime.new(time: (time.to_f * NSEC_IN_SEC).round))
      end
    end
  end
end
