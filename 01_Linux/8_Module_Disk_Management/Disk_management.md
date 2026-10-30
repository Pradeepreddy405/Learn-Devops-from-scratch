# Linux Disk Management — From Basics to Advanced

A practical, hands-on guide to Linux disk management, storage administration, monitoring, troubleshooting, and advanced storage engineering.


Linux Disk Management is an essential skill for Linux System Administrators, Cloud Engineers, DevOps Engineers, and Site Reliability Engineers (SREs).

In production environments, applications require sufficient disk capacity, reliable filesystems, correct mount configurations, and continuous storage monitoring. Poor storage management can cause application failures, database downtime, failed deployments, and data loss.

This repository provides a structured learning path from basic Linux storage concepts to advanced production troubleshooting and AWS storage management.

**Objective:** Understand how Linux storage works, manage disks safely, automate monitoring, troubleshoot common failures, and perform storage operations in real-world cloud environments.

## 🎯 Learning Objectives

By completing this repository, you will learn how to:

- Understand disks, block devices, partitions, and filesystems.
- Inspect disk capacity, inode usage, and filesystem information.
- Create partitions and filesystems on additional disks.
- Mount and unmount filesystems safely.
- Configure persistent mounts using `/etc/fstab`.
- Understand Linux file permissions and ownership.
- Monitor disk usage using Bash scripts.
- Automate monitoring with cron and systemd timers.
- Troubleshoot full disks, inode exhaustion, and deleted-but-open files.
- Investigate read-only filesystems, failed mounts, and storage I/O latency.
- Extend AWS EBS volumes and grow Linux filesystems.
- Understand LVM, capacity planning, and storage observability.

##  Learning Roadmap

| Level | Topic | Outcome |
|---|---|---|
| Level 1 | Linux Storage Fundamentals | Understand and manage Linux storage |
| Level 2 | Monitoring and Automation | Automate disk monitoring and alerting |
| Level 3 | Production Troubleshooting | Diagnose common storage incidents |
| Level 4 | Advanced Storage Engineering | Manage scalable and reliable storage |

---

# Level 1 — Linux Storage Fundamentals

## 1. Understand Linux Storage Architecture

Before managing disks, understand how storage is presented to Linux.

A typical storage hierarchy looks like this:

```text
Physical Disk / Cloud Volume
          |
          v
    Block Device
          |
          v
      Partition
          |
          v
      Filesystem
          |
          v
      Mount Point
          |
          v
   Files and Directories
          |
          v
     Applications
```

Example:

An AWS EBS volume is attached to an EC2 instance. Linux detects the device, a partition and filesystem may be created, and the filesystem is mounted to a directory such as `/data`.

Applications can then store files under `/data`.

**Important:** A newly attached disk does not automatically mean it is ready for storing data. The device, partitioning, filesystem, and mount configuration must be checked first.

## 2. Linux Storage Terminology

| Term | Meaning |
|---|---|
| Disk | A storage device or virtual block device |
| Block device | A device that stores and retrieves data in blocks |
| Partition | A logical division of a disk |
| Filesystem | A structure used to organize and access files |
| Mount point | A directory through which a filesystem is accessed |
| Capacity | Total storage space available to a filesystem |
| Inode | Metadata structure that represents a file or directory |
| UUID | A unique identifier commonly used to identify a filesystem |
| Swap | Disk-backed space that can support virtual memory |
| EBS | AWS block storage service for EC2 instances |
| LVM | Logical Volume Manager for flexible storage allocation |

## 3. Identify Disks and Block Devices

### 3.1 List all block devices

```bash
lsblk
```

Example output:

```text
NAME          SIZE TYPE MOUNTPOINTS
nvme0n1         8G disk
└─nvme0n1p1     8G part /
```

Explanation:

- `nvme0n1` — the disk device.
- `nvme0n1p1` — a partition on that disk.
- `/` — the root filesystem is mounted on this partition.

Device names depend on the instance and storage configuration. AWS EC2 instances commonly expose EBS volumes as NVMe devices.

### 3.2 Display filesystem information

```bash
lsblk -f
```

This displays filesystem types, labels, UUIDs, and mount points where available.

### 3.3 Display disks with detailed information

```bash
sudo fdisk -l
```

Use this to inspect disk sizes, partition tables, and partition boundaries.

### 3.4 Identify mounted filesystems

```bash
findmnt
```

Display the root filesystem:

```bash
findmnt /
```

### 3.5 Display block device identifiers

```bash
sudo blkid
```

This is useful when configuring persistent mounts using filesystem UUIDs.

## 4. Understand Disk Capacity

### 4.1 Check filesystem usage

```bash
df -h
```

The `-h` option displays sizes in human-readable units.

Example:

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/root         8G  3.1G  4.9G  39% /
```

Important columns:

- `Size`: total filesystem capacity.
- `Used`: space currently used.
- `Avail`: available space.
- `Use%`: percentage of filesystem space used.
- `Mounted on`: directory where the filesystem is accessible.

### 4.2 Check inode usage

```bash
df -i
```

A filesystem can run out of inodes even when free disk space remains.

This commonly happens when an application creates a very large number of small files, such as temporary files, cache files, or application logs.

### 4.3 Check a specific directory's size

```bash
sudo du -sh /var/log
```

Find the largest directories under `/var`:

```bash
sudo du -xhd1 /var 2>/dev/null
```

On systems where the installed `du` version does not support this syntax, use:

```bash
sudo du -x -h --max-depth=1 /var 2>/dev/null
```

The `-x` option prevents traversal into other filesystems.

### 4.4 Understand `df` versus `du`

| Command | Purpose |
|---|---|
| `df -h` | Reports filesystem-level space usage |
| `df -i` | Reports inode usage |
| `du -sh DIRECTORY` | Estimates space consumed by files under a directory |
| `lsblk` | Displays storage devices and their relationships |
| `findmnt` | Shows mounted filesystems |

**Production tip:** If `df` reports high usage but `du` cannot account for the space, investigate deleted-but-open files, hidden mount-point contents, filesystem reservations, and other filesystem-specific factors.

## 5. Understand Linux Filesystems

A filesystem organizes files and directories on a storage device.

Common Linux filesystem types include:

- **ext4:** A widely used general-purpose Linux filesystem.
- **XFS:** Common in enterprise Linux environments, including many AWS Linux deployments.
- **Btrfs:** Supports features such as snapshots and checksums.
- **tmpfs:** Memory-backed temporary filesystem.
- **NFS:** A network filesystem accessed over a network.

Check filesystem types:

```bash
df -Th
```

Check a particular mount:

```bash
findmnt -no SOURCE,FSTYPE,TARGET /
```

**Important:** Filesystem creation and formatting can destroy existing data. Always verify the device, existing data, and backup requirements before performing destructive operations.

## 6. Understand Linux Mount Points

A mount point is a directory through which a filesystem becomes accessible.

Examples:

| Mount Point | Typical Purpose |
|---|---|
| `/` | Root filesystem |
| `/boot` | Boot-related files on configurations that use a separate boot filesystem |
| `/home` | User home directories |
| `/var` | Logs, caches, and application state |
| `/data` | Application or general-purpose data |
| `/mnt` | Temporary or manually mounted filesystems |

View mount information:

```bash
findmnt
```

Create a directory for a data filesystem:

```bash
sudo mkdir -p /data
```

Mounting a filesystem on an existing non-empty directory can hide the files previously visible there until the filesystem is unmounted.

## 7. Hands-On Lab: Attach and Mount an Additional Disk

This lab demonstrates a typical AWS EC2 storage workflow.

### Step 1: Attach a new EBS volume

In the AWS Management Console:

1. Open EC2.
2. Create an EBS volume in the same Availability Zone as the target instance.
3. Attach the volume to the EC2 instance.
4. Connect to the instance through SSH.
5. Identify the new device.

```bash
lsblk
```

**Do not assume the new disk is `/dev/nvme1n1`. Identify it by its size, existing partitions, mount points, and AWS attachment information.**

### Step 2: Inspect the selected device

Set a shell variable to the device you have positively identified.

Example only:

```bash
DEVICE=/dev/nvme1n1
lsblk "$DEVICE"
sudo wipefs -n "$DEVICE"
```

The `wipefs -n` command lists recognizable filesystem or partition signatures without erasing them.

If the disk contains data, stop and investigate before continuing.

### Step 3: Create a partition

Only for a confirmed, new, empty disk:

```bash
sudo fdisk "$DEVICE"
```

In `fdisk`, create a new partition using the interactive options, then write the partition table.

Refresh the device view:

```bash
lsblk
```

On NVMe devices, the first partition commonly has a name such as `/dev/nvme1n1p1`.

Use the actual partition name shown by your system.

### Step 4: Create a filesystem

For a new, empty partition that you intend to format as XFS:

```bash
sudo mkfs.xfs /dev/nvme1n1p1
```

Replace the example device with your actual partition.

**Warning:** Formatting destroys existing filesystem data on the target. Never run this command against a disk or partition containing data you need to preserve.

### Step 5: Create the mount point

```bash
sudo mkdir -p /data
```

### Step 6: Mount the filesystem

```bash
sudo mount /dev/nvme1n1p1 /data
```

Verify the mount:

```bash
findmnt /data
df -hT /data
lsblk -f
```

### Step 7: Test file creation

```bash
sudo touch /data/test-file.txt
ls -l /data
```

This verifies that the filesystem is mounted and writable by the privileged user.

### Step 8: Unmount the filesystem

Move out of the mounted directory before unmounting:

```bash
cd ~
sudo umount /data
```

If the filesystem is busy, inspect open files and processes instead of forcing an unmount.

### Step 9: Mount the filesystem again

```bash
sudo mount /dev/nvme1n1p1 /data
findmnt /data
```

The filesystem is mounted again, but this manual mount will not automatically persist across a reboot.

## 8. Configure Persistent Mounts Using `/etc/fstab`

The `/etc/fstab` file defines filesystems that should be mounted automatically.

### Step 1: Find the filesystem UUID

```bash
sudo blkid
```

Example:

```text
/dev/nvme1n1p1: UUID="example-uuid" TYPE="xfs"
```

Use the actual UUID from your system. The example above is illustrative.

### Step 2: Back up the configuration

```bash
sudo cp -a /etc/fstab /etc/fstab.bak
```

### Step 3: Edit the file

```bash
sudo vi /etc/fstab
```

Add a line using the real UUID:

```text
UUID=<actual-filesystem-uuid>  /data  xfs  defaults,nofail  0  2
```

The fields represent:

1. Filesystem identifier.
2. Mount point.
3. Filesystem type.
4. Mount options.
5. Dump setting.
6. Filesystem-check setting.

`nofail` can allow boot to continue when an optional data disk is unavailable. It is not appropriate for every filesystem, especially storage required for critical application startup.

### Step 4: Validate the configuration

```bash
sudo findmnt --verify --verbose
```

Then test the mount configuration:

```bash
sudo mount -a
```

Verify:

```bash
findmnt /data
df -hT /data
```

Test this carefully before rebooting a remote server. An invalid `/etc/fstab` entry can cause boot or service startup problems.

## 9. Linux Permissions and Ownership

Correct permissions help protect data and ensure applications can access the required directories.

Check ownership and permissions:

```bash
ls -ld /data
```

Create a directory for an application:

```bash
sudo mkdir -p /data/app
```

Assign ownership to an existing application account:

```bash
sudo chown appuser:appuser /data/app
```

Replace `appuser` with the actual service account.

Set directory permissions:

```bash
sudo chmod 750 /data/app
```

Permission values:

| Permission | Numeric Value |
|---|---:|
| Read | 4 |
| Write | 2 |
| Execute | 1 |
| Read + Execute | 5 |
| Read + Write | 6 |
| Read + Write + Execute | 7 |

For directories, execute permission controls traversal. Use the minimum permissions required by the application rather than applying `777`.

---

# Level 2 — Monitoring and Automation

## 10. Monitor Disk Usage

A DevOps engineer should monitor both disk capacity and inode utilization.

### Check root filesystem usage

```bash
df -h /
```

### Check inode usage

```bash
df -i /
```

### Find large files

For example, locate files larger than 500 MB on the root filesystem:

```bash
sudo find / -xdev -type f -size +500M -print 2>/dev/null
```

This searches the root filesystem only. Repeat on other filesystems as necessary.

### Check system logs

On systemd-based distributions:

```bash
sudo journalctl -p warning..alert --since "1 hour ago"
```

For Amazon Linux systems with traditional log files:

```bash
sudo tail -n 100 /var/log/messages
```

The exact log files available depend on the distribution and logging configuration.

## 11. Create a Bash Disk Monitoring Script

Create the script:

```bash
sudo mkdir -p /opt/disk-monitor
sudo vi /opt/disk-monitor/disk-monitor.sh
```

Add the following code:

```bash
#!/bin/bash

set -u

THRESHOLD=80
LOG_FILE="/var/log/disk-monitor.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

{
    echo "[$TIMESTAMP] Disk monitoring started"

    df -P -x tmpfs -x devtmpfs |
    awk -v threshold="$THRESHOLD" '
        NR > 1 {
            usage = $5
            gsub(/%/, "", usage)

            if (usage >= threshold) {
                printf "WARNING: %s is %s%% full (mounted on %s)\n",
                       $1, usage, $6
            }
        }
    '
} >> "$LOG_FILE" 2>&1
```

Save the file and make it executable:

```bash
sudo chmod 750 /opt/disk-monitor/disk-monitor.sh
```

Run it:

```bash
sudo /opt/disk-monitor/disk-monitor.sh
```

View the log:

```bash
sudo tail -n 50 /var/log/disk-monitor.log
```

### How the script works

- `THRESHOLD=80` defines the warning threshold.
- `df -P` produces predictable, single-line filesystem records.
- `awk` extracts usage percentages.
- Filesystems at or above the threshold generate a warning.
- Output is appended to a log file.

This is a basic monitoring example. A production implementation should also monitor inodes, exclude unsuitable filesystems, handle script failures, and send alerts through an approved notification system.

## 12. Schedule Monitoring With Cron

Open the crontab for the account that should run the monitoring job:

```bash
sudo crontab -e
```

Add:

```cron
*/5 * * * * /opt/disk-monitor/disk-monitor.sh
```

This schedules the script every five minutes.

Verify the schedule:

```bash
sudo crontab -l
```

Check whether the cron service is running:

```bash
sudo systemctl status crond
```

On Amazon Linux, the service is commonly named `crond`.

**Production consideration:** Repeatedly appending identical warnings can create large logs. Use log rotation or send metrics to a monitoring platform rather than relying only on a local log file.

## 13. Schedule Monitoring With a systemd Timer

Systemd timers provide another way to schedule recurring tasks.

Create the service:

```bash
sudo vi /etc/systemd/system/disk-monitor.service
```

```ini
[Unit]
Description=Linux Disk Usage Monitoring

[Service]
Type=oneshot
ExecStart=/opt/disk-monitor/disk-monitor.sh
```

Create the timer:

```bash
sudo vi /etc/systemd/system/disk-monitor.timer
```

```ini
[Unit]
Description=Run Linux Disk Monitoring Every Five Minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
Unit=disk-monitor.service

[Install]
WantedBy=timers.target
```

Enable and start the timer:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now disk-monitor.timer
```

Check the timer:

```bash
systemctl list-timers disk-monitor.timer
```

Check the service logs:

```bash
sudo journalctl -u disk-monitor.service
```

Use cron or a systemd timer according to the requirements of your environment. You generally do not need both for the same task.

## 14. Disk Monitoring Metrics

A more complete storage monitoring solution should collect:

| Metric | Purpose |
|---|---|
| Filesystem usage percentage | Detect approaching capacity limits |
| Free disk space | Estimate remaining storage |
| Inode utilization | Detect file-count exhaustion |
| Disk read/write throughput | Measure storage data transfer |
| I/O operations per second | Understand storage workload |
| I/O latency | Detect slow storage operations |
| Queue depth | Understand pending I/O requests |
| Filesystem errors | Identify storage integrity problems |
| Disk growth rate | Support capacity planning |

Monitoring tools can include Prometheus, Grafana, node_exporter, CloudWatch, and CloudWatch Agent, depending on the environment.

---

# Level 3 — Production Troubleshooting

## 15. Scenario 1: Disk Usage Reaches 100%

### Symptoms

- Application cannot write files.
- Logs stop updating.
- Database operations fail.
- Deployments fail during artifact extraction.
- Temporary-file creation returns `No space left on device`.

### Step 1: Confirm the problem

```bash
df -h
```

### Step 2: Find large directories

```bash
sudo du -xhd1 / 2>/dev/null
```

### Step 3: Investigate common locations

```bash
sudo du -sh /var/log
sudo du -sh /tmp
sudo du -sh /var/cache
```

### Step 4: Inspect large files

```bash
sudo find /var -xdev -type f -size +100M -print 2>/dev/null
```

### Step 5: Apply an appropriate fix

Depending on the cause:

- Configure log rotation.
- Remove confirmed, unnecessary temporary files.
- Clean package caches using supported package-manager commands.
- Move suitable data to a larger filesystem.
- Expand the underlying storage.
- Fix applications that generate excessive files.

Do not blindly delete database files, application data, or logs that are required for investigation or compliance.

## 16. Scenario 2: Inode Exhaustion

### Symptoms

Disk space appears available, but applications cannot create new files.

### Step 1: Check inode utilization

```bash
df -i
```

### Step 2: Identify directories with many files

For example, inspect a suspected application cache:

```bash
sudo find /var/cache/myapp -xdev -type f 2>/dev/null | wc -l
```

Replace the path with the actual suspected directory.

### Step 3: Identify the cause

Common causes include:

- Applications creating excessive small files.
- Temporary files that are never removed.
- Cache directories without retention policies.
- Incorrect application cleanup logic.

### Step 4: Resolve the problem

Remove only files confirmed to be safe to delete, implement cleanup policies, and correct the application behavior.

Adding more disk capacity does not necessarily solve inode exhaustion.

## 17. Scenario 3: Deleted Files Still Consume Disk Space

### Why it happens

On Linux, deleting a file removes its directory entry. The underlying storage may remain allocated while a process still has the file open.

### Step 1: Compare filesystem and directory usage

```bash
df -h
sudo du -xhd1 /var 2>/dev/null
```

### Step 2: Find deleted-but-open files

If `lsof` is installed:

```bash
sudo lsof +L1
```

Look for large files with a link count below one.

### Step 3: Identify the owning process

Review the process ID, command, file descriptor, and file size.

### Step 4: Recover space safely

Use the application's supported log-reopen mechanism or restart the relevant service during an approved maintenance window.

Avoid terminating processes or truncating file descriptors without understanding the impact.

## 18. Scenario 4: Filesystem Becomes Read-Only

### Symptoms

Applications fail with errors such as:

```text
Read-only file system
```

### Step 1: Check mount options

```bash
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS
```

### Step 2: Inspect kernel logs

```bash
sudo dmesg -T | tail -n 100
```

Also inspect:

```bash
sudo journalctl -k -p warning..alert
```

### Step 3: Investigate the cause

Possible causes include:

- Filesystem errors.
- Storage I/O failures.
- Underlying device problems.
- Explicit read-only mount configuration.

### Step 4: Recover safely

Preserve important data, investigate the underlying device, and use the filesystem's documented repair procedure.

Do not immediately remount the filesystem as read-write without identifying why it became read-only.

Filesystem repair tools may require unmounting the filesystem and can cause data loss if used incorrectly.

## 19. Scenario 5: Mount Fails After Reboot

### Step 1: Inspect the current mounts

```bash
findmnt
```

### Step 2: Review the mount configuration

```bash
cat /etc/fstab
```

### Step 3: Validate entries

```bash
sudo findmnt --verify --verbose
```

### Step 4: Inspect boot logs

```bash
sudo journalctl -b -p warning..alert
```

### Step 5: Verify the underlying device

```bash
lsblk -f
sudo blkid
```

Common causes include incorrect UUIDs, missing devices, invalid filesystem types, and incorrect mount options.

Test corrections carefully before rebooting a remote production server.

## 20. Scenario 6: High Disk I/O Latency

A filesystem can have plenty of free capacity and still perform poorly because storage operations are slow.

### Step 1: Install troubleshooting tools if needed

On Amazon Linux:

```bash
sudo dnf install sysstat -y
```

### Step 2: Inspect device utilization

```bash
iostat -xz 1 5
```

Useful fields include:

- `r/s` and `w/s`: read and write operations per second.
- `rkB/s` and `wkB/s`: read and write throughput.
- `await`: average time for I/O requests, in milliseconds.
- `aqu-sz`: average queue length.
- `%util`: time the device was busy.

Interpret these metrics together. High utilization alone does not prove that a device is saturated, particularly for parallel storage devices.

### Step 3: Identify resource-intensive processes

If `iotop` is available:

```bash
sudo iotop
```

Alternative:

```bash
pidstat -d 1 5
```

### Step 4: Investigate the workload

Possible causes include:

- Database queries creating excessive disk I/O.
- Large log writes.
- Backup or compression jobs.
- Insufficient storage performance for the workload.
- Memory pressure causing heavy swapping.

### Step 5: Apply the correct fix

Optimize the workload, reduce unnecessary writes, adjust the storage configuration, or select an appropriate storage performance tier.

---

# Level 4 — Advanced Storage Engineering

## 21. AWS EBS Volume Expansion

Amazon Elastic Block Store (EBS) provides persistent block storage for EC2 instances.

A typical expansion workflow is:

```text
Identify the EBS Volume
          |
          v
Modify Volume Size in AWS
          |
          v
Wait for Modification Progress
          |
          v
Verify the New Linux Device Size
          |
          v
Expand Partition, If Required
          |
          v
Grow the Filesystem
          |
          v
Verify Available Capacity
```

### Step 1: Identify the current disk layout

```bash
lsblk
df -hT
```

Record the device, partition, filesystem type, and mount point.

### Step 2: Expand the EBS volume

In the AWS Console:

1. Open EC2 → Volumes.
2. Select the correct EBS volume.
3. Choose Modify volume.
4. Increase the required size.
5. Confirm the modification.
6. Wait until the volume modification reaches an appropriate state.

Follow your organization's change-management process before modifying production storage.

### Step 3: Verify the new size

```bash
lsblk
```

If Linux has not yet reflected the new capacity, investigate device discovery and the volume's modification status.

### Step 4: Expand the partition if required

Install `growpart` if it is not available. On Amazon Linux, the package is commonly `cloud-utils-growpart`.

```bash
sudo dnf install cloud-utils-growpart -y
```

For a confirmed device with a partition that must be expanded:

```bash
sudo growpart /dev/nvme0n1 1
```

This example targets partition 1 on `/dev/nvme0n1`. Replace it with the actual device and partition number.

Do not run `growpart` unless the partition layout and intended target have been verified.

### Step 5: Grow the filesystem

For XFS mounted at `/`:

```bash
sudo xfs_growfs /
```

For an ext4 filesystem on a partition:

```bash
sudo resize2fs /dev/nvme0n1p1
```

Use the correct device and filesystem-specific command for your system.

XFS is grown while mounted. Ext4 can often be expanded while mounted, but the correct procedure depends on the device and configuration.

### Step 6: Verify the result

```bash
lsblk
df -hT
```

**Important:** Increasing an EBS volume does not automatically expand every partition, logical volume, or filesystem. Each layer must be checked.

## 22. Understand LVM — Logical Volume Manager

LVM adds a flexible management layer between physical storage and filesystems.

### LVM architecture

```text
Physical Disk / Partition
          |
          v
    Physical Volume (PV)
          |
          v
     Volume Group (VG)
          |
          v
     Logical Volume (LV)
          |
          v
      Filesystem
          |
          v
       Mount Point
```

### Key components

- **Physical Volume (PV):** A disk or partition initialized for LVM.
- **Volume Group (VG):** A pool of storage made from one or more PVs.
- **Logical Volume (LV):** A virtual block device allocated from a VG.
- **Filesystem:** The filesystem created on the LV.

### Inspect LVM configuration

```bash
sudo pvs
sudo vgs
sudo lvs
```

Detailed information:

```bash
sudo pvdisplay
sudo vgdisplay
sudo lvdisplay
```

### Basic LVM lab

**Warning:** Perform this lab only with a newly created, empty test disk. Do not initialize a production disk containing data.

Identify the new device first. The following commands assume `/dev/nvme1n1` is a confirmed empty test disk.

Initialize the physical volume:

```bash
sudo pvcreate /dev/nvme1n1
```

Create a volume group:

```bash
sudo vgcreate vg_data /dev/nvme1n1
```

Create a logical volume:

```bash
sudo lvcreate -L 2G -n lv_app vg_data
```

Create an XFS filesystem:

```bash
sudo mkfs.xfs /dev/vg_data/lv_app
```

Create and mount the directory:

```bash
sudo mkdir -p /data/lvm
sudo mount /dev/vg_data/lv_app /data/lvm
```

Verify:

```bash
sudo pvs
sudo vgs
sudo lvs
df -hT /data/lvm
```

### Extend a logical volume

Inspect free space in the volume group:

```bash
sudo vgs
```

If the VG has sufficient free space, extend the LV and grow its filesystem:

```bash
sudo lvextend -r -L +1G /dev/vg_data/lv_app
```

The `-r` option requests filesystem resizing along with LV expansion when supported.

Verify:

```bash
sudo lvs
df -hT /data/lvm
```

LVM commands must target the correct PV, VG, and LV. Never copy example device names into a real server without checking the storage layout.

## 23. Filesystem and Storage Performance

Advanced storage management requires understanding more than disk capacity.

### Key performance concepts

| Concept | Explanation |
|---|---|
| IOPS | Number of input/output operations performed per second |
| Throughput | Amount of data transferred per second |
| Latency | Time taken to complete a storage operation |
| Queue depth | Number of outstanding storage operations |
| Block size | Amount of data handled by an individual I/O operation |
| Sequential I/O | Reading or writing data in adjacent locations |
| Random I/O | Reading or writing data at scattered locations |

### Common Linux tools

```bash
iostat -xz 1
vmstat 1
pidstat -d 1
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
```

For advanced testing, `fio` can generate controlled I/O workloads. Run benchmarks only on dedicated test storage because they can degrade performance and overwrite data if configured incorrectly.

## 24. Storage Observability With Prometheus and Grafana

A production-oriented monitoring solution should collect filesystem and storage metrics continuously.

### Example architecture

```text
Linux EC2 Instance
        |
        v
   node_exporter
        |
        v
    Prometheus
        |
        v
     Grafana
        |
        v
 Dashboards and Alerts
```

### Suggested dashboard panels

- Total filesystem capacity.
- Used and available disk space.
- Filesystem utilization percentage.
- Inode utilization percentage.
- Disk read and write throughput.
- I/O operations per second.
- Device latency and utilization.
- Storage capacity growth over time.

### Suggested alert thresholds

| Condition | Example Action |
|---|---|
| Disk usage above 80% | Warning |
| Disk usage above 90% | Critical alert |
| Inodes above 85% | Warning |
| Inodes above 95% | Critical alert |
| Rapid capacity growth | Investigate the source |
| Persistent I/O latency increase | Investigate workload and storage performance |
| Expected filesystem missing | Investigate mount or device failure |

These are starting thresholds, not universal production standards. Tune them according to workload, filesystem size, growth rate, and incident response requirements.

## 25. Capacity Planning and Incident Prevention

Storage capacity planning helps prevent production outages before they occur.

### Estimate time to exhaustion

A simple estimate is:

```text
Time to Exhaustion =
Available Disk Capacity / Average Daily Growth
```

For example:

- Available space: 100 GB.
- Average growth: 10 GB per day.
- Estimated time to exhaustion: 10 days.

This estimate assumes a constant growth rate. Real workloads can change rapidly, so use historical metrics and conservative safety margins.

### Prevention strategies

- Configure log rotation and retention.
- Monitor disk and inode usage.
- Alert before capacity becomes critical.
- Track storage growth over time.
- Review temporary-file cleanup.
- Monitor database and application write patterns.
- Maintain backups and test recovery procedures.
- Document disk expansion and filesystem repair runbooks.
- Test monitoring and alerts before production deployment.

---

# 26. Production Troubleshooting Checklist

Use this checklist when a Linux application reports storage-related errors.

- [ ] Check `df -h` for filesystem capacity.
- [ ] Check `df -i` for inode utilization.
- [ ] Run `lsblk -f` to inspect devices and filesystems.
- [ ] Run `findmnt` to verify mounts.
- [ ] Use `du` to locate large directories.
- [ ] Inspect deleted-but-open files using `lsof +L1`, if available.
- [ ] Review `dmesg` and `journalctl` for filesystem or device errors.
- [ ] Check storage I/O with `iostat` and process-level tools.
- [ ] Verify `/etc/fstab` entries before rebooting.
- [ ] Confirm backups and maintenance requirements before making destructive changes.
- [ ] Record the root cause, corrective action, and prevention steps.

# 27. Hands-On Project Assignments

Complete these projects in order and document each one in GitHub.

### Project 1 — Linux Storage Fundamentals

Tasks:

- Inspect the default EC2 root disk.
- Understand partitions, filesystems, and mount points.
- Compare `lsblk`, `df`, `du`, and `findmnt`.
- Identify filesystem UUIDs.
- Mount a new test volume.
- Configure a persistent mount.

Deliverable: Screenshots or terminal output, explanations, and a storage architecture diagram.

### Project 2 — Automated Disk Monitoring

Tasks:

- Write a Bash monitoring script.
- Configure disk usage thresholds.
- Add inode monitoring.
- Write logs to a dedicated location.
- Schedule the script using cron or systemd.
- Test the warning logic safely.

Deliverable: Script, scheduling configuration, sample logs, and documentation.

### Project 3 — Linux Disk Incident Simulation

Tasks:

- Create a disposable test filesystem.
- Reproduce a high disk-usage scenario.
- Investigate inode utilization.
- Identify a deleted-but-open file in a controlled environment.
- Diagnose a simulated mount configuration problem.
- Document the resolution.

Deliverable: Incident report containing symptoms, investigation, root cause, remediation, and prevention.

### Project 4 — AWS EBS Expansion

Tasks:

- Create and attach an additional EBS volume.
- Record the initial disk and filesystem sizes.
- Expand the volume.
- Grow the partition if necessary.
- Expand the filesystem.
- Verify the new usable capacity.

Deliverable: Step-by-step AWS storage expansion runbook with verification output.

### Project 5 — LVM Storage Management

Tasks:

- Create a PV, VG, and LV using an empty test disk.
- Create a filesystem on the LV.
- Mount the filesystem.
- Extend the logical volume.
- Grow the filesystem.
- Verify the final capacity.

Deliverable: LVM architecture diagram, commands, and troubleshooting notes.

### Project 6 — Storage Monitoring Dashboard

Tasks:

- Deploy a metrics exporter.
- Configure Prometheus scraping.
- Build Grafana panels for filesystem and device metrics.
- Configure warning and critical thresholds.
- Test alerts using a safe simulation.

Deliverable: Dashboard screenshots, configuration files, and an alerting runbook.

# 28. Recommended Repository Structure

```text
linux-disk-management/
├── README.md
├── docs/
│   ├── 01-storage-fundamentals.md
│   ├── 02-filesystems-and-mounts.md
│   ├── 03-persistent-mounts.md
│   ├── 04-permissions-and-ownership.md
│   ├── 05-production-troubleshooting.md
│   ├── 06-aws-ebs-expansion.md
│   ├── 07-lvm-storage.md
│   ├── 08-performance-analysis.md
│   └── 09-capacity-planning.md
├── scripts/
│   └── disk-monitor.sh
├── systemd/
│   ├── disk-monitor.service
│   └── disk-monitor.timer
├── monitoring/
│   └── README.md
├── labs/
│   ├── lab-01-storage-basics.md
│   ├── lab-02-disk-monitoring.md
│   ├── lab-03-troubleshooting.md
│   ├── lab-04-ebs-expansion.md
│   └── lab-05-lvm.md
└── incident-reports/
    └── README.md
```

# 29. Interview Preparation

You should be able to explain and demonstrate the following questions:

1. What is the difference between a disk, partition, filesystem, and mount point?
2. What is the difference between `df` and `du`?
3. Can a filesystem run out of inodes when free disk space is available?
4. What happens when a file is deleted while a process still has it open?
5. Why might `df` show high disk usage while `du` reports less?
6. How does `/etc/fstab` work?
7. What is the difference between XFS and ext4?
8. What causes a filesystem to become read-only?
9. How do you troubleshoot a disk that has reached 100% utilization?
10. How do you expand an AWS EBS volume without recreating the instance?
11. What is the difference between PV, VG, and LV in LVM?
12. How do you investigate high disk I/O latency?
13. How do you monitor disk utilization using Prometheus and Grafana?
14. How do you prevent storage-related production outages?
15. What checks should you perform before running filesystem repair tools?

For every question, prepare a practical example and explain the commands, expected output, risks, and recovery procedure.

# 30. Best Practices

- Always identify the correct disk before changing its partition table.
- Never format a disk without confirming its contents and purpose.
- Back up important data and configurations before risky changes.
- Validate `/etc/fstab` before rebooting.
- Use UUIDs or other appropriate stable identifiers for persistent mounts.
- Monitor inodes as well as disk capacity.
- Avoid deleting application or database files blindly.
- Use least-privilege permissions.
- Test filesystem expansion and repair procedures in a non-production environment.
- Monitor both storage capacity and I/O performance.
- Document production incidents and preventive actions.
- Clean up AWS lab resources after completing exercises to avoid unnecessary charges.

# 31. Final Outcome

After completing this repository, you should be able to manage Linux storage from basic device inspection to production-oriented monitoring, troubleshooting, AWS EBS expansion, LVM administration, and capacity planning.

The goal is not simply to memorize Linux commands. It is to understand how storage works, recognize failures, diagnose their causes, apply safe corrective actions, and prevent future incidents.

**Learning principle:** Understand the concept → Execute the command → Verify the output → Simulate a failure → Troubleshoot → Document the solution.

---

## Author

**Cloud & DevOps Engineering — Hands-On Learning Portfolio**

This repository is part of a practical journey toward mastering Linux administration, AWS, DevOps automation, monitoring, and production troubleshooting.
