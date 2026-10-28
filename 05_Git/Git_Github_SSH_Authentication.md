### SSH : A secure connection method using keys, not passwords.

(or)

SSH (Secure Shell) is a protocol that lets you securely connect to another computer over a network.
    - Log into remote servers
    - Run commands on a remote machine
    - Transfer files securely


### What are SSH Keys?
- SSH keys are a way to log in to a server without typing a password — and more securely.

They come as a pair:
    1. Private Key
            Stored on your computer
            Must be kept secret
            Like your personal signature
    2. Public Key
            You upload it to the server or GitHub
            Safe to share
            Like a lock that only your private key can open

### How keys work ?
- The server checks if it has your public key(you need to upload the publicket initially).
- If it matches → you're authenticated.

    
### Why are SSH Keys Used on Servers ?
- Servers use SSH keys to let admins log in securely.

Benefits:
- Passwords can be guessed; private keys cannot
- Faster authentication
- Can automate tasks (scripts, deployments)
        Harder to hack because the private key stays local

### Why are SSH Keys Used in Git & GitHub ?
- GitHub needs to confirm your identity.
- Instead of entering your GitHub password every time, you authenticate with SSH keys.


GitHub workflow:
Step 1 :You generate SSH keys on your computer
        cmd:ssh-keygen -t ed25519 -C "your_email@example.com"
            Private key → ~/.ssh/id_ed25519
            Public key → ~/.ssh/id_ed25519.pub

Step 2 :You upload public key → GitHub
            Github login -> Settings ->SSH and GPG Keys ->New SSH Key -> add Public key
Step 3 :Your private key stays with you
Step 4 :Test the SSH connection
        cmd   :ssh -T git@github.com
        output:Hi XXXXX! You've successfully authenticated, but GitHub does not provide shell access.
            
Step 5 :GitHub checks your key when you push or pull
Step 6 :This makes Git operations secure and convenient.
