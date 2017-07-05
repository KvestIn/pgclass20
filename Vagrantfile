# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  @provider = "virtualbox"
  
  config.vm.provider "hyperv" do |v, override|
    override.vm.box = "kmm/ubuntu-xenial64"
    @provider = "hyperv"
  end

  @dockeruser = if (@provider == "virtualbox") ; then "ubuntu" else "vagrant" end

  config.vm.box_check_update = false
  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "vanessa-dockers/pgsteroids"
  # end
  config.vm.define "first" do |first|
      first.vm.hostname = "pg-first-stage"
      first.vm.network "forwarded_port", guest: 5432, host: 5432
      first.vm.network "forwarded_port", guest: 8081, host: 8081
      first.vm.network "forwarded_port", guest: 8888, host: 8888
      first.vm.network "forwarded_port", guest: 9997, host: 9997
      first.vm.network "forwarded_port", guest: 9998, host: 9998
      first.vm.network "forwarded_port", guest: 9999, host: 9999
      first.vm.provider "virtualbox" do |vb|
         vb.memory = "1024"
         vb.name = "pg-first-stage"
      end

      first.vm.provider "hyperv" do |hv|
        hv.vmname  = "pg-first-stage"
      end
    # run the provisioning only is the first 'vagrant up'
    # config.vm.provision :shell, :inline = @
    if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/first/" + @provider + "/id").empty?
      #   Install Docker
      pkg_cmd = "curl -sSL https://get.docker.com/ | sh;"
      #   Add user to the docker group and install packadges
      pkg_cmd << "usermod -a -G docker " + @dockeruser + " ; "
      pkg_cmd << "apt-get update -y -q; "
      pkg_cmd << "apt-get install dnsmasq python3-pip python-psycopg2 libdbd-pg-perl libdbi-perl docker-compose mc -y -q; "
      config.vm.provision :shell, :inline => pkg_cmd
    end
  end
  config.vm.define "second" do |second|
      second.vm.hostname = "pg-second-stage"
      second.vm.network "forwarded_port", guest: 5432, host: 5432
      second.vm.network "forwarded_port", guest: 8081, host: 8081
      second.vm.network "forwarded_port", guest: 8888, host: 8888
      second.vm.network "forwarded_port", guest: 9997, host: 9997
      second.vm.network "forwarded_port", guest: 9998, host: 9998
      second.vm.network "forwarded_port", guest: 9999, host: 9999

      # first.vm.provider "hyperv" do |vb|
      #   vb.vmname  = "pg-second-stage"
      # end

      second.vm.provider "virtualbox" do |vb|
         vb.memory = "1024"
         vb.name = "pg-second-stage"
         # 0 and 1 port's is for sytem disk
         vdi_logs = '.vagrant/vdi/vdi_logs_ext4.vdi'
         vdi_temp = '.vagrant/vdi/vdi_temp_ext4.vdi'
         vdi_wall = '.vagrant/vdi/vdi_wall_ext4.vdi'
        #  vdi_logs = 'e:/vagrant/vdi/vdi_logs_ext4.vdi'
        #  vdi_temp = 'e:/vagrant/vdi/vdi_temp_ext4.vdi'
        #  vdi_wall = 'e:/vagrant/vdi/vdi_wall_ext4.vdi'
           unless File.exist?(vdi_logs) 
             vb.customize ['createhd', '--filename', vdi_logs, '--size', 250 * 1024]
           end
           unless File.exist?(vdi_temp) 
             vb.customize ['createhd', '--filename', vdi_temp, '--size', 250 * 1024]
           end
           unless File.exist?(vdi_wall) 
             vb.customize ['createhd', '--filename', vdi_wall, '--size', 250 * 1024]
           end
        vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', vdi_logs]
        vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', vdi_temp]
        vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 4, '--device', 0, '--type', 'hdd', '--medium', vdi_wall]
      end
    # run the provisioning only is the first 'vagrant up'
    if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/second/virtualbox/id").empty?
      #   Install Docker
      pkg_cmd = "curl -sSL https://get.docker.com/ | sh; "
      #   Add user to the docker group and install packadges
      pkg_cmd << "usermod -a -G docker ubuntu; "
      config.vm.provision :shell, :inline => pkg_cmd
      #  Install other software
      pkg_cmd = "apt-get install dnsmasq python3-pip python-psycopg2 libdbd-pg-perl libdbi-perl docker-compose mc -y -q; "
      config.vm.provision :shell, :inline => pkg_cmd
      # Create partition
      config.vm.provision "shell", inline: <<-EOF
      parted /dev/sdc mklabel msdos
      parted /dev/sdd mklabel msdos
      parted /dev/sde mklabel msdos
      parted /dev/sdc mkpart primary 512 100%
      parted /dev/sdd mkpart primary 512 100%
      parted /dev/sde mkpart primary 512 100%
      mkfs.ext4 /dev/sdc1
      mkfs.ext4 /dev/sdd1
      mkfs.ext4 /dev/sde1
      mkdir /srv/logs
      mkdir /srv/temp
      mkdir /srv/wall
      echo `blkid /dev/sdc1 | awk '{print$2}' | sed -e 's/"//g'` /srv/logs   ext4   noatime,nobarrier   0   0 >> /etc/fstab
      echo `blkid /dev/sdd1 | awk '{print$2}' | sed -e 's/"//g'` /srv/temp   ext4   noatime,nobarrier   0   0 >> /etc/fstab
      echo `blkid /dev/sde1 | awk '{print$2}' | sed -e 's/"//g'` /srv/wall   ext4   noatime,nobarrier   0   0 >> /etc/fstab
      EOF
    end
  end

  config.vm.define "third" do |third|
      third.vm.hostname = "pg-third-stage"
      third.vm.network "forwarded_port", guest: 5432, host: 5432
      third.vm.network "forwarded_port", guest: 8081, host: 8081
      third.vm.network "forwarded_port", guest: 8888, host: 8888
      third.vm.network "forwarded_port", guest: 9997, host: 9997
      third.vm.network "forwarded_port", guest: 9998, host: 9998
      third.vm.network "forwarded_port", guest: 9999, host: 9999

      # first.vm.provider "hyperv" do |vb|
      #   vb.vmname = "pg-third-stage"
      # end

      third.vm.provider "virtualbox" do |vb|
         vb.memory = "1024"
         vb.name = "pg-third-stage"
         # 0 and 1 port's is for sytem disk
         vdi_logs = '.vagrant/vdi/vdi_logs.vdi'
         vdi_temp = '.vagrant/vdi/vdi_temp.vdi'
         vdi_wall = '.vagrant/vdi/vdi_wall.vdi'
        #  vdi_logs = 'e:/vagrant/vdi/vdi_logs_ext4.vdi'
        #  vdi_temp = 'e:/vagrant/vdi/vdi_temp_ext4.vdi'
        #  vdi_wall = 'e:/vagrant/vdi/vdi_wall_ext4.vdi'
           unless File.exist?(vdi_logs) 
             vb.customize ['createhd', '--filename', vdi_logs, '--size', 250 * 1024]
           end
           unless File.exist?(vdi_temp) 
             vb.customize ['createhd', '--filename', vdi_temp, '--size', 250 * 1024]
           end
           unless File.exist?(vdi_wall) 
             vb.customize ['createhd', '--filename', vdi_wall, '--size', 250 * 1024]
           end
        vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', vdi_logs]
        vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', vdi_temp]
        vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 4, '--device', 0, '--type', 'hdd', '--medium', vdi_wall]
      end
    # run the provisioning only is the first 'vagrant up'
    if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/third/" + @provider + "/id").empty?
      # #   Install Docker
      # pkg_cmd = "sudo su -c 'curl -sSL https://get.docker.com/ | sh;'"
      # #   Add user to the docker group and install packadges
      # pkg_cmd << "usermod -a -G docker " + @dockeruser + " ; "
      # pkg_cmd << "apt-get install dnsmasq python3-pip python-psycopg2 libdbd-pg-perl libdbi-perl docker-compose mc -y -q; "
      # config.vm.provision :shell, :inline => pkg_cmd
      # # TODO add btrfs Create partition
      config.vm.provision "shell", inline: <<-EOF
      parted /dev/sdc mklabel msdos
      parted /dev/sdd mklabel msdos
      parted /dev/sde mklabel msdos
      parted /dev/sdc mkpart primary 512 100%
      parted /dev/sdd mkpart primary 512 100%
      parted /dev/sde mkpart primary 512 100%
      mkfs.btrfs /dev/sdc1
      mkfs.btrfs /dev/sdd1
      mkfs.btrfs /dev/sde1
      mkdir /srv/logs
      mkdir /srv/temp
      mkdir /srv/wall
      EOF
      # # example UUID=a80d0361-27d9-4a46-9ce3-9a0d0be59aa7 /   btrfs subvol=@,compress=lzo       1      1
      # echo `blkid /dev/sdc1 | awk '{print$2}' | sed -e 's/"//g'` /srv/logs   btrfs subvol=@,compress=lzo       1      1 >> /etc/fstab
      # echo `blkid /dev/sdd1 | awk '{print$2}' | sed -e 's/"//g'` /srv/temp   btrfs subvol=@,compress=lzo       1      1 >> /etc/fstab
      # echo `blkid /dev/sde1 | awk '{print$2}' | sed -e 's/"//g'` /srv/wall   btrfs subvol=@,compress=lzo       1      1 >> /etc/fstab
    end
  end
end
