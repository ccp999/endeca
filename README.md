endeca
======

Preparing file structure for Server, Studio and Provisioning Domain Insatalled in Single VirtualBox VM under Linux.
Installing script will be edited for later running in Install with configuration mode.

Requirements:

1. Install VirtualBox latest version; http://www.virtualbox.org/wiki/Downloads 
2. Vagrant 1.6.5+; http://downloads.vagrantup.com/
3. Download Endeca related files into the directory:

	V40541-01.zip, 
	V42127-01.zip, 
	V29856-01.zip, 
	V29673-01.zip

4. go into the project directory and

	vagrant up

5. log into the vm by

	vagrant ssh

6. After go inside the vm, run

	cd $HOME/EID/Installers/eidOrch/orchScripts
	./run_EID_install.sh config_EID_linux.prop --temp-directory /vagrant/tmp

note: you will be asked to provided:

	* Endeca Server Weblogic domain administrator username and password
	* Endeca Studio Weblogic domain administrator username and password
	* Provisioing Service Weblogic domain administrator username and password

As this setup is intended for demo or development use, secure mode is non and no passphrase is required.

After installation completedly succeeded, go to home directory and run start servers script

	start_all.sh

To stop,

	stop_all.sh
