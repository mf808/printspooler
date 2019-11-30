# printspooler

## Use case:
Use your network capable document scanner to do "Scan to Print" with the DELL c1660w printer.
Configure your document scanner to scan to a network share.
This container will then detect a change on the share directory (new file created) and send any created file to the printer via the command 'lp'.

The filesystem monitor is iwatch with the '-c' flag for create.

After the file is sent to CUPS via 'lp' it is deleted.

## DELL Printer specifics
To be able to print from linux, a CUPS server for the DELL c1660w printer needs to be running.
DELL does not supply linux print drivers for this printer, but the DELL c1660w is based off thea Xerox printer Phaser 6000B.
Xerox does supply a i386 deb or rpm printer driver, but trying to get this driver to run in a 64bit version is a PITA.
Therefore I used the idea from https://hub.docker.com/r/olbat/cupsd/ which is a contained CUPS daemon, only in a i386 version with the Xerox driver installed.


## BUILD
sudo docker build -t printspooler .

User: print
Pass: print

login to your host  dockerhost:631 and configure your printer.

Any file that is dropped in the PrintSpooler directoy will be immediatly sent to the printer.

## Beware:
The setup is currently not streamlined. 
The CUPS config files need to be created on your local volume first or CUPS wont start.
I cant remember how I achieved this, but will update this document as soon as I know how I did this and how it can be automated.

The first volume parameter tells the container where the scanned documents are placed for CUPS to print.
The second volume parameter contains the CUPS server configuration for your printer.


## RUN
docker run -d -v /volume1/PrintSpooler:/volume1/PrintSpooler/   -v /volumeSATA/satashare/printspooler/cups/:/etc/cups --name printspooler  --net=host mf808/printspooler:latest

