# Copyright (C) 2012 The Android Open Source Project
# Copyright (C) 2012 The CyanogenMod Project
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

"""Custom OTA commands for aries"""

import common
import os
import subprocess

TARGET_DIR = os.getenv('OUT')
UTILITIES_DIR = os.path.join(TARGET_DIR, 'utilities')

def RunCommand(cmd):
  """Echo and run the given command.

  Args:
    cmd: the command represented as a list of strings.
  Returns:
    A tuple of the output and the exit code.
  """
  print "Running: ", " ".join(cmd)
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
  output, _ = p.communicate()
  print "%s" % (output.rstrip(),)
  return (output, p.returncode)

def FullOTA_Assertions(info):

  # Create ramdisk cpio
  inF = open(os.path.join(TARGET_DIR, "ramdisk.img"), "r")
  outF = open(os.path.join(TARGET_DIR, "ramdisk.cpio"), "w+")
  p = subprocess.Popen(["minigzip", "-d"], stdout=outF, stdin=inF)
  p.communicate()

  # create non-sparse images
  RunCommand(["simg2img", os.path.join(TARGET_DIR, "obj/PACKAGING/systemimage_intermediates/system.img"), os.path.join(TARGET_DIR, "system.img")])

  info.output_zip.write(os.path.join(TARGET_DIR, "ramdisk.cpio"), "ramdisk.cpio")
  info.output_zip.write(os.path.join(TARGET_DIR, "system.img"), "system.img")
  info.output_zip.write(os.path.join(TARGET_DIR, "updater.sh"), "updater.sh")
  info.output_zip.write(os.path.join(TARGET_DIR, "bml_over_mtd.sh"), "bml_over_mtd.sh")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "make_ext4fs"), "make_ext4fs")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "busybox"), "busybox")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "erase_image"), "erase_image")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "bml_over_mtd"), "bml_over_mtd")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "flash_image"), "flash_image")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "ubiupdatevol"), "ubiupdatevol")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "mksquashfs"), "mksquashfs")

  info.script.AppendExtra('package_extract_file("ramdisk.cpio", "/tmp/ramdisk.cpio");')
  info.script.AppendExtra('package_extract_file("system.img", "/sdcard/system.img");')
  info.script.AppendExtra(
        ('package_extract_file("updater.sh", "/tmp/updater.sh");\n'
         'run_program("/sbin/chmod", "777", "/tmp/updater.sh");'))
  info.script.AppendExtra(
       ('package_extract_file("make_ext4fs", "/tmp/make_ext4fs");\n'
        'run_program("/sbin/chmod", "777", "/tmp/make_ext4fs");'))
  info.script.AppendExtra(
        ('package_extract_file("busybox", "/tmp/busybox");\n'
         'run_program("/sbin/chmod", "777", "/tmp/busybox");'))
  info.script.AppendExtra(
        ('package_extract_file("flash_image", "/tmp/flash_image");\n'
         'run_program("/sbin/chmod", "777", "/tmp/flash_image");'))
  info.script.AppendExtra(
        ('package_extract_file("erase_image", "/tmp/erase_image");\n'
         'run_program("/sbin/chmod", "777", "/tmp/erase_image");'))
  info.script.AppendExtra(
        ('package_extract_file("bml_over_mtd", "/tmp/bml_over_mtd");\n'
         'run_program("/sbin/chmod", "777", "/tmp/bml_over_mtd");'))
  info.script.AppendExtra(
        ('package_extract_file("bml_over_mtd.sh", "/tmp/bml_over_mtd.sh");\n'
         'run_program("/sbin/chmod", "777", "/tmp/bml_over_mtd.sh");'))
  info.script.AppendExtra(
        ('package_extract_file("ubiupdatevol", "/tmp/ubiupdatevol");\n'
         'run_program("/sbin/chmod", "777", "/tmp/ubiupdatevol");'))
  info.script.AppendExtra(
        ('package_extract_file("mksquashfs", "/tmp/mksquashfs");\n'
         'run_program("/sbin/chmod", "777", "/tmp/mksquashfs");'))

  info.script.AppendExtra('package_extract_file("boot.img", "/tmp/boot.img");')
  info.script.AppendExtra('assert(run_program("/tmp/updater.sh") == 0);')

def FullOTA_InstallEnd(info):
  # Remove writing boot.img from script (we do it in updater.sh)
  edify = info.script
  for cmd in edify.script:
    if "write_raw_image" in cmd:
      edify.script.remove(cmd)
    if "block_image_update" in cmd:
      edify.script.remove(cmd)
  info.script.AppendExtra('assert(run_program("/tmp/ubiupdatevol", "/dev/ubi0_0", "/sdcard/system.img") == 0);')
