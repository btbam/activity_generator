require_relative '../services/file_create'

describe FileCreate do
  let(:location) { '/tmp/test_file1' }
  let(:file_type) { 'txt' }
  let(:event_name) { 'file_create' }
  let(:event) { { 'location' => location, 'file_type' => file_type, 'event' => event_name } }
  let(:os) { 'mac' }
  let(:fc) { FileCreate.new(event: event, os: os) }

  describe '#initialize' do
    it 'initializes with given values' do
      expect(fc.location).to eq(location)
      expect(fc.file_type).to eq(file_type)
      expect(fc.os).to eq(os)
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
      allow(Process).to receive(:spawn).with(fc.send(:process_command)).and_return(pid)
      allow(Process).to receive(:uid).and_return(uid)
      allow(Etc).to receive(:getpwuid).with(uid).and_return(pwuid)
      allow(pwuid).to receive(:name).and_return('user_name')
      
      result = fc.run

      expect(result).to include(:event_name => event_name)
      expect(result).to include(:timestamp => time_stamp)
      expect(result).to include(:path => location)
      expect(result).to include(:activity => 'create')
      expect(result).to include(:username => 'user_name')
      expect(result).to include(:process_name => 'touch')
      expect(result).to include(:command_line => "touch #{location}.#{file_type}")
      expect(result).to include(:pid => pid)
    end
  end
end
