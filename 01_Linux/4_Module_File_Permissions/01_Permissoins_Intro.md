## 1. What are Linux permissions?

- Linux permissions are a security mechanism that controls who can read, modify, or execute a file/directory.
- Linux permissions provide access control for files and directories. Every file has an owner and a group owner, and permissions are defined for owner, group and others. The basic permissions are read, write and execute, represented as 4, 2 and 1.

- For example, 750 means the owner has rwx, the group has r-x, and others have no permissions. Linux determines access by first checking whether the user is the owner; otherwise it checks whether the user belongs to the file's group; if neither applies, it uses the others permissions.



- Every file and directory has three permission categories:
	- Owner → the user who owns the file
	- Group → the group associated with the file
	- Others → everyone else

	And three basic permissions:
	```
		Permission		File						Directory
		============== 	====						===========
		r				Read file contents			List directory contents
		w				Modify file contents		Create/delete/rename files
		x				Execute file				Enter/traverse directory
	
	```

	### 1.2 Basic example
	- Run:ls -l app.sh
	- You might see : -rwxr-x--- 1 pradeep devops 2048 Aug 13 17:00 app.sh
	- Break it down:
	
	```
		- rwx r-x ---
		│   │   │
		│   │   └── Others
		│   └────── Group
		└────────── Owner
		
		So:
		
		Owner  = pradeep
		Group  = devops
		Others = everyone else
		
		Permissions:
			- Owner  → rwx
			- Group  → r-x
			- Others → ---
		
		Meaning:
			- pradeep can read, write and execute.
			- Members of devops can read and execute.
			- Everyone else has no access.
	```	
		---

	### 1.3 How Linux decides access
	- Suppose " - rwx r-x --- pradeep devops app.sh " and user john belongs to any of the groups
		- developers
		- devops
		- docker


	- "Which permission does John get?"
		- Linux does not combine all three permission sets.It determines the user's relationship to the file.
		- Is the user the owner?
		- If not, is the user a member of the file's group?
		- If neither, use others.

	- So if John is a member of devops, he gets the group permissions "r-x". He does not get "rwx + r-x" and he does not get permissions from all his groups.

	- A file has:
		- ONE owner
		- ONE group owner

	- A user can belong to ONE primary group and as well as multiple supplementary groups



	### 1.4 Numeric permissions
	- Linux represents permissions using numbers:
		```
			- r = 4
			- w = 2
			- x = 1
		```
	- Therefore we can represent permissions using in numeric format as below
		```
			rwx = 4 + 2 + 1 = 7
			rw- = 4 + 2 = 6
			r-x = 4 + 1 = 5
			r-- = 4
			--- = 0
		```
	- For example if " rwx r-x --- "
		```
		we get:
			rwx = 7
			r-x = 5
			--- = 0

		Therefore if we run "chmod 750 app.sh"
		means:
			- Owner  = 7 = rwx
			- Group  = 5 = r-x
			- Others = 0 = ---

		```
	### 1.5 chmod
	- chmod changes permissions.
		```
			1 Example : chmod 755 deploy.sh

			means:
				Owner  → rwx
				Group  → r-x
				Others → r-x
	
			2 Example : chmod 640 config.txt

			means:
				Owner  → rw-
				Group  → r--
				Others → ---
		```
	- For DevOps, you'll frequently see permissions such as:
	- chmod 600 private-key.pem
	- chmod 644 config.yaml
	- chmod 755 script.sh
	- chmod 750 deploy.sh



	### 1.6 chown
	- chown changes ownership.
	- Example : chown pradeep app.txt this command changes the owner from existed owner to pradeep.

	- Change owner and group "chown pradeep:devops app.txt "
		- Now:
		- Owner = pradeep
		- Group = devops

	- You can verify "ls -l app.txt "



	### 1.7 chgrp
	- Changes only the group  
	- Example : chgrp devops app.txt



