#!/bin/bash
# ---
# title:       setup_awscli
#
# description: pe 2016.2 init script
# author:      sensei@enoodle.com.au
# source:      http://github.com/e-noodle/aws-cicd-pipeline/scripts/setup_awscli.sh
#
# changelog:   version: 0.0.1, updated_by: sensei, date: 20170604, log: initial script

#############
# vars
#############

PROFILE_NAME=$1
PRECHECK=true
SLOG=/var/log/$(basename $0).log

#############
# functions
#############

function usage {
  cat<<EOF
  usage:
    $0 command [option]
  commands:
    -c, create [profilename]  # create account profile
    -h, help                  # displays help

  default log: $SLOG
EOF
  exit 1
}

function die {
  pp " => ERROR: $1"
  pp " => LOG:   ${SLOG}"
  exit 1
}

# send to stdout and log
function pp {
  echo -e " # $1" | tee -a $SLOG
}

# sanity checks
function prechecks {
  [[ $# -eq 0 ]] && usage
  [[ $(id -G) -eq 0 ]] || die "root access required for $(id -G) to run this command"
  [[ -d '~/.aws' ]] || die "~/.aws directory already exists"
  [[ -f '~/.aws/config' ]] || die "~/.aws/confg file already exists"
  [[ -f '~/.aws/credentials' ]] || die "~/.aws/credentials file already exists   "
  [[ -z $PROFILE_NAME ]] || die "you must provide a project name"
}

#############
# prechecks
#############

prechecks

################
# create profle
################

# check if awscli is installed and configure epel if required
epel_centos7=http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm

[[ $(which aws >/dev/null 2>&1) ]] || \
[[ $(rpm -qa | grep awscli | wc -l) -gt 0 ]] || \
[[ $(yum --enablerepo=epel search awscli >/dev/null 2>&1) ]] || \
[[ $(rpm -qa | grep epel-release | wc -l) -eq 0 ]] || \
[[ $(rpm -ivh ${epel_centos7} >/dev/null 2>&1) ]] || die "unable to install $epel_centos7"

# install awscli
yum --enablerepo=epel -y install awscli >/dev/null 2>&1 || die "unable to install awscli"

pp " => creating aws config directory"
mkdir '~/.aws' || die "unable to create ~/.aws"

pp " => create ~/.aws/credentials file to store credentials"
cat > ~/.aws/credentials <<EOFF
# SECURITY WARNING: FILE CONTAINS SENSITIVE INFORMATION
#  + ensure permissions are secure (not world read or write)
#  + do not use shared accounts, names or passwords
#  + always use strong encryption and complex passwords
#  + regularly change passwords and store them securely
#
#
# [default]
# aws_access_key_id = <aws_access_key_id>
# aws_secret_access_key = <aws_access_key>

[${PROFILE_NAME}]
aws_access_key_id =  <cid_aws_access_key_id>
aws_secret_access_key = <cicd_aws_access_key>
EOFF

[[ $? -eq 0 ]] || die "unable to create ~/.aws/credentials"

pp " => create /.aws/config to store profile"

cat > ~/.aws/config <<EOF
[default]
region = us-east-1
output = json
[${PROFILE_NAME}]
output = json
region = us-east-1
EOF

[[$? -eq 0]] || die 'error creating ~.aws/config'   

pp "setting permissions"
chmod 600 ~/.aws/{credentials,config} 
chown $(whoami):$(whoami) ~/.aws/{credentials,config}

[[$? -eq 0]] || die 'error setting permissions'
pp " => completed"
pp " => log: $LOG"

exit 0
