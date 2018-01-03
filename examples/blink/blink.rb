require 'lifx-lan'

lifx = LIFX::LAN::Client.lan
lifx.discover!

light = lifx.lights.first
light.set_color LIFX::LAN::Color.white, duration: 0

sleep(0.5)

light.set_color LIFX::LAN::Color.red, duration: 0

sleep(0.5)

light.set_color LIFX::LAN::Color.white, duration: 0

sleep(0.5)

light.set_color LIFX::LAN::Color.red, duration: 0
