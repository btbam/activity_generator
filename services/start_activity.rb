require 'os'
require 'json'

class StartActivity
  attr_accessor :input_file, :output_file

  include ResultLogger

  def initialize(input_file:, output_file: './event_results.json')
    fail 'ProcessActivity::input_file cannot be blank' if input_file.nil? || input_file.empty?

    @input_file = input_file
    @output_file = output_file
  end

  def run
    events_hash = json_hash.map do |event|
      case event['event']
      when 'process_start'
        ProcessStart.new(event: event, os: os).run
      when 'file_create'
        FileCreate.new(event: event, os: os).run
      when 'file_modify'
        FileModify.new(event: event, os: os).run
      when 'file_delete'
        FileDelete.new(event: event, os: os).run
      when 'network_transmit'
        NetworkTransmit.new(event: event, os: os).run
      else
        fail "Unknown event: #{event['event']}"
      end
    end

    log_results(events: events_hash, filename: output_file)
  end

  private

  def json_hash
    @json_hash ||= JSON.parse(File.read(input_file))
  end

  def os
    @os ||= case 
            when OS.mac?
              'mac'
            when OS.linux?
              'linux'
            when OS.windows?
              'windows'
            else
              fail "OS is not supported: #{OS.report}"
            end
  end
end
