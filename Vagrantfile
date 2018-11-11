
Vagrant.configure("2") do |config|
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "base"
  
  # config.vm.box = "hashicorp/precise64"
  # config.vm.box_version = "1.1.0"
  # config.vm.box_url = "https://vagrantcloud.com/hashicorp/precise64"
  
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/xenial64"
  
  config.vm.provider "virtualbox" do |v|
		v.memory = 8196
        v.cpus = 2
#	v.gui = true
#	v.name = "MyVagrantBox"
  end
  
  config.vm.provision :shell, :privileged => true, :path => "setup.sh"
  
end
