require_relative 'file_base'

class FileCreate < FileBase

  private

  def activity
    @activity ||= 'create'
  end

  def process_name
    @process_name ||= case os
                      when 'windows'
                        'echo'
                      else
                        'touch'
                      end
  end

  def process_command
    @process_command ||= case os
                         when 'windows'
                           "echo.> #{location}.#{file_type}"
                         else
                           "touch #{location}.#{file_type}"
                         end
  end
end
