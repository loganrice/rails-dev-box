# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = "rails"
  config.vm.network :private_network, ip: "192.168.33.8"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024", "--cpuexecutioncap", "50"]
  end

  # Use NFS for shared folders for better performance
  config.vm.synced_folder '.', '/vagrant', nfs: true

  config.vm.provision :shell, path: 'rails-env-provision.sh', keep_color: true
end
