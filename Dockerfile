FROM i386/debian:latest
LABEL maintainer="marcusfischer808@gmail.com"

# Install Packages (basic tools, cups, basic drivers, HP drivers)
RUN apt-get update \
&& apt-get install -y \
  sudo \
  whois \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  smbclient \
  unzip \
  wget \
  iwatch \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Configure the service's to be reachable
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

# Configure XEROX Driver for C1660W Printer
RUN mkdir -p /Downloads/xerox/ \
&& cd /Downloads/xerox/ \
&& wget http://download.support.xerox.com/pub/drivers/6000/drivers/linux/en_GB/6000_6010_deb_1.01_20110210.zip \
&& unzip 6000_6010_deb_1.01_20110210.zip \
&& cd /Downloads/xerox/deb_1.01_20110210/ \
&& dpkg -i xerox-phaser*.deb

# Copy CUPS config to seperate folder for initialization of host configuration volume
RUN mkdir -p /CUPSConfig \
&& cp -rp /etc/cups/* /CUPSConfig/ 


ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE


COPY startup_wrapper.sh startup_wrapper.sh

# create folder to watch for incoming files
RUN mkdir -p /underwatch

# Mount the volumes
VOLUME ["/underwatch" , "/etc/cups"]



# Start the wrapper that calls an instance of iwatch
# this checks if a new document was places in the PrintSpooler directory
# and trigger a print call with lp

# Default shell
CMD ./startup_wrapper.sh

# Expose 613 port for cups web printer config
EXPOSE 613
