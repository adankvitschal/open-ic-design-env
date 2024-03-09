This image runs the basic tool needed to design ICs using the design flow proposed by efabless:
    -xschem
    -magic
    -ngspice
    -cace

Also, libngspice wa sinstalled along with the python glue lib ngspyce:
    -libngspice
    -ngspyce
These are intended to help with python automation of design parameters.

To use this image, you must export port 5901 and connect to it using a VNC client with this data:
    -user: moduhub
    -pass: moduhub

You can also test commands inside the image using Docker interactive mode like this:
    
    docker run --rm -it --entrypoint /bin/bash akvitschal/sky130-analog-env