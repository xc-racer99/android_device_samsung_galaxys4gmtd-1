#!/tmp/busybox sh
#
# Copyright (C) 2008 The Android Open-Source Project
# Copyright (C) 2012 CyanongenMod
# Copyright (C) 2013 OmniROM Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# bml_over_mtd.sh
# Take care of bad blocks while flashing kernel image to boot partition
#

PARTITION=$1
PARTITION_START_BLOCK=$2
RESERVOIRPARTITION=$3
RESERVOIR_START_BLOCK=$4
IMAGE=$5

# remove old log
rm -rf /sdcard/bml_over_mtd.log

# everything is logged into /sdcard/bml_over_mtd.log
exec >> /sdcard/bml_over_mtd.log 2>&1

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:$PATH

busybox cat <<EOF
########################################################################################
#
# Flashing boot image with bml_over_mtd on `busybox date`
#
########################################################################################
EOF

# scan boot partition for bad blocks
/tmp/bml_over_mtd scan $PARTITION
status=$?
 
# if exit status is 15 use bml_over_mtd, otherwise use flash_image
if test $status -eq 15
then
	echo "Running bml_over_mtd..."
	/tmp/bml_over_mtd flash $PARTITION $PARTITION_START_BLOCK $RESERVOIRPARTITION $RESERVOIR_START_BLOCK $IMAGE 
else
	echo "Running flash_image..."
	/sbin/flash_image $PARTITION $IMAGE
fi

exit
