#Vagrant
Install [Vagrant](http://www.vagrantup.com/downloads.html)

	vagrant init hashicorp/precise32
	vagrant up

Setup vagrant port forwarding, edit Vagrantfile and uncomment the config.vm.network and edit ports

	config.vm.network "forwarded_port", guest: 3000, host: 3001

This example will allow you to access the Reaction/Meteor server on port localhost:3001 in the host machine browser.

#Ubuntu

	sudo apt-get update
	sudo apt-get install -y python-software-properties python g++ make
	sudo add-apt-repository ppa:chris-lea/node.js
	sudo apt-get update
	sudo apt-get install nodejs curl git
	sudo npm install -g meteorite
	git clone https://github.com/ongoworks/reaction.git
	cd reaction
	mrt update
	
	
	cp /home/vagrant/reaction/bin/../settings/dev.sample.json /home/vagrant/reaction/bin/../settings/dev.json
	sudo ./bin/run

