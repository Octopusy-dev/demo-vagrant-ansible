Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.boot_timeout = 600

  config.vm.provider "virtualbox" do |vb|
    vb.name = "MyDotNetVMv2"
    vb.memory = "4096"
    vb.cpus = 2
  end

  # Provision via Ansible
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "scripts/provision.yml"
  end

end
