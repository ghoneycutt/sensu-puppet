#!/bin/bash

# using this instead of "rpm -Uvh" to resolve dependencies
function rpm_install() {
    package=$(echo $1 | awk -F "/" '{print $NF}')
    wget --quiet $1
    yum install -d 0 -e 0 -y ./$package
    rm -f $package
}

rpm --import http://download-ib01.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-puppet
rpm --import http://vault.centos.org/RPM-GPG-KEY-CentOS-7

yum install -d 0 -e 0 -y wget
  
# install and configure puppet
rpm -qa | grep -q puppet
if [ $? -ne 0 ]
then 
    rpm_install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    yum -d 0 -e 0 -y install puppet-agent 
    ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet

    # suppress default warings for deprecation
    cat > /etc/puppetlabs/puppet/hiera.yaml <<EOF
---
version: 5
hierarchy:
  - name: Common
    path: common.yaml
defaults:
  data_hash: yaml_data
  datadir: hieradata
EOF
    
    cat > /etc/puppetlabs/puppet/puppet.conf <<EOF
[main]
disable_warnings=deprecations
EOF
fi

# use local sensu module
puppet resource file /etc/puppetlabs/code/environments/production/modules/sensu ensure=link target=/vagrant

# setup module dependencies
puppet module install puppetlabs/stdlib
puppet module install lwf-remote_file

# install EPEL repos for required dependencies
rpm_install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# install dependencies for sensu
yum -d 0 -e 0 -y install rubygems rubygem-json
