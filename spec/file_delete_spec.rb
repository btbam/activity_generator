require_relative '../services/file_delete'

describe FileDelete do
  let(:location) { '/tmp/test_file1' }
  let(:file_type) { 'txt' }
  let(:event_name) { 'file_delete' }
  let(:event) { { 'location' => location, 'file_type' => file_type, 'event' => event_name } }
  let(:os) { 'mac' }
  let(:fd) { FileDelete.new(event: event, os: os) }

  describe '#initialize' do
    it 'initializes with given values' do
      expect(fd.location).to eq(location)
      expect(fd.file_type).to eq(file_type)
      expect(fd.os).to eq(os)
    end
  end

  describe '#run' do
    it 'returns a hash of the process information' do
      pid = double('pid')
      time_stamp = double('time_stamp')
      uid = double('uid')
      pwuid = double('pwuid')

      allow(Time).to receive(:now).and_return(time_stamp)
      allow(time_stamp).to receive(:to_i).and_return(time_stamp)
      allow(Process).to receive(:spawn).with(fd.send(:process_command)).and_return(pid)
      allow(Process).to receive(:uid).and_return(uid)
      allow(Etc).to receive(:getpwuid).with(uid).and_return(pwuid)
      allow(pwuid).to receive(:name).and_return('user_name')
      
      result = fd.run

      expect(result).to include(:event_name => event_name)
      expect(result).to include(:timestamp => time_stamp)
      expect(result).to include(:path => location)
      expect(result).to include(:activity => 'delete')
      expect(result).to include(:username => 'user_name')
      expect(result).to include(:process_name => 'rm')
      expect(result).to include(:command_line => "rm #{location}.#{file_type} > /dev/null 2>&1 &")
      expect(result).to include(:pid => pid)
    end
  end
end
