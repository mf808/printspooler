# printspooler - a CUPS print server image

## Overview
Docker image including CUPS print server and DELL c1660w (Xerox Phases 6000b) printer drivers (installed from the Debian i386 packages).

## Use case:
Most of the network capable document scanners do not do "Scan to Printer".
This image was built in particular to work with the DELL c1660w printer.

Configure your document scanner to scan to a network share.
This container will then detect a change on the share directory (new file created) and send any created file to the printer via the command 'lp'.

The filesystem monitor is iwatch with the '-c' flag for create.

After the file is sent to CUPS via 'lp' it is deleted.

## DELL Printer specifics
To be able to print from linux, a CUPS server for the DELL c1660w printer needs to be running.
DELL does not supply linux print drivers for this printer, but the DELL c1660w is based off thea Xerox printer Phaser 6000B.
Xerox does supply a i386 deb or rpm printer driver, but trying to get this driver to run/compile on a AMD64 distro was a pain.
Therefore I used the idea from https://hub.docker.com/r/olbat/cupsd/ which is a contained CUPS daemon, only in a i386 version with the Xerox drivers already pre- installed.


## BUILD
```bash
docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t mf808/printspooler:version .
```

## RUN
```bash
docker run -d -v path_to_docs:/underwatch   -v path_to_cups_config:/etc/cups --name printspooler --net=host mf808/printspooler
```

## Configure printer
1. Connect to your host dockerhostIP:631 
2. Configure your printer via the GUI.
3. (The user/password is `print`/`print`)

Be sure to make your printer the default printer via the GUI.

Any file that is dropped in the PrintSpooler directory will be immediatly sent to the printer and then deleted.
