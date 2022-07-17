#!/bin/bash
/usr/sbin/pvcreate -y /dev/sdb
/usr/sbin/vgcreate -y vg1 /dev/sdb
/usr/sbin/lvcreate -L 1G -n test_lv vg1
/usr/sbin/mkfs.ext4 /dev/vg1/test_lv
/usr/bin/mkdir /test
/usr/bin/mount /dev/vg1/test_lv /test
