Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 1
  end

  config.vm.define "yolo-db" do |db|
    db.vm.hostname = "yolo-db"
    db.vm.network "private_network", ip: "192.168.56.10"
    db.vm.network "forwarded_port", guest: 27017, host: 27017, auto_correct: true
    db.vm.synced_folder ".", "/vagrant", disabled: false
    db.vm.provider "virtualbox" do |vb| vb.memory = 1536 end
  end

  config.vm.define "yolo-backend" do |be|
    be.vm.hostname = "yolo-backend"
    be.vm.network "private_network", ip: "192.168.56.11"
    be.vm.network "forwarded_port", guest: 5000, host: 5000, auto_correct: true
    be.vm.synced_folder ".", "/vagrant", disabled: false
  end

  config.vm.define "yolo-frontend" do |fe|
    fe.vm.hostname = "yolo-frontend"
    fe.vm.network "private_network", ip: "192.168.56.12"
    fe.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true
    fe.vm.synced_folder ".", "/vagrant", disabled: false
  end
end