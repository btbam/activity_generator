require_relative 'file_base'

class FileDelete < FileBase
  
  private

  def activity
    @activity ||= 'delete'
  end

  def process_name
    @process_name ||= case os
                      when 'windows'
                        'DEL'
                      else
                        'rm'
                      end
  end

  def process_command
    @process_command ||= case os
                         when 'windows'
                           "DEL #{location}.#{file_type}"
                         else
                           "rm #{location}.#{file_type} > /dev/null 2>&1 &"
                         end
  end
end
