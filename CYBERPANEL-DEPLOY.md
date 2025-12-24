# CyberPanel Git Deployment Guide

## 🎯 Simple Deployment to CyberPanel Using Git

This guide shows you how to deploy your static website to CyberPanel using Git - the easiest way!

---

## 📋 Prerequisites

- ✅ CyberPanel installed on your server
- ✅ Domain/website created in CyberPanel
- ✅ SSH access to your server
- ✅ Git installed on server (usually pre-installed)

---

## 🚀 STEP-BY-STEP DEPLOYMENT

### **STEP 1: Push Your Code to GitHub**

On your local machine (Windows):

```powershell
# Navigate to project
cd c:\Users\Madhusudhan\Desktop\Gitpractice

# Create GitHub repository first (on GitHub website)
# Then connect and push:

git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO.git
git branch -M main
git push -u origin main
```

---

### **STEP 2: Connect to Your CyberPanel Server**

```powershell
# SSH into your server
ssh root@your-server-ip
# Enter your password when prompted
```

---

### **STEP 3: Navigate to Your Website Directory**

```bash
# Go to your website's public_html folder
cd /home/yourdomain.com/public_html

# Check if directory is empty
ls -la
```

**If directory has files**, backup or remove them:
```bash
# Backup existing files (optional)
mkdir /home/backups
cp -r /home/yourdomain.com/public_html /home/backups/backup-$(date +%Y%m%d)

# Clear directory
rm -rf /home/yourdomain.com/public_html/*
```

---

### **STEP 4: Clone Your Repository**

```bash
# Clone from GitHub
cd /home/yourdomain.com/public_html
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git .

# Note: The dot (.) at the end is important!
# It clones into the current directory
```

---

### **STEP 5: Set Proper Permissions**

```bash
# Set file permissions (important for security)
cd /home/yourdomain.com/public_html
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;

# Set ownership (replace 'yourdomain' with your actual domain)
chown -R yourdomain:yourdomain /home/yourdomain.com/public_html
```

---

### **STEP 6: Verify Deployment**

```bash
# Check files are there
ls -la

# You should see:
# - index.html
# - styles.css
# - script.js
# - README.md
# - etc.
```

---

### **STEP 7: Test Your Website**

Open your browser and visit:
```
http://yourdomain.com
```

**✅ Your website should be live!**

---

## 🔄 UPDATING YOUR WEBSITE (After Initial Deployment)

### **On Your Local Machine:**

```powershell
# Make changes to your files
# Then commit and push:

cd c:\Users\Madhusudhan\Desktop\Gitpractice
git add .
git commit -m "Updated website content"
git push origin main
```

### **On Your Server:**

```bash
# SSH into server
ssh root@your-server-ip

# Navigate to website directory
cd /home/yourdomain.com/public_html

# Pull latest changes
git pull origin main

# Done! Your website is updated.
```

---

## 🎨 USING CYBERPANEL'S GIT MANAGER (Alternative Method)

CyberPanel has a built-in Git manager that makes this even easier!

### **Step 1: Access Git Manager**

1. Log into CyberPanel: `https://your-server-ip:8090`
2. Go to **Websites** → **List Websites**
3. Click on your domain name
4. Scroll down to find **Git** section

### **Step 2: Configure Git Repository**

1. **Repository URL**: `https://github.com/YOUR-USERNAME/YOUR-REPO.git`
2. **Branch**: `main`
3. **Path**: `/home/yourdomain.com/public_html`
4. Click **Setup Git**

### **Step 3: Pull Code**

1. In the Git section, click **Pull**
2. Your code will be automatically deployed!

### **Step 4: Update Website**

Whenever you push changes to GitHub:
1. Go to CyberPanel Git section
2. Click **Pull**
3. Done!

---

## 🔐 SETTING UP SSH KEY (For Password-less Access)

### **On Your Local Machine (Windows PowerShell):**

```powershell
# Generate SSH key
ssh-keygen -t rsa -b 4096

# Press Enter 3 times (default location, no passphrase)

# View your public key
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub
# Copy this entire output
```

### **On Your Server:**

```bash
# Create .ssh directory
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add your public key
nano ~/.ssh/authorized_keys
# Paste your public key here
# Press Ctrl+X, then Y, then Enter to save

# Set permissions
chmod 600 ~/.ssh/authorized_keys
```

**Now you can SSH without password:**
```powershell
ssh root@your-server-ip
# No password needed!
```

---

## 📝 QUICK REFERENCE COMMANDS

### **Initial Deployment:**
```bash
cd /home/yourdomain.com/public_html
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git .
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
```

### **Update Website:**
```bash
cd /home/yourdomain.com/public_html
git pull origin main
```

### **Check Status:**
```bash
cd /home/yourdomain.com/public_html
git status
git log -1
```

### **Reset to Latest (if something breaks):**
```bash
cd /home/yourdomain.com/public_html
git fetch origin
git reset --hard origin/main
```

---

## 🐛 TROUBLESHOOTING

### **Problem: "Permission Denied"**
```bash
# Fix permissions
cd /home/yourdomain.com/public_html
chown -R yourdomain:yourdomain .
```

### **Problem: "Not a git repository"**
```bash
# Re-clone
cd /home/yourdomain.com/public_html
rm -rf *
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git .
```

### **Problem: "Website shows 404"**
```bash
# Check if index.html exists
cd /home/yourdomain.com/public_html
ls -la index.html

# Check file permissions
chmod 644 index.html
```

### **Problem: "Merge conflicts"**
```bash
# Reset to GitHub version
cd /home/yourdomain.com/public_html
git fetch origin
git reset --hard origin/main
```

---

## ✅ DEPLOYMENT CHECKLIST

- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] SSH access to CyberPanel server working
- [ ] Website directory located: `/home/yourdomain.com/public_html`
- [ ] Repository cloned to server
- [ ] File permissions set (644 for files, 755 for directories)
- [ ] Ownership set correctly
- [ ] Website accessible in browser
- [ ] Git pull tested and working

---

## 🎯 WORKFLOW SUMMARY

```
Local Changes → Git Commit → Push to GitHub → 
SSH to Server → Git Pull → Website Updated! ✅
```

**OR using CyberPanel:**

```
Local Changes → Git Commit → Push to GitHub → 
CyberPanel Git Manager → Click Pull → Website Updated! ✅
```

---

## 📞 COMMON CYBERPANEL PATHS

```bash
# Website files
/home/yourdomain.com/public_html

# Logs
/home/yourdomain.com/logs

# Backups
/home/backup/

# CyberPanel config
/usr/local/CyberCP/
```

---

## 🚀 NEXT STEPS

1. **Set up SSL certificate** in CyberPanel (free with Let's Encrypt)
2. **Configure caching** for better performance
3. **Set up automatic backups** in CyberPanel
4. **Monitor website** using CyberPanel's analytics

---

**Your website is now deployed on CyberPanel! 🎉**

For automatic deployments, see `DEPLOYMENT.md` for CI/CD setup.
