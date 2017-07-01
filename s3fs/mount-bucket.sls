include:
  - s3fs.install

s3fs-mount-deps:
  pkg.installed:
    - names:
      - util-linux

configure-s3fs-fuse-password-file:
  file.append:
    - name: /etc/s3fs-password
    - text: {{ pillar['bucketname'] }}:{{ pillar['awsaccesskey'] }}:{{ pillar['awssecretkey'] }}

/etc/s3fs-password:
  file.managed:
    - user: root
    - group: root
    - mode: 600

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
    - name: mount /mnt/{{ pillar['bucketname'] }}
    - unless: mountpoint /mnt/{{ pillar['bucketname'] }}
    - require:
      - sls: s3fs.install
      - pkg: s3fs-mount-deps