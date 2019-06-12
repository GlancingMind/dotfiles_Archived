Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"
  config.vm.hostname = "arch"
  config.vm.define "arch"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "arch"
    vb.cpus = 2
    vb.memory = 2048
  end

  config.vm.provision "shell", inline: "sudo pacman -Syu --noconfirm python"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "setup.yml"
  end
end
