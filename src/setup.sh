mkdir makemkv
cd makemkv
wget https://www.makemkv.com/download/makemkv-bin-1.17.5.tar.gz
wget https://www.makemkv.com/download/makemkv-oss-1.17.5.tar.gz
gunzip makemkv-bin-1.17.5.tar.gz 
gunzip makemkv-oss-1.17.5.tar.gz 
tar -xf makemkv-bin-1.17.5.tar -C .
tar -xf makemkv-oss-1.17.5.tar -C .
rm makemkv-bin-1.17.5.tar makemkv-oss-1.17.5.tar 
sudo apt-get install build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev
cd makemkv-oss-1.17.5
./configure
make
sudo make install
cd ..
cd makemkv-bin-1.17.5/
make
sudo make install
makemkvcon
