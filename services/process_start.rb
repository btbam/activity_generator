require 'etc'

class ProcessStart
  attr_reader :executable_path, :arguments, :options, :event_name, :os

  def initialize(event: {}, os:)
    @executable_path = event['executable_path']
    @arguments = event['arguments']
    @options = event['options']
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
      process_name: process_name,
      command_line: process_command,
      pid: pid 
    }
  end

  private

  def process_name
    @process_name ||= case os
                      when 'windows'
                        executable_path.split('\\').last
                      else
                        executable_path.split('/').last
                      end
  end

  def process_command
    @process_command ||= case os
                         when 'windows'
                           "start /B #{executable_path} #{options} #{arguments} > NUL 2>&1"
                         else
                           "#{executable_path} #{options} #{arguments} > /dev/null 2>&1 &"
                         end
  end
end
