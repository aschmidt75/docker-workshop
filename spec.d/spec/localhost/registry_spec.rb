require 'spec_helper.rb'

describe 'It should have a docker registry installed' do
	describe command('docker images registry') do 
		its(:stdout) { should match /^registry.*latest.*/ }
	end
	describe file '/usr/local/bin/start_registry.sh' do
		it { should be_file }
		it { should be_executable }
	end
	describe command 'docker inspect registry' do
		its(:stdout) { should match /Running.*: true/ }
		it { should return_exit_status(0) }
	end
	describe port 5000 do
		it { should be_listening }
	end
end
	
