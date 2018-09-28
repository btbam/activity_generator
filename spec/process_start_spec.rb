require_relative '../services/process_start'

describe ProcessStart do
  let(:executable_path) { '/usr/bin/vi' }
  let(:arguments) { '/tmp/myfile.txt' }
  let(:options) { '-n' }
  let(:event_name) { 'process_start' }
  let(:event) { { 'executable_path' => executable_path, 'arguments' => arguments, 'options' => options, 'event' => event_name } }
  let(:os) { 'mac' }
  let(:ps) { ProcessStart.new(event: event, os: os) }

  describe '#initialize' do
    it 'initializes with given values' do
      expect(ps.executable_path).to eq(executable_path)
      expect(ps.arguments).to eq(arguments)
      expect(ps.options).to eq(options)
      expect(ps.os).to eq(os)
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
      allow(Process).to receive(:spawn).with(ps.send(:process_command)).and_return(pid)
      allow(Process).to receive(:kill).with('KILL', pid).and_return(true)
      allow(Process).to receive(:uid).and_return(uid)
      allow(Etc).to receive(:getpwuid).with(uid).and_return(pwuid)
      allow(pwuid).to receive(:name).and_return('user_name')
      
      result = ps.run

      expect(result).to include(:event_name => event_name)
      expect(result).to include(:timestamp => time_stamp)
      expect(result).to include(:username => 'user_name')
      expect(result).to include(:process_name => 'vi')
      expect(result).to include(:command_line => "#{executable_path} #{options} #{arguments} > /dev/null 2>&1 &")
      expect(result).to include(:pid => pid)
    end
  end
end
