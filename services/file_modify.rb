require_relative 'file_base'

class FileModify < FileBase
  
  private

  def activity
    @activity ||= 'modify'
  end

  def process_name
    @process_name ||= case os
                      when 'windows'
                        '>>'
                      else
                        '>>'
                      end
  end

  def process_command
    @process_command ||= case os
                         when 'windows'
                           "type 'abcdefg' >> #{location}.#{file_type}"
                         else
                           "echo 'abcdefg' >> #{location}.#{file_type}"
                         end
  end
end
