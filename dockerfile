FROM rocker/r-base
MAINTAINER Nagdev Amruthnath <nagdev_amruthnath@denso-diam.com>

ARG DEBIAN_FRONTEND=noninteractive

#update list and install dependencies
RUN apt-get update -qq \
    && apt-get install -y --allow-downgrades git-core \
    libssl-dev curl libcurl4-openssl-dev\
    libxml2-dev \
	unixodbc unixodbc-dev \
    gnupg gnupg2 gnupg1 apt-transport-https \
	odbc-postgresql libpq-dev \
	cron \
    && apt-get -y upgrade

# submit 8 jobs at once
RUN MAKE='make -j 25'

#add to source list
RUN echo "deb http://ftp.us.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb-src http://ftp.us.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list


#install this package
RUN R -e "install.packages(c('httr','RPostgreSQL', 'jsonlite', 'lubridate', 'reshape2','tidyr','psych', 'dplyr', 'foreach', 'doParallel'),  dependencies=TRUE,repos = 'http://cran.us.r-project.org')"

RUN R -e "install.packages(c('devtools', 'caret', 'parallel', 'Metrics'),  dependencies=TRUE,repos = 'http://cran.us.r-project.org')"
