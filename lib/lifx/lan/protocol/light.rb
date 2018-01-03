module LIFX
  module Protocol
    # @api private
    module Light
      module Waveform
        SAW = 0
        SINE = 1
        HALF_SINE = 2
        TRIANGLE = 3
        PULSE = 4
      end

      class Hsbk < Payload
        endian :little

        uint16 :hue        # 0..65_535 scaled to 0° - 360°
        uint16 :saturation # 0..65_535 scaled to 0% - 100%
        uint16 :brightness # 0..65_535 scaled to 0% - 100%
        uint16 :kelvin     # Explicit 2_400..9_000
      end

      # Introspect the light state
      class Get < Payload
        endian :little
      end

      # class Set < Payload
      #   endian :little

      #   uint8 :stream # 0 is no stream.
      #   hsbk :color
      #   uint32 :duration # Milliseconds.
      # end

      # Light state including identifying meta data
      class State < Payload
        endian :little

        hsbk   :color
        int16  :dim
        uint16 :power
        string :label, length: 32, trim_padding: true
        uint64 :tags
      end

      # Simple light color control
      class SetColor < Payload
        endian :little

        uint8  :stream, value: 0 # Reserved for LIFX use, must be 0 (0 is no stream)
        hsbk   :color            # Color value
        uint32 :duration         # Transition duration in milliseconds
      end

      # Instrospect light power level on device
      class GetPower < Payload
        endian :little

      end

      # Set the power level of a light
      class SetPower < Payload
        endian :little

        uint16 :level    # Power level between 0..65535. Zero implies standby and non-zero sets a corresponding power draw level on device
        uint32 :duration # Duration in milliseconds for the power transition between 0..65535
      end

      # Current power level of device
      class StatePower < Payload
        endian :little

        uint16 :level
      end

      # Does below code work with LIFX20 ?
      # ----------------------------------------------------------------
      class SetWaveform < Payload
        endian :little

        uint8 :stream # 0 is no stream.
        bool :transient
        hsbk :color
        uint32 :period # Milliseconds per cycle.
        float :cycles
        int16 :skew_ratio
        uint8 :waveform
      end

      class SetDimAbsolute < Payload
        endian :little

        int16 :brightness # 0 is no change.
        uint32 :duration # Milliseconds.
      end

      class SetDimRelative < Payload
        endian :little

        int32 :brightness # 0 is no change.
        uint32 :duration # Milliseconds.
      end

      class Rgbw < Payload
        endian :little

        uint16 :red
        uint16 :green
        uint16 :blue
        uint16 :white
      end

      class SetRgbw < Payload
        endian :little

        rgbw :color
      end

      class GetRailVoltage < Payload
        endian :little
      end

      class StateRailVoltage < Payload
        endian :little

        uint32 :voltage
      end

      class GetTemperature < Payload
        endian :little
      end

      class StateTemperature < Payload
        endian :little

        int16 :temperature # Deci-celsius. 25.45 celsius is 2545
      end

    end
  end
end
