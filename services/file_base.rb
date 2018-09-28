require 'etc'

class FileBase
  attr_reader :location, :file_type, :process_name, :process_command, :event_name, :os

  def initialize(event: {}, os:)
    @location = event['location']
    @file_type = event['file_type']
    @process_name = event['process_name']
    @process_command = event['process_command']
    @event_name = event['event']
    @os = os
  end

  def run
    timestamp = Time.now.to_i
    pid = Process.spawn(process_command)
    { 
      event_name: event_name,
      timestamp: timestamp,
      path: location,
      activity: activity,
      username: Etc.getpwuid(Process.uid).name,
      process_name: process_name,
      command_line: process_command,
      pid: pid 
    }
  end

  private

  def activity
    fail 'FileBase activity must be implemented in subclass'
  end

  def process_name
    fail 'FileBase process_name must be implemented in subclass'
  end

  def process_command
    fail 'FileBase process_command must be implemented in subclass'
  end
end
