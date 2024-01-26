#!/usr/bin/env bash

# Ensures yum is installed
#which dnf &>/dev/null || (echo "\n[FAIL] dnf not installed and/or accessible; exiting."; exit 1)

dnf clean all

# Needed for reposync
dnf -y install dnf-plugins-core
dnf -y install epel-release
dnf config-manager --set-enabled powertools
dnf -y install yum yum-utils
/usr/bin/crb enable

# The default Ruby version is too low for the rubygems
#  provider.  Reset what module is in use and select Ruby 2.7.
dnf module -y reset ruby
dnf module -y enable ruby:2.7

# Defines list of deps to be installed
for PACKAGE in \
  automake \
  bash \
  bison \
  createrepo \
  createrepo_c \
  crudini \
  curl \
  dnf \
  dpkg-devel \
  gcc \
  gdbm-devel \
  git \
  grep \
  httpd \
  jq \
  less \
  libffi-devel \
  libtool \
  libyaml-devel \
  mlocate \
  nano \
  ncurses \
  ncurses-devel \
  openssl-devel \
  perl \
  perl-App-cpanminus \
  podman-docker \
  python2-pip \
  python2-virtualenv \
  python3 \
  python3-pip \
  python3-virtualenv \
  readline-devel \
  rpm-build \
  rsync \
  ruby \
  rubygems \
  screen \
  sed \
  tput \
  wget \
  which; do

  dnf -y install $PACKAGE

done

for PACKAGE in hoe net-http-persistent rubygems-mirror; do
  gem install $PACKAGE
done

cpanm CPAN::Mini

pip3 install --upgrade pip

if [[ -z $(which python) ]]; then
  PYTHON3_BIN=$(which python3)
  if [[ -z $PYTHON3_BIN ]]; then
    echo "Binary for [python3] not found, exiting."
    exit 1
  else
    ln -s $PYTHON3_BIN /usr/bin/python
  fi
fi

dnf -y upgrade --exclude=tzdata
updatedb