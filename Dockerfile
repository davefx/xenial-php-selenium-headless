FROM ubuntu:xenial
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

MAINTAINER David Marín <david.marin@toptal.com>
RUN apt-get -y update
RUN apt-get install -y -q software-properties-common wget
RUN add-apt-repository -y ppa:mozillateam/firefox-next
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN wget https://deb.nodesource.com/setup_6.x; mv setup_6.x nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN wget https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh -q -O - | bash -s
RUN apt-get update -y
RUN apt-get install -y -q \
  bzip2 \
  firefox \
  git \
  git-lfs \
  openjdk-8-jre-headless \
  nano \
  nodejs \
  php-cli \
  php-curl \
  x11vnc \
  xvfb \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic
RUN git lfs install
RUN useradd -d /home/seleuser -m seleuser
RUN mkdir -p /home/seleuser/chrome
RUN chown -R seleuser /home/seleuser
RUN chgrp -R seleuser /home/seleuser
# fix https://code.google.com/p/chromium/issues/detail?id=318548
RUN mkdir -p /usr/share/desktop-directories
ADD ./scripts/ /home/root/scripts
RUN npm install -g \
  selenium-standalone \
  phantomjs-prebuilt
RUN selenium-standalone install
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
RUN apt-get update
RUN apt-get install -y  google-chrome-beta
RUN php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
RUN php /tmp/composer-setup.php --install-dir="/usr/local/bin"
RUN ln -s /usr/local/bin/composer.phar /usr/local/bin/composer
EXPOSE 4444 5909
#ENTRYPOINT ["sh", "/home/root/scripts/startXvfb.sh"]
