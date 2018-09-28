require 'json'

module ResultLogger
  def log_results(events: [], filename:)
    fail 'ResultLogger::filename cannot be blank' if filename.nil? || filename.empty?

    File.open(filename, 'w') do |file|
      file.puts events.to_json
    end
  end
end
