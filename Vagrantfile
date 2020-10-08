# -*- mode: ruby -*-
# Credits for for working around virtualbox stuff for https://github.com/pedrofurtado
# https://github.com/dotless-de/vagrant-vbguest/issues/367
# https://github.com/dotless-de/vagrant-vbguest/pull/373
if defined?(VagrantVbguest)
  class MyWorkaroundInstallerUntilPR373IsMerged < VagrantVbguest::Installers::CentOS
    protected
    
    def has_rel_repo?
      unless instance_variable_defined?(:@has_rel_repo)
        rel = release_version
        @has_rel_repo = communicate.test(centos_8? ? 'yum repolist' : "yum repolist --enablerepo=C#{rel}-base --enablerepo=C#{rel}-updates")
      end
      @has_rel_repo
    end

    def centos_8?
      release_version && release_version.to_s.start_with?('8')
    end

    def install_kernel_devel(opts=nil, &block)
      if centos_8?
        communicate.sudo('yum update -y kernel', opts, &block)
        communicate.sudo('yum install -y kernel-devel', opts, &block)
        communicate.sudo('shutdown -r now', opts, &block)

        begin
          sleep 10
        end until @vm.communicate.ready?
      else
        rel = has_rel_repo? ? release_version : '*'
        cmd = "yum install -y kernel-devel-`uname -r` --enablerepo=C#{rel}-base --enablerepo=C#{rel}-updates"
        communicate.sudo(cmd, opts, &block)
      end
    end
  end
end

Vagrant.configure("2") do |config|

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false
  
  if defined?(MyWorkaroundInstallerUntilPR373IsMerged)
    config.vbguest.installer = MyWorkaroundInstallerUntilPR373IsMerged
  end

  config.vm.define "zimbra" do |box|
    box.vm.box = "centos/8"
    box.vm.box_url = "http://cloud.centos.org/centos/8/x86_64/images/CentOS-8-Vagrant-8.1.1911-20200113.3.x86_64.vagrant-virtualbox.box"
    box.vm.hostname = 'zimbra.example.com'
    box.vm.network "forwarded_port", guest: 7071, host: 7071
    box.vm.network "forwarded_port", guest: 443, host: 8443
    box.vm.synced_folder "vagrant", "/vagrant", type: "virtualbox"
    box.vm.network "private_network", ip: "10.42.42.42"
    box.vm.provider 'virtualbox' do |vb|
      vb.linked_clone = true
      vb.gui = false
      vb.memory = 2048
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--hpet", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
    end
    box.vm.provision "shell" do |s|
      s.path = "vagrant/install_agent.sh"
    end
    box.vm.provision "shell" do |s|
      s.path = "vagrant/run_puppet.sh"
      s.args = ["-b", "/vagrant", "-m", "prepare.pp dns.pp zimbra.pp" ]
    end
  end
end
