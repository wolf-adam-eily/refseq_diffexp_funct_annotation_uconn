cd ~
wget https://cran.r-project.org/src/base/R-3/R-3.4.3.tar.gz
tar -xzvf R-3.4.3.tar.gz
cd R-3.4.3
./configure --prefix=~/R-3.4.3 --with-x=no --enable-R-shlib=yes --with-cairo=yes --with-readline=no
make
sudo make install
