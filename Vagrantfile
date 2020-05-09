# -*- mode: ruby -*-

Vagrant.configure("2") do |config|

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "db" do |box|
    box.vm.box = "centos/7"
    box.vm.box_version = "1901.01"
    box.vm.hostname = 'zimbra.local'
    box.vm.synced_folder '.', '/vagrant'
    box.hostmanager.manage_guest = true
    box.hostmanager.aliases = %w(zimbra mail.local)
    box.vm.network "private_network", ip: "10.42.42.42"
    box.vm.provider 'virtualbox' do |vb|
      vb.linked_clone = true
      vb.gui = false
      vb.memory = 1024
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--hpet", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
    end
    box.vm.provision "shell" do |s|
      s.path = "vagrant/install_agent.sh"
    end
    box.vm.provision "shell" do |s|
      s.path = "vagrant/run_puppet.sh"
      s.args = ["-b", "/vagrant", "-m", "prepare.pp zimbra.pp" ]
    end
  end
end
