require 'etc'
require 'socket'

class NetworkTransmit
  attr_reader :destination, :request_type, :request_data, :event_name, :os

  def initialize(event: {}, os:)
    @destination = event['destination']
    @request_type = event['request_type']
    @request_data = event['request_data']
    @event_name = event['event']
    @os = os
  end

  def run
    timestamp = Time.now.to_i
    pid = Process.spawn(process_command)
    Process.kill('KILL', pid)
    { 
      event_name: event_name,
      timestamp: timestamp,
      username: Etc.getpwuid(Process.uid).name,
      destination_address: destination,
      source_address: source_address,
      data_amount: data_amount,
      protocol: request_type,
      process_name: process_name,
      command_line: process_command,
      pid: pid 
    }
  end

  private

  def data_amount
    @data_amount ||= "#{request_data.bytesize} bytes"
  end

  def source_address
    # I'm aware this is network local, not sure how to get my 'real' IP without a request
    @source_address ||= [Socket.ip_address_list[4].ip_address, Socket.getservbyname("http").to_s].join(':')
  end

  def process_name
    @process_name ||= case os
                      when 'windows'
                        'curl'
                      else
                        'curl'
                      end
  end

  def process_command
    @process_command ||= case os
                         when 'windows'
                           "curl --request #{request_type} --url http://example.com --header 'content-type: application/json' --data '#{request_data}' > NUL 2>&1"
                         else
                           "curl --request #{request_type} --url http://example.com --header 'content-type: application/json' --data '#{request_data}' > /dev/null 2>&1 &"
                         end
  end
end
