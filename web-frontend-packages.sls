installpassengerrepo:
  cmd.run:
    - name: curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
    - stateful: False

enableoptionalrepo:
  cmd.run:
    - name: yum-config-manager --enable rhui-REGION-rhel-server-optional
    - stateful: False

enableextrasrepo:
  cmd.run: 
    - name: yum-config-manager --enable rhui-REGION-rhel-server-extras
    - stateful: False

wget:
  pkg.installed

#old install epel
#download-epel:
#  cmd.run:
#    - name: wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
#    - cwd: /tmp 
#
#install-epel:
#  cmd.run:
#    - name: rpm -ivh epel-release-7-8.noarch.rpm || true
#    - cwd: /tmp 

#https://aws.amazon.com/premiumsupport/knowledge-center/ec2-enable-epel
install-epel:
  cmd.run:
    - name: sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm || true
    - cwd: /tmp 

enable-epel:
  cmd.run:
    - name: yum-config-manager --enable epel

httpd:
  pkg.installed

#epel-release:
#  pkg.installed

#enableepel:
#  cmd.run:
#    - name: yum-config-manager --enable epel
#    - stateful: False

certbot:
  pkg.installed

yum-utils:
  pkg.installed

pygpgme:
  pkg.installed

curl:
  pkg.installed

git:
  pkg.installed

ruby-devel:
  pkg.installed

gcc-c++:
  pkg.installed

postgresql-devel:
  pkg.installed

sqlite-devel:
  pkg.installed

#javascript runtime required for rails
nodejs:
  pkg.installed

telnet:
  pkg.installed

mod_ssl:
  pkg.installed

psmisc:
  pkg.installed

#rubygems:
#  pkg.installed

#rake:
#  gem.installed

#bundler:
#  gem.installed

#mod_passenger:
#  pkg.installed

