#!/bin/bash
set -eu -o pipefail

# install build deps
add-apt-repository ppa:ethereum/ethereum
apt-get update
apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk

# install constellation
CREL=constellation-0.2.0-ubuntu1604
#wget -q https://github.com/jpmorganchase/constellation/releases/download/v0.2.0/$CREL.tar.xz
wget -q http://qa-wxtrust-jws.wancloud.io/$CREL.tar.xz
tar xfJ $CREL.tar.xz
cp $CREL/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
rm -rf $CREL

# install golang
GOREL=go1.7.3.linux-amd64.tar.gz
#wget -q https://storage.googleapis.com/golang/$GOREL
wget -q http://qa-wxtrust-jws.wancloud.io/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
PATH=$PATH:/usr/local/go/bin
echo 'PATH=$PATH:/usr/local/go/bin' >> /home/ubuntu/.bashrc

# make/install quorum
git clone https://github.com/jpmorganchase/quorum.git
pushd quorum >/dev/null
git checkout tags/v2.0.0
make all
cp build/bin/geth /usr/local/bin
cp build/bin/bootnode /usr/local/bin
popd >/dev/null

# install Porosity
#wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
wget -q http://qa-wxtrust-jws.wancloud.io/porosity
mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity

# copy examples
cp -r /vagrant/examples /home/ubuntu/quorum-examples
chown -R ubuntu:ubuntu /home/ubuntu/quorum /home/ubuntu/quorum-examples

# done!
banner "Quorum"
echo
echo 'The Quorum vagrant instance has been provisioned. Examples are available in ~/quorum-examples inside the instance.'
echo "Use 'vagrant ssh' to open a terminal, 'vagrant suspend' to stop the instance, and 'vagrant destroy' to remove it."
