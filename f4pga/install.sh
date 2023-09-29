#!/usr/bin/env bash

F4PGA_INSTALL_DIR=$PWD/tools
FPGA_FAM=xc7

git clone https://github.com/chipsalliance/f4pga-examples
pushd .
cd f4pga-examples

# Install conda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O conda_installer.sh
bash conda_installer.sh -u -b -p $F4PGA_INSTALL_DIR/$FPGA_FAM/conda;
source "$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/etc/profile.d/conda.sh";

# Set up env
conda env create -f $FPGA_FAM/environment.yml

# # Install packages 
export F4PGA_PACKAGES='install-xc7 xc7a50t_test'
mkdir -p $F4PGA_INSTALL_DIR/$FPGA_FAM
F4PGA_TIMESTAMP='20220920-124259'
F4PGA_HASH='007d1c1'
for PKG in $F4PGA_PACKAGES; do
  wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/${F4PGA_TIMESTAMP}/symbiflow-arch-defs-${PKG}-${F4PGA_HASH}.tar.xz | tar -xJC $F4PGA_INSTALL_DIR/${FPGA_FAM}
done

popd
