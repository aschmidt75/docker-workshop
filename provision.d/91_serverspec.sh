( sudo gem list --local | grep -q rake ) || {
	sudo gem install rake -v '10.3.2' --no-ri --no-rdoc
}
( sudo gem list --local | grep -q rspec ) || {
	sudo gem install rspec -v '2.99.0' --no-ri --no-rdoc
}
( sudo gem list --local | grep -q specinfra ) || {
	sudo gem install specinfra -v '1.21.0' --no-ri --no-rdoc
}
( sudo gem list --local | grep -q serverspec ) || {
	sudo gem install serverspec -v '1.10.0' --no-ri --no-rdoc
}
