# Chisel F4GPA Flow

This repository contains a template and framework for generating bitstreams from [Chisel](https://www.chisel-lang.org/) HDL.
The whole toolchain is open source since the synthesis is based on [F4PGA](https://f4pga.org/).
The project contains a Chisel modules which toggle an LED once per second.
To program an FPGA with this design there are a few steps beforehand.

## Dependencies
This project assumes a Unix like operating system.
Make sure you have the following dependencies installed:
* [SBT](https://www.scala-sbt.org/download.html)
* [JDK](https://adoptium.net/)
* [Firtool](https://github.com/llvm/circt/releases)

## Generating SystemVerilog from Chisel
Right now most synthesis tools only accepts less abstract HDLs like SystemVerilog.
This means the Chisel code needs to be converted to SystemVerilog representation in order to synthesize it.
This can be done with the command:

```shell
make rtl
```

This will create a directory called ```rtl/``` where the SystemVerilog files are located.

## Installing the tools
Now that the SystemVerilog is generated the design can be synthesized.
As mentioned, this is done with [F4PGA](https://f4pga.org/) which needs to be installed.
This reposistory can install the tools automatically.
To install the tool run:

```shell
make install
```

This will create the directory ```f4pga/tools``` and ```f4pga/f4pga-examples``` which contains all the neccessary tools.
The tools only needs to be installed once.

## Synthesizing the design
The synthesis tools needs to know which FPGA board you are using.
To set your board as a target create a file called ```config.mk``` in the root of this directory.
Edit the file so it sets your target board.
It could for example look like this:

```plain
BOARD = basys3
```

Right now, this repository only supports the [Basys 3](https://digilent.com/reference/programmable-logic/basys-3/start) board.
So it not strictly neccessary to make the configuration file as the project defaults to Basys 3.
To synthsize the design just run following command:

```shell
make synth
```

This will create the directory ```synth/build/basys3/```.

## Programming the FPGA
The build directory contains a lot of files but the most interesting one is the ```Blinky.bit``` which is the bitstream file.
This is the file that is used programmed to the FPGA when it is programmed.
To program the FPGA plug in your FPGA via USB and run following command:

```shell
make program
```

You should now see an LED on the FPGA blinking if not see [Troubleshooting](#Troubleshooting).

## Tips
### Tools
The tools take up rougly 6GB of storage so you might be interested in deleting them.
If you ever want to delete the tools just run:

```shell
make uninstall
```

If you want to install the tools in another directory you can simply copy the file ```f4pga/install.sh``` to the directory where you see fit.
When you run the script it will similarly create the ```tools``` and ```f4pga-examples``` directories.
To make this project reference the install in another directory simply edit the ```config.mk``` file created earlier to contain install directories.
For example it could look like this:

```plain
BOARD = basys3
F4PGA_INSTALL_DIR  = /home/madsrumlenordstrom/repos/f4pga/tools
F4PGA_EXAMPLES_DIR = /home/madsrumlenordstrom/repos/f4pga/f4pga-examples
```

This is also useful if you already have the tools installed and want to use them for another project.
There is no reason to install the tools twice.
Beware that the uninstall command will also target the directories of these variables so make sure you know what you are doing.

### Makefile
The Makefile is written such that dependencies are resolved.
This means if you made a change to the Chisel code and want to reprogram your FPGA you can just run:

```shell
make program
```

Which will automatically generate SystemVerilog which will then be synthesized to a bitstream file that will be programmed to the FGPA.
You do not need to manually run the whole chain of commands showed earlier.

### Testing
You can run the blinky test by running following command:

```shell
make test
```

## Troubleshooting
### Error: unable to open ftdi device
Check that your device is properly plugged in and shows up when you run the ```lsusb``` command.
If the device shows up the problem is most likely permission issues for USB devices.
On some Linux distrubutions normal users does not get permissions to USB devices by default.
Trying to program an FPGA will result in an error since it is via USB.
To fix this run the commands:
```shell
sudo bash -c 'echo ATTRS{idVendor}==\"0403\", ATTRS{idProduct}==\"6010\", MODE=\"666\", TAG+=\"uaccess\" > /etc/udev/rules.d/99-ftdi.rules'
sudo udevadm control --reload-rules && sudo udevadm trigger
```
You might need to change the ```idVendor``` and ```idProduct``` to another ID.
You can get these from running ```lsusb``` while your FPGA board is plugged in.
My Basys 3 board looks like this:

```plain
Bus 001 Device 004: ID 0403:6010 Future Technology Devices International, Ltd FT2232C/D/H Dual UART/FIFO IC
```