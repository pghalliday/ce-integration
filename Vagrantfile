# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # enable hostmanager to add all machines to each other's /etc/hosts
  config.hostmanager.enabled = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # install chef solo on all machines
  config.omnibus.chef_version = "11.4.4"

  # enable berkshelf
  config.berkshelf.enabled = true

  config.vm.define "haproxy" do |node|
    node.vm.hostname = "haproxy"
    node.vm.network :private_network, ip: "33.33.33.50"
    node.vm.box = "ubuntu1204"
    node.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

    # ensure /etc/hosts is updated before provisioning with chef
    node.vm.provision :hostmanager

    node.vm.provision :chef_solo do |chef|
      chef.json = {
        "haproxy" => {
          "members" => [{
              "hostname" => "ce-front-end-1",
              "ipaddress" => "33.33.33.51"
            }, {
              "hostname" => "ce-front-end-2",
              "ipaddress" => "33.33.33.52"
            }, {
              "hostname" => "ce-front-end-3",
              "ipaddress" => "33.33.33.53"
            }
          ],
          "member_port" => "3000",
          "admin" => {
            "address_bind" => "0.0.0.0",
            "port" => "8000"
          }
        }
      }
      chef.run_list = [
        "recipe[haproxy]"
      ]
    end
  end

  config.vm.define "ce-operation-hub" do |node|
    node.vm.hostname = "ce-operation-hub"
    node.vm.network :private_network, ip: "33.33.33.54"
    node.vm.box = "ubuntu1204"
    node.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

    # ensure /etc/hosts is updated before provisioning with chef
    node.vm.provision :hostmanager

    node.vm.provision :chef_solo do |chef|
      chef.json = {
        "ce_operation_hub" => {
          "destination" => "/vagrant/ce-operation-hub",
          "user" => "vagrant",
          "bind_address" => "tcp://33.33.33.54:4000"
        }
      }
      chef.run_list = [
        "recipe[ce-operation-hub]"
      ]
    end
  end
  
  config.vm.define "ce-front-end-1" do |node|
    node.vm.hostname = "ce-front-end-1"
    node.vm.network :private_network, ip: "33.33.33.51"
    node.vm.box = "ubuntu1204"
    node.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

    # ensure /etc/hosts is updated before provisioning with chef
    node.vm.provision :hostmanager

    node.vm.provision :chef_solo do |chef|
      chef.json = {
        "ce_front_end" => {
          "destination" => "/vagrant/ce-front-end",
          "user" => "vagrant",
          "port" => "3000",
          "ce_operation_hub" => "tcp://33.33.33.54:4000"
        }
      }
      chef.run_list = [
        "recipe[ce-front-end]"
      ]
    end
  end

  config.vm.define "ce-front-end-2" do |node|
    node.vm.hostname = "ce-front-end-2"
    node.vm.network :private_network, ip: "33.33.33.52"
    node.vm.box = "ubuntu1204"
    node.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

    # ensure /etc/hosts is updated before provisioning with chef
    node.vm.provision :hostmanager

    node.vm.provision :chef_solo do |chef|
      chef.json = {
        "ce_front_end" => {
          "destination" => "/vagrant/ce-front-end",
          "user" => "vagrant",
          "port" => "3000",
          "ce_operation_hub" => "tcp://33.33.33.54:4000"
        }
      }
      chef.run_list = [
        "recipe[ce-front-end]"
      ]
    end
  end

  config.vm.define "ce-front-end-3" do |node|
    node.vm.hostname = "ce-front-end-3"
    node.vm.network :private_network, ip: "33.33.33.53"
    node.vm.box = "ubuntu1204"
    node.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

    # ensure /etc/hosts is updated before provisioning with chef
    node.vm.provision :hostmanager

    node.vm.provision :chef_solo do |chef|
      chef.json = {
        "ce_front_end" => {
          "destination" => "/vagrant/ce-front-end",
          "user" => "vagrant",
          "port" => "3000",
          "ce_operation_hub" => "tcp://33.33.33.54:4000"
        }
      }
      chef.run_list = [
        "recipe[ce-front-end]"
      ]
    end
  end

  config.vm.define "ce-engine-1" do |node|
    node.vm.hostname = "ce-engine-1"
    node.vm.network :private_network, ip: "33.33.33.55"
    node.vm.box = "ubuntu1204"
    node.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

    # ensure /etc/hosts is updated before provisioning with chef
    node.vm.provision :hostmanager

    node.vm.provision :chef_solo do |chef|
      chef.json = {
        "ce_engine" => {
          "installDirectory" => "/vagrant/ce-engine"
        }
      }
      chef.run_list = [
        "recipe[ce-engine]"
      ]
    end
  end

  config.vm.define "ce-engine-2" do |node|
    node.vm.hostname = "ce-engine-2"
    node.vm.network :private_network, ip: "33.33.33.56"
    node.vm.box = "ubuntu1204"
    node.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

    # ensure /etc/hosts is updated before provisioning with chef
    node.vm.provision :hostmanager

    node.vm.provision :chef_solo do |chef|
      chef.json = {
        "ce_engine" => {
          "installDirectory" => "/vagrant/ce-engine"
        }
      }
      chef.run_list = [
        "recipe[ce-engine]"
      ]
    end
  end

  config.vm.define "ce-engine-3" do |node|
    node.vm.hostname = "ce-engine-3"
    node.vm.network :private_network, ip: "33.33.33.57"
    node.vm.box = "ubuntu1204"
    node.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

    # ensure /etc/hosts is updated before provisioning with chef
    node.vm.provision :hostmanager

    node.vm.provision :chef_solo do |chef|
      chef.json = {
        "ce_engine" => {
          "installDirectory" => "/vagrant/ce-engine"
        }
      }
      chef.run_list = [
        "recipe[ce-engine]"
      ]
    end
  end

  config.vm.define "test" do |node|
    node.vm.hostname = "test"
    node.vm.network :private_network, ip: "33.33.33.100"
    node.vm.box = "ubuntu1204"
    node.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

    # ensure /etc/hosts is updated before provisioning with chef
    node.vm.provision :hostmanager

    node.vm.provision :chef_solo do |chef|
      chef.run_list = [
        "recipe[test]"
      ]
    end
  end
end
