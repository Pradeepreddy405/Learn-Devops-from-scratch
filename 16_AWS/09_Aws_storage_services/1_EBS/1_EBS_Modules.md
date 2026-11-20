# AWS EBS Volume Hands-On Lab (From Scratch)

This repository documents a **step-by-step hands-on lab** for working with **Amazon EBS volumes** on an EC2 instance using Linux.  
The lab covers the complete lifecycle: from volume creation to formatting, mounting, persistence, unmounting, and converting back to RAW.

---

##  Prerequisites

- AWS Account
- Running EC2 instance (Amazon Linux / Ubuntu)
- SSH access to EC2
- Basic Linux command knowledge

---

## Lab Objectives

By completing this lab, you will learn how to:

- Create and attach an EBS volume
- Detect the volume at OS level
- Partition the disk using `fdisk`
- Format the partition with a filesystem
- Mount the volume
- Persist mount using `/etc/fstab`
- Unmount the volume safely
- Convert a formatted volume back to RAW

---

## Architecture Overview

- EC2 Instance
- Secondary EBS Volume (gp3)
- Linux NVMe device mapping (`/dev/nvmeXn1`)

---

## Step 1: Create EBS Volume

1. Go to **EC2 → Volumes** in AWS Console
2. Click **Create Volume**
   - Type: `gp3`
   - Size: `10 GiB`
   - Availability Zone: Same as EC2 instance
3. Ensure volume state is `available`

---

## Step 2: Attach Volume to EC2

1. Select the volume
2. Click **Actions → Attach Volume**
3. Choose your EC2 instance
4. Device name: `/dev/sdf` (AWS suggestion)

> Note: On Linux, the device appears as `/dev/nvmeXn1`

---

## Step 3: Detect Disk in OS

```bash
lsblk
lsblk -f
You should see the disk listed with no filesystem (RAW)



```

## Step 4: Partition Disk using fdisk
sudo fdisk /dev/nvme1n1


Inside fdisk:

n  → new partition
p  → primary
1  → partition number
Enter → default first sector
Enter → default last sector
w  → write changes


Reload partition table:

sudo partprobe


Verify:

lsblk

##	Step 5: Format the Partition
sudo mkfs.ext4 /dev/nvme1n1p1


Verify:

lsblk -f

##  Step 6: Create Mount Directory
sudo mkdir /data

##  Step 7: Mount the Volume
sudo mount /dev/nvme1n1p1 /data


Verify:

df -h

## Step 8: Persist Mount using fstab

Get UUID:

sudo blkid /dev/nvme1n1p1


Edit /etc/fstab:

sudo nano /etc/fstab


Add the following line:

UUID=<UUID>  /data  ext4  defaults,nofail  0  2


Test fstab:

sudo mount -a

## Step 9: Reboot & Verify
sudo reboot


After reboot, check:

df -h | grep data
lsblk -f

## Step 10: Unmount Volume
cd /
sudo umount /data


If the target is busy:

sudo lsof +D /data

## Step 11: Convert Volume Back to RAW

Remove the entry from /etc/fstab

Wipe filesystem:

sudo wipefs -a /dev/nvme1n1


Verify:

lsblk -f