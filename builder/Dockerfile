FROM  ubuntu

RUN apt-get -y update \
	# Lets install base packages required for awscli
	&& apt-get install -y python python-pip ca-certificates locales \
	# Lets setup locale for this shell
	&& locale-gen en_US.UTF-8 \
	&& export LC_ALL=en_US.UTF-8 \
	&& export LANG=en_US.UTF-8 \
	# Lets save locale variables inside /etc/profile for command/shell that run inside container later
	&& echo "export LC_ALL=en_US.UTF-8">>/etc/profile \
	&& echo "export LANG=en_US.UTF-8">>/etc/profile \
	# Lets install awscli latest version
    && pip install awscli
    # Lets create the entrypoint script to handle switch between invoking of default bash shell and aws command execution. 
	# We will launch bash shell if there is/are no input parameter(s)/command given to docker run command
	# We will run aws command by default if CMD is not called by docker run command.
	#&& echo '#!/bin/bash'>/opt/entrypoint.sh \
	# If first parameter is "/bin/bash" then run /bin/bash shell or execute aws command with given parameters.
	#&& echo 'set -e && if [[ "$1" == "/bin/bash" ]]; then /bin/bash ; else exec "/usr/local/bin/aws" $@ ; fi' >>/opt/entrypoint.sh \
	# Lets make entrypoint script executable
    #&& chmod +x /opt/entrypoint.sh

RUN apt-get -y install hugo

# Install missing dependancies for existing packages.
RUN apt-get -qq install