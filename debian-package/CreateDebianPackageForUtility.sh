rm -rf esh.deb
cp ./AccessEC2MachineonAWS.sh esh/usr/local/bin/esh
sudo dpkg -P esh
sudo dpkg-deb --build esh
sudo dpkg -i esh.deb
