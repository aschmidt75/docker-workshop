# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # forward presentation port (connected to presentation container)
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  # Ubuntu 14.04 (trusty tahr, 64bit)
  config.vm.box 	= 'trusty64'
  config.vm.box_url 	= "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.hostname 	= 'docker-workshop'

  config.vm.define "docker-workshop-vm", primary: true do |s|
    # mounts
    s.vm.synced_folder "spec.d/", "/mnt/spec.d"
    s.vm.synced_folder "docker.d/", "/mnt/docker.d"
    s.vm.synced_folder "suppl/dynupd-etcd-registrator", "/mnt/dynupd"
    s.vm.synced_folder "suppl/bin", "/mnt/bin"

    # memory settings
    s.vm.provider "virtualbox" do |vb|
    	vb.gui = false
        vb.customize [ "modifyvm", :id, "--memory", "1024"]
        vb.customize [ "modifyvm", :id, "--cpus", "1"]
    end

    s.vm.provision "shell", path: 'provision.d/01_os_initial.sh'
    s.vm.provision "shell", path: 'provision.d/02_os_remove_unwanted.sh'

    # -- PART Microservices
    # download stuff we need as packages, so we do not need
    # wifi during the workshop
    s.vm.provision "shell", path: 'provision.d/30_apache_packages.sh'

    # install puppet module for docker
    # image already contains puppet
    s.vm.provision "shell", path: 'provision.d/10_puppet_install.sh'

    # provision the node
    s.vm.provision :puppet, :options => "--verbose" do |puppet|
 	puppet.manifests_path = "puppet.d/manifests"
	puppet.module_path = "puppet.d/modules"
        puppet.manifest_file = "default.pp"
    end

    # demo user fix
    s.vm.provision "shell", inline:
	    'sudo usermod -G docker demo'

    # install nsenter
    # from: https://blog.codecentric.de/2014/07/vier-wege-in-den-docker-container/
    s.vm.provision "shell", path: 'provision.d/51_nsenter.sh'

    # Install fig via pip
    s.vm.provision "shell", path: 'provision.d/52_fig.sh'

    # download and unpack docker squash
    # https://github.com/jwilder/docker-squash
    s.vm.provision "shell", path: 'provision.d/53_docker-squash.sh'

    # download and set up registry
    s.vm.provision "shell", path: 'provision.d/60_registry.sh'

    # pull demo image(s) through our private registry
    s.vm.provision "shell", path: 'provision.d/65_pull_demo_images.sh'

    # get us some etcd
    s.vm.provision "shell", path: 'provision.d/71_etcd.sh'

    # and progriums' registrator as well
    s.vm.provision "shell", path: 'provision.d/72_registrator.sh'

    # install and run serverspec
    s.vm.provision "shell", path: 'provision.d/91_serverspec.sh'
    s.vm.provision "shell", path: 'provision.d/98_run_spec.sh'

    s.vm.provision "shell", path: 'provision.d/99_provisoned.sh'
  end

end
