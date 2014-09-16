# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # https://sites.google.com/a/stoilis.gr/oracle-linux-vagrant-boxes/home
  # root's passowrd vagrant 
  # vagrant / vagrant
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "box-cutter/oel65"
  config.vm.hostname = "endeca-dev.brendan.1pp.hk"

  # auto-update guest additions so we can ssh into the box
  config.vbguest.auto_update = true

  # Set the Timezone to host timezone 
  # https://coderwall.com/p/v8fr2g
  require 'time' 
  offset = ((Time.zone_offset(Time.now.zone)/60)/60) 
  zonesufix = offset >= 0 ? "+#{offset.to_s}" : "#{offset.to_s}" 
  timezone = 'Etc/GMT' + zonesufix 
  config.vm.provision :shell, :inline => "echo \"#{timezone}\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  # if use OS X Host
  # read this link
  # http://www.jaimegago.com/dynamic-guestrhel6-and-cousinshostos-x-time-zone-sync-in-vagrant-virtualbox-provider/

  # if not working, try
  # ls /usr/share/zoneinfo
  # sudo ln -sf ../usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime

  # run setup.sh
  config.vm.provision "shell", path: "setup.sh"
 
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 7001, host: 7001

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
config.vm.network "private_network", ip: "10.0.3.8"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
     # Don't boot with headless mode
     # vb.gui = true
     vb.name = "endeca_single_vm"
     # Use VBoxManage to customize the VM. For example to change memory:
     vb.customize ["modifyvm", :id, "--memory", "2048"]
     # vb.customize ["createhd", "--filename", "endeca_single_vm", "--size", "15000"]
     # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
     # vb.customize ["setextradata", :id, "VBoxInternal/Devices/e1000/0/LUN#0/Config/HostResolverMappings/all_blocked_site/HostIP", "127.0.0.1"]
     # vb.customize ["setextradata", :id, "VBoxInternal/Devices/e1000/0/LUN#0/Config/HostResolverMappings/all_blocked_site/HostNamePattern", "*.brendan.*|*.1pp.hk"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = "motd.cf"
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.policy_server_address = "10.0.2.15"
  # end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { mysql_password: "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
