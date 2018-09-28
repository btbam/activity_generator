require_relative '../services/file_modify'

describe FileModify do
  let(:location) { '/tmp/test_file1' }
  let(:file_type) { 'txt' }
  let(:event_name) { 'file_modify' }
  let(:event) { { 'location' => location, 'file_type' => file_type, 'event' => event_name } }
  let(:os) { 'mac' }
  let(:fm) { FileModify.new(event: event, os: os) }

  describe '#initialize' do
    it 'initializes with given values' do
      expect(fm.location).to eq(location)
      expect(fm.file_type).to eq(file_type)
      expect(fm.os).to eq(os)
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
      allow(Process).to receive(:spawn).with(fm.send(:process_command)).and_return(pid)
      allow(Process).to receive(:uid).and_return(uid)
      allow(Etc).to receive(:getpwuid).with(uid).and_return(pwuid)
      allow(pwuid).to receive(:name).and_return('user_name')
      
      result = fm.run

      expect(result).to include(:event_name => event_name)
      expect(result).to include(:timestamp => time_stamp)
      expect(result).to include(:path => location)
      expect(result).to include(:activity => 'modify')
      expect(result).to include(:username => 'user_name')
      expect(result).to include(:process_name => '>>')
      expect(result).to include(:command_line => "echo 'abcdefg' >> #{location}.#{file_type}")
      expect(result).to include(:pid => pid)
    end
  end
end
