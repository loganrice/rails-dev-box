# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box      = 'ubuntu/trusty64'
  config.vm.hostname = 'rails-dev-box'

  config.vm.network :private_network, ip: "10.9.8.7"

  config.vm.provision :shell, path: 'rails-env-provision.sh'
end
