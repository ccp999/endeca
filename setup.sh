#!/bin/sh

# fix locale warning
echo LANG=en_US.utf-8 >> /etc/environment
echo LC_ALL=en_US.utf-8 >> /etc/environment

# set to local time zone
# sudo ln -sf ../usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime

# confirm
cat /etc/oracle-release

# install Java 6 JDK
# http://www.gokhanatil.com/2011/07/how-to-installupdate-java-jdk-on-oracle.html
su - vagrant
HOME=/home/vagrant
USERNAME=vagrant
CEL=$HOME/EID/Installers/eidOrch/orchScripts/config_EID_linux.prop
CL=$HOME/EID/Installers/eidOrch/orchScripts/ES_linux_OC/config_linux.prop
CPL=$HOME/EID/Installers/eidOrch/orchScripts/PS_linux_OC/config_PS_linux.prop
CSL=$HOME/EID/Installers/eidOrch/orchScripts/Studio_linux_OC/config_Studio_linux.prop

cd $HOME
mkdir -p java
cd java
cp /vagrant/jdk-6u45-linux-x64-rpm.bin .
chmod +x jdk-6u45-linux-x64-rpm.bin
sudo ./jdk-6u45-linux-x64-rpm.bin

# confirm Java installation
java -version

cd ..
mkdir -p EID/Installers
cd EID/Installers
unzip /vagrant/V40541-01.zip -d .
unzip /vagrant/V42127-01.zip -d .
unzip EID_3.1_Studio_InstallLinux.zip -d .
ls -l
mv endecaserver.zip ./eidOrch/installers/
tar -xvf linux_OC.tar
mv linux ES_linux_OC
mv ES_linux_OC/ ./eidOrch/orchScripts/
unzip /vagrant/V29856-01.zip -d .
mv wls1036_generic.jar ./eidOrch/installers/
unzip /vagrant/V29673-01.zip -d .
cd V29673-01
zip -d $HOME/EID/Installers/eidOrch/installers/ofm_appdev_generic_11.1.1.6.0_disk1_1of1.zip *
cd ..
rm -rf V29673-01
# cp /vagrant/Modified-V29673-01.zip ./eidOrch/installers/ofm_appdev_generic_11.1.1.6.0_disk1_1of1.zip

sudo sed -i "s|127.0.0.1  endeca-dev.brendan.1pp.hk endeca-dev localhost localhost.localdomain localhost4 localhost4.localdomain4|10.0.3.8  endeca-dev.brendan.1pp.hk endeca-dev\n 127.0.0.1  localhost localhost.localdomain localhost4 localhost4.localdomain4|g" /etc/hosts

# Configuration settings
sed -i "s|USE_SSL=TRUE|USE_SSL=FALSE|g" $CEL
sed -i "s|JAVA_HOME=/usr/java/default|JAVA_HOME=/usr/java/jdk1.6.0_45/|g" $CEL
sed -i "s|ORACLE_HOME=/home/USERNAME/Oracle/Middleware_Orch|ORACLE_HOME=/home/$USERNAME/Oracle/Middleware_Orch|g" $CEL
sed -i "s|INSTALLER_LOCATION=/home/USERNAME/eidOrch/installers|INSTALLER_LOCATION=/home/$USERNAME/EID/Installers/eidOrch/installers|g" $CEL

#INSTALL_MODE=INSTALL_ALL | INSTALL_ALL_AND_CONFIGURE
# sed -i "s|INSTALL_MODE=INSTALL_ALL_AND_CONFIGURE|INSTALL_MODE=INSTALL_ALL|g" $CL
# #START_MODE=PROD|DEV
sed -i "s|START_MODE=PROD|START_MODE=DEV|g" $CL
sed -i "s|JAVA_HOME=/usr/java/default|JAVA_HOME=/usr/java/jdk1.6.0_45/|g" $CL
sed -i "s|ORACLE_HOME=/home/user/Weblogic/Oracle/Middleware|ORACLE_HOME=/home/$USERNAME/Oracle/Middleware_Orch|g" $CL
sed -i "s|INSTALLER_LOCATION=/home/user/Installers|INSTALLER_LOCATION=/home/$USERNAME/EID/Installers/eidOrch/installers/|g" $CL
sed -i "s|DEPLOY_ENDECA_SERVER_IN_SECURE_MODE=TRUE|DEPLOY_ENDECA_SERVER_IN_SECURE_MODE=FALSE|g" $CL

sed -i "s|JAVA_HOME=/usr/java/default|JAVA_HOME=/usr/java/jdk1.6.0_45/|g" $CPL
sed -i "s|ORACLE_HOME=/home/USERNAME/Oracle/Middleware_Orch|ORACLE_HOME=/home/$USERNAME/Oracle/Middleware_Orch|g" $CPL
sed -i "s|DEPLOY_ENDECA_PS_IN_SECURE_MODE=TRUE|DEPLOY_ENDECA_PS_IN_SECURE_MODE=FALSE|g" $CPL
sed -i "s|INSTALLER_LOCATION=/home/USERNAME/EID/Installers|INSTALLER_LOCATION=/home/$USERNAME/EID/Installers/eidOrch/installers|g" $CPL

sed -i "s|JAVA_HOME=/usr/java/default|JAVA_HOME=/usr/java/jdk1.6.0_45/|g" $CSL
sed -i "s|ORACLE_HOME=/home/USERNAME/Oracle/Middleware_Orch|ORACLE_HOME=/home/$USERNAME/Oracle/Middleware_Orch|g" $CSL
sed -i "s|INSTALLER_LOCATION=/home/USERNAME/EID/Installers|INSTALLER_LOCATION=/home/$USERNAME/EID/Installers/eidOrch/installers|g" $CSL
sed -i "s|DEPLOY_ENDECA_STUDIO_IN_SECURE_MODE=TRUE|DEPLOY_ENDECA_STUDIO_IN_SECURE_MODE=FALSE|g" $CSL

mkdir -p /vagrant/tmp
sudo chown -R vagrant:vagrant /home/vagrant/EID /vagrant/tmp /tmp
cd eidOrch/orchScripts
chmod +x run_EID_install.sh