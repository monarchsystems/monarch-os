#!/bin/bash
#MONARCH dev suite installer
#for use on a freshly updated rpi os install

#TODO put sudos back in appropriate places

function intro_message_func {
echo "Monarch Development Environment Initialization script"
echo "0.0 Feb 14, 2021"
read -rsn1 -p "Press any key to continue..."; echo
}

function install_explain-func {
clear;
echo "COMPONENTS TO INSTALL:"
echo "git"
echo "arduino-cli"
echo "-duevga library"
echo "icestorm-template"
echo "rv32i-gcc"
echo "tinyprog"
echo "Athena system repository"
echo "-"
read -rsn1 -p "Press any key to continue..."; echo
}

function git_install-func {
clear;
sudo apt-get install git-all
echo "'git' installation complete"
read -rsn1 -p "Press any key to continue..."; echo
}

function arduino_install-func {
clear;
cd /usr/
sudo curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh --output install.sh
sudo chmod +x install.sh
sudo ./install.sh
arduino-cli core install arduino:sam
sudo usermod -a -G dialout $USER
cd -
echo "'arduino-cli' installation complete"
read -rsn1 -p "Press any key to continue..."; echo
}

function duevga_install-func {
clear;
ls
cd /home/$USER
mkdir Arduino 
cd Arduino
mkdir libraries 
cd libraries
git clone https://github.com/stimmer/DueVGA
ls -d $PWD/*
mv DueVGA/VGA /home/$USER/Arduino/libraries
#rm -rv DueVGA
cd -
echo "'DueVGA' library installation complete"
read -rsn1 -p "Press any key to continue..."; echo
}

function icestorm-template_install-func {
clear;
sudo apt-get install build-essential clang bison flex \
libreadline-dev gawk tcl-dev libffi-dev git mercurial \
graphviz xdot pkg-config python python3 libftdi-dev
mkdir icestorm-build
cd icestorm-build
git clone git://github.com/cliffordworlf/icestorm.git icestorm
cd icestorm
make -j$(nproc)
sudo make install
cd ..
git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
make -j$(nproc)
sudo make install
cd ..
git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
make -j$(nproc)
sudo make install 
cd ..
cd ..
rm -rv icestorm-build
echo "'icestorm-template' suite installation complete."
read -rsn1 -p "Press any key to continue..."; echo
}

function rv32i-gcc_install-func {
clear;
sudo apt-get install autoconf automake autotools-dev curl libmpc-dev \
libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
gperf libtool patchutils bc zlib1g-dev git libexpat1-dev
sudo mkdir /opt/riscv32i
sudo chown $USER /opt/riscv32i
git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i
cd riscv-gnu-toolchain-rv32i
git checkout 411d134
git submodule update --init --recursive
mkdir build; cd build
../configure --with-arch=rv32i --prefix=/opt/riscv32i
make -j$(nproc)
echo "RV32I toolchain built"
read -rsn1 -p "Press any key to continue..."; echo
}
#MAIN PROGRAM BODY
intro_message_func
install_explain-func
git_install-func
arduino_install-func
duevga_install-func
icestorm-template_install-func
rv32i-gcc_install-func