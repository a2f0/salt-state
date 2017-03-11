{% if 1 == salt['cmd.retcode']('test -f /usr/local/bin/s3fs') %}

automake:
  pkg.installed

fuse-devel:
  pkg.installed

#gcc-c++:
#  pkg.installed

#git:
#  pkg.installed

libcurl-devel:
  pkg.installed

make:
  pkg.installed

openssl-devel:
  pkg.installed

fuse:
  pkg.installed

libxml2-devel:
  pkg.installed

#for the mountpoint command
util-linux:
  pkg.installed


/opt/code/s3fs-fuse:
  file.recurse:
    - source: salt://s3fs-fuse/
    - include_empty: True

/etc/s3fs-password:
  file.managed:
    - user: root
    - group: root
    - mode: 600

configure-s3fs-fuse-password-file:
  file.append:
    - name: /etc/s3fs-password
    - text: {{ pillar['bucketname'] }}:{{ pillar['awsaccesskey'] }}:{{ pillar['awssecretkey'] }}

run-autogen-s3fs-fuse:
  cmd.run:
    - name: sh ./autogen.sh
    - cwd: /opt/code/s3fs-fuse
    - stateful: False

run-configure-s3fs-fuse:
  cmd.run:
    - name: ./configure
    - cwd: /opt/code/s3fs-fuse
    - stateful: False

run-make-s3fs-fuse:
  cmd.run:
    - name: make
    - cwd: /opt/code/s3fs-fuse
    - stateful: false

#should not require a reboot, dps 7/8/2016
run-make-install-s3fs-fuse:
  cmd.run:
    - name: make install
    - cwd: /opt/code/s3fs-fuse
    - stateful: false

{% else %}

not-installing-certbot-auto:
  test.nop

{% endif %}

#to mount the bucket via s3fs
/mnt/{{ pillar['bucketname'] }}:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

configure-fstab-s3fs:
  file.append:
    - name: /etc/fstab
    - text: s3fs#{{ pillar['bucketname'] }} /mnt/{{ pillar['bucketname'] }} fuse _netdev,allow_other,passwd_file=/etc/s3fs-password 0 0

mount-s3fs-if-not-mounted:
  cmd.run:
    - name: mountpoint /mnt/{{ pillar['bucketname'] }} || mount /mnt/{{ pillar['bucketname'] }}
