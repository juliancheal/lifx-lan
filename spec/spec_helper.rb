require 'bundler'
Bundler.require
begin
  require 'pry'
rescue LoadError
end

require 'lifx-lan'
require 'lifx/lan/utilities'

shared_context 'integration', integration: true do
  def lifx
    $lifx ||= begin
      c = LIFX::LAN::Client.lan
      begin
        c.discover! do
          c.tags.include?('_Test') && c.lights.with_tag('_Test').count > 0
        end
      rescue LIFX::LAN::Client::DiscoveryTimeout
        raise "Could not find any lights with tag _Test in #{c.lights.inspect}"
      end
      c
    end
  end

  def flush
    lifx.flush
  end

  let(:lights) { lifx.lights.with_tag('_Test') }
  let(:light) { lights.first }
end

module SpecHelpers
  def wait(timeout: 5, retry_wait: 0.1, &block)
    Timeout.timeout(timeout) do
      begin
        block.call
      rescue RSpec::Expectations::ExpectationNotMetError
        lights.refresh
        sleep(retry_wait)
        retry
      end
    end
  rescue Timeout::Error
    block.call
  end
end

LIFX::LAN::Config.logger = Yell.new(STDERR) if ENV['DEBUG']

RSpec.configure do |config|
  config.include(SpecHelpers)
  config.formatter = 'documentation'
  config.color = true
end
