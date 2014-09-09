describe 'We need our demo user' do
	describe user 'demo' do
		it { should exist }
		it { should belong_to_group 'demo' }
		it { should belong_to_group 'docker' }
	end
end

describe 'We should have apache installed and running' do
	describe package 'apache2' do
		it { should be_installed }
	end
	describe service 'apache2' do
		it { should be_running }
	end
	describe port 80 do
		it { should be_listening }
	end
end

describe 'We should have nsenter installed' do
	describe file '/usr/local/bin/nsenter' do
		it { should be_file }
		it { should be_executable }
	end

	describe command '/usr/local/bin/nsenter --version' do
		its(:stdout) { should match /nsenter.*util-linux 2.24/ }
	end
end

describe 'We should have docker-squash installed' do
	describe file '/usr/local/bin/docker-squash' do
		it { should be_file }
		it { should be_executable }
	end
end

