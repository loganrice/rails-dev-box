# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty32"

  config.vm.network "forwarded_port", guest: 3000, host: 3000
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
end