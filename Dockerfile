FROM java:8-jre

# Set Java environment variables
ENV JAVA_HOME 		/usr/bin/java
ENV PATH 		${PATH}:${JAVA_HOME}/bin

# Set MCR environment variables
ENV MATLAB_JAVA		${JAVA_HOME}
ENV MCR_VERSION         R2014a
ENV MCR_NUM             v83

# Install packages
RUN apt-get update && apt-get install -y \
	wget \
	unzip \
	xorg \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Add MCR intall configuration file
ADD mcr-config.txt /mcr-install/mcr-config.txt

# Install MatLab runtime
RUN cd /mcr-install \
	&& wget -nv http://mathworks.com/supportfiles/downloads/${MCR_VERSION}/deployment_files/${MCR_VERSION}/installers/glnxa64/MCR_${MCR_VERSION}_glnxa64_installer.zip \
	&& unzip MCR_${MCR_VERSION}_glnxa64_installer.zip \
	&& mkdir /opt/mcr \
	&& ./install -inputFile mcr-config.txt \
	&& cd / \
	&& rm -rf /mcr-install

# Set MCR environment variables
ENV LD_LIBRARY_PATH 	${LD_LIBRARY_PATH}:\
/opt/mcr/${MCR_NUM}/runtime/glnxa64:\
/opt/mcr/${MCR_NUM}/bin/glnxa64:\
/opt/mcr/${MCR_NUM}/sys/os/glnxa64

ENV XAPPLRESDIR 	/opt/mcr/${MCR_NUM}/X11/app-defaults

# Define default command
CMD ["bash"]
