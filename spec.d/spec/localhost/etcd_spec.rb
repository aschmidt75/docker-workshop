require 'spec_helper.rb'

describe 'It should have etcd installed and running' do
	describe file '/usr/local/bin/etcd' do
		it { should be_file }
		it { should be_executable }
	end
	describe file '/usr/local/bin/etcdctl' do
		it { should be_file }
		it { should be_executable }
	end
	describe command '/usr/local/bin/etcdctl -v' do
		its(:stdout) { should match /^etcdctl version 0\.4\.6/ }
	end
	
	describe process 'etcd' do
		it { should be_running }
	end
	
	describe port 4001 do
		it { should be_listening }
	end

	describe file '/var/log/etcd.log' do
		it { should be_file }
	end
end

describe port 7001 do
	it { should be_listening }
end

