require_relative '../services/network_transmit'
require 'json'

describe NetworkTransmit do
  let(:destination) { 'http://example.com:80' }
  let(:request_type) { 'POST' }
  let(:request_data) { { foo: 'bar' }.to_json }
  let(:event_name) { 'network_transmit' }
  let(:event) { { 'destination' => destination, 'request_type' => request_type, 'request_data' => request_data, 'event' => event_name } }
  let(:os) { 'mac' }
  let(:nt) { NetworkTransmit.new(event: event, os: os) }

  describe '#initialize' do
    it 'initializes with given values' do
      expect(nt.destination).to eq(destination)
      expect(nt.request_type).to eq(request_type)
      expect(nt.request_data).to eq(request_data)
      expect(nt.os).to eq(os)
    end
  end

  describe '#run' do
    it 'returns a hash of the process information' do
      pid = double('pid')
      time_stamp = double('time_stamp')
      uid = double('uid')
      pwuid = double('pwuid')
      ip_address = double('ip_address')

      allow(Time).to receive(:now).and_return(time_stamp)
      allow(time_stamp).to receive(:to_i).and_return(time_stamp)
      allow(Process).to receive(:spawn).with(nt.send(:process_command)).and_return(pid)
      allow(Process).to receive(:kill).with('KILL', pid).and_return(true)
      allow(Process).to receive(:uid).and_return(uid)
      allow(Etc).to receive(:getpwuid).with(uid).and_return(pwuid)
      allow(pwuid).to receive(:name).and_return('user_name')
      allow(nt).to receive(:source_address).and_return(ip_address)
      
      result = nt.run

      expect(result).to include(:event_name => event_name)
      expect(result).to include(:timestamp => time_stamp)
      expect(result).to include(:username => 'user_name')
      expect(result).to include(:destination_address => destination)
      expect(result).to include(:source_address => ip_address)
      expect(result).to include(:data_amount => '13 bytes')
      expect(result).to include(:protocol => request_type)
      expect(result).to include(:process_name => 'curl')
      expect(result).to include(:command_line => "curl --request #{request_type} --url http://example.com --header 'content-type: application/json' --data '#{request_data}' > /dev/null 2>&1 &")
      expect(result).to include(:pid => pid)
    end
  end
end
