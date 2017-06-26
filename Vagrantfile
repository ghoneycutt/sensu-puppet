# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  # unfortunately the puppet provisioner requires guest additions
  # as they can't be installed for all possible virtual platforms and versions we simply use shell
  config.vm.define "sensu-server", primary: true, autostart: true do |server|
    server.vm.box = "centos/7"
    server.vm.hostname = 'sensu-server.domain.local'
    server.vm.network :private_network, ip: "192.168.56.10"
    server.vm.provision :shell, :path => "tests/provision_basic.sh"
    server.vm.provision :shell, :path => "tests/provision_server.sh"
    server.vm.provision :shell, :path => "tests/rabbitmq.sh"
  end

  config.vm.define "sensu-client", autostart: true do |client|
    client.vm.box = "centos/7"
    client.vm.hostname = 'sensu-client.domain.local'
    client.vm.network  :private_network, ip: "192.168.56.11"
    client.vm.provision :shell, :path => "tests/provision_basic.sh"
    client.vm.provision :shell, :path => "tests/provision_client.sh"
  end
end
