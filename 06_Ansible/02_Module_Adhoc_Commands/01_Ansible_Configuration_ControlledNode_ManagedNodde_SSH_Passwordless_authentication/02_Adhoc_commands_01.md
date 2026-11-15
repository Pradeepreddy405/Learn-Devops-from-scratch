
### Caution : Because i have already configured passwordless SSH authentication, you can eventually move the SSH username and private key into your inventory or ansible.cfg. For now, explicitly specifying them in every command is excellent practice for understanding how Ansible connects to managed nodes.


# 1. Connectivity & basic information


### 1. Test connectivity
ansible all -i inventory/hosts -m ping

### 2. Check hostname
ansible all -i inventory/hosts -m command -a "hostname"

### 3. Check uptime
ansible all -i inventory/hosts -m command -a "uptime"

### 4. Check OS information
ansible all -i inventory/hosts -m command -a "cat /etc/os-release"

### 5. Check kernel version
ansible all -i inventory/hosts -m command -a "uname -r"

### 6. Check current logged-in user
ansible all -i inventory/hosts -m command -a "whoami"

### 7. Check system date
ansible all -i inventory/hosts -m command -a "date"

---


# 2. Linux resource monitoring

### 8. Check disk utilization
ansible all -i inventory/hosts -m command -a "df -Th"

### 9. Check memory utilization
ansible all -i inventory/hosts -m command -a "free -h"

### 10. Check CPU cores
ansible all -i inventory/hosts -m command -a "nproc"

### 11. Check CPU information
ansible all -i inventory/hosts -m command -a "lscpu"

### 12. Check running processes
ansible all -i inventory/hosts -m command -a "ps -ef"

### 13. Check filesystem mounts
ansible all -i inventory/hosts -m command -a "findmnt"

### 14. Check block devices
ansible all -i inventory/hosts -m command -a "lsblk"

### 15. Check disk space in human-readable format
ansible all -i inventory/hosts -m command -a "du -sh /var/log"


---

# 3. File and directory management


### 16. Create directory
ansible all -i inventory/hosts -m file -a "path=/opt/devops state=directory" -b

### 17. Create empty file
ansible all -i inventory/hosts -m file -a "path=/opt/devops/hello.txt state=touch" -b

### 18. Change file permissions
ansible all -i inventory/hosts -m file -a "path=/opt/devops/hello.txt mode=0644" -b

### 19. Change directory permissions
ansible all -i inventory/hosts -m file -a "path=/opt/devops mode=0755" -b

### 20. Check directory contents
ansible all -i inventory/hosts -m command -a "ls -l /opt/devops"

### 21. Delete file
ansible all -i inventory/hosts -m file -a "path=/opt/devops/hello.txt state=absent" -b

### 22. Delete directory
ansible all -i inventory/hosts -m file -a "path=/opt/devops state=absent" -b


---

#4. User and group management


### 23. Create Linux user
ansible all -i inventory/hosts -m user -a "name=devopsuser state=present" -b

### 24. Verify user
ansible all -i inventory/hosts -m command -a "id devopsuser"

### 25. Create Linux group
ansible all -i inventory/hosts -m group -a "name=devopsgroup state=present" -b

### 26. Add user to group
ansible all -i inventory/hosts -m user -a "name=devopsuser groups=devopsgroup append=yes" -b

### 27. Verify group membership
ansible all -i inventory/hosts -m command -a "groups devopsuser"

### 28. Delete user
ansible all -i inventory/hosts -m user -a "name=devopsuser state=absent remove=yes" -b

### 29. Delete group
ansible all -i inventory/hosts -m group -a "name=devopsgroup state=absent" -b


---

# 5. Package management (Amazon Linux 2023)


### 30. Check whether Nginx is installed
ansible all -i inventory/hosts -m command -a "rpm -q nginx"

### 31. Install Nginx
ansible all -i inventory/hosts -m dnf -a "name=nginx state=present" -b

### 32. Check installed Nginx version
ansible all -i inventory/hosts -m command -a "nginx -v"

### 33. Remove Nginx
ansible all -i inventory/hosts -m dnf -a "name=nginx state=absent" -b

### 34. Update all installed packages
ansible all -i inventory/hosts -m dnf -a "name=* state=latest" -b


Caution : Task 34 updates all packages. Avoid running it on production systems without change approval.

---

# 6. Service management


### 35. Start Nginx - Install Nginx first (Task 31).
ansible all -i inventory/hosts -m service -a "name=nginx state=started" -b

### 36. Check Nginx status
ansible all -i inventory/hosts -m command -a "systemctl status nginx"

### 37. Enable Nginx at boot
ansible all -i inventory/hosts -m service -a "name=nginx enabled=yes" -b

### 38. Restart Nginx
ansible all -i inventory/hosts -m service -a "name=nginx state=restarted" -b

### 39. Stop Nginx
ansible all -i inventory/hosts -m service -a "name=nginx state=stopped" -b

### 40. Disable Nginx at boot
ansible all -i inventory/hosts -m service -a "name=nginx enabled=no" -b


---

# 7. File transfer – Copy and Fetch


### 41. Copy a local file from controller to managed nodes
ansible all -i inventory/hosts -m copy -a "src=/home/ec2-user/test.txt dest=/tmp/test.txt" 

### 42. Copy a file with specific permissions
ansible all -i inventory/hosts -m copy -a "src=/home/ec2-user/test.txt dest=/tmp/test.txt mode=0644"

### 43. Fetch a file from managed nodes to controller
ansible all -i inventory/hosts -m fetch -a "src=/etc/os-release dest=/tmp/ansible-fetch/"


For Tasks 41–42, first create /home/ec2-user/test.txt on the controller.


---

# 8. Shell and command modules


### 44. Execute a basic command
ansible all -i inventory/hosts -m command -a "ls -l /tmp"

### 45. Execute multiple commands using shell
ansible all -i inventory/hosts -m shell -a "hostname && uptime"

### 46. Use pipes with shell
ansible all -i inventory/hosts -m shell -a "df -h | grep nvme"

### 47. Search for a process
ansible all -i inventory/hosts -m shell -a "ps -ef | grep nginx"

### 48. Check environment variables
ansible all -i inventory/hosts -m shell -a "echo \$HOME"

---

# 9. Ansible facts


### 49. Gather all system facts
ansible all -i inventory/hosts -m setup

### 50. Gather distribution information
ansible all -i inventory/hosts -m setup -a "filter=ansible_distribution*"

### 51. Gather memory information
ansible all -i inventory/hosts -m setup -a "filter=ansible_memory_mb"

### 52. Gather processor information
ansible all -i inventory/hosts -m setup -a "filter=ansible_processor*"

### 53. Gather IP address information
ansible all -i inventory/hosts -m setup -a "filter=ansible_default_ipv4"

---

# 10. Targeting and execution control


### 54. Execute on all managed nodes
ansible all -i inventory/hosts -m ping

### 55. Execute only on Node 1
ansible AnsibleNode1 -i inventory/hosts -m ping

### 56. Execute only on Node 2
ansible AnsibleNode2 -i inventory/hosts -m ping

### 57. Execute on a particular group
ansible managed_nodes -i inventory/hosts -m ping

### 58. Limit execution to Node 1
ansible all -i inventory/hosts --limit AnsibleNode1 -m command -a "hostname"

### 59. Execute with increased forks
ansible all -i inventory/hosts -f 10 -m ping

### 60. Check Ansible version
ansible --version

### 61. Check inventory
ansible-inventory -i inventory/hosts --list

### 62. List available hosts
ansible all -i inventory/hosts --list-hosts