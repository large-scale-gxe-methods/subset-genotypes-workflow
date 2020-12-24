FROM quay.io/cybozu/ubuntu-minimal:focal-20200925

# qctool v2
RUN apt-get update && apt-get install -y wget libblas-dev liblapack-dev \
	&& wget https://www.well.ox.ac.uk/~gav/resources/qctool_v2.0.8-CentOS_Linux7.6.1810-x86_64.tgz \
	&& tar xvzf qctool_v2.0.8-CentOS_Linux7.6.1810-x86_64.tgz \
	&& mv qctool_v2.0.8-CentOS\ Linux7.6.1810-x86_64/qctool .
