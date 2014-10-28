require 'spec_helper'

describe package 'puppet' do
	it { should be_installed }
end

describe 'It should have the garethr-docker module' do
	describe file '/etc/puppet/modules/docker' do
		it { should be_directory }
		it { should be_mode '755' }
	end
end

