# Complete Git Push Commands - Start to End

## 📋 PART 1: LOCAL SETUP (Already Done ✅)

```bash
# Navigate to project directory
cd c:\Users\Madhusudhan\Desktop\Gitpractice

# Initialize Git (Already done ✅)
git init

# Add all files (Already done ✅)
git add .

# Make first commit (Already done ✅)
git commit -m "Initial commit: Modern static website for CyberPanel deployment"
```

---

## 📋 PART 2: CREATE GITHUB REPOSITORY

### Option A: Using GitHub Website (Recommended)
1. Go to https://github.com
2. Click the **"+"** icon → **"New repository"**
3. Repository name: `my-static-website` (or any name you want)
4. Description: `Modern static website with CI/CD for CyberPanel`
5. Choose **Public** or **Private**
6. **DO NOT** check "Initialize with README" (we already have files)
7. Click **"Create repository"**

### Option B: Using GitHub CLI (if installed)
```bash
gh repo create my-static-website --public --source=. --remote=origin
```

---

## 📋 PART 3: CONNECT LOCAL REPO TO GITHUB

After creating the GitHub repository, you'll see a URL like:
`https://github.com/yourusername/my-static-website.git`

### Commands to run:

```bash
# Add GitHub as remote origin
git remote add origin https://github.com/yourusername/my-static-website.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub for the first time
git push -u origin main
```

**Note:** Replace `yourusername` and `my-static-website` with your actual GitHub username and repository name.

---

## 📋 PART 4: CONFIGURE GITHUB SECRETS (For CI/CD)

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Add these secrets one by one:

| Secret Name | Value | Example |
|------------|-------|---------|
| `SERVER_HOST` | Your CyberPanel server IP or domain | `123.45.67.89` or `server.example.com` |
| `SERVER_USERNAME` | SSH username | `root` or your domain user |
| `SSH_PRIVATE_KEY` | Your SSH private key content | See below for how to get this |
| `SSH_PORT` | SSH port number | `22` (default) |
| `DEPLOY_PATH` | Full path to website directory | `/home/yourdomain.com/public_html` |

### How to get SSH Private Key:

**On Windows (PowerShell):**
```powershell
# Generate SSH key (if you don't have one)
ssh-keygen -t rsa -b 4096 -C "github-actions-deploy"
# Press Enter for default location
# Press Enter twice for no passphrase

# View private key (copy this to GitHub secret)
Get-Content $env:USERPROFILE\.ssh\id_rsa

# View public key (copy this to server)
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub
```

**On Linux/Mac:**
```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t rsa -b 4096 -C "github-actions-deploy"

# View private key (copy this to GitHub secret)
cat ~/.ssh/id_rsa

# View public key (copy this to server)
cat ~/.ssh/id_rsa.pub
```

---

## 📋 PART 5: SETUP CYBERPANEL SERVER

### Connect to your server:
```bash
# SSH into your CyberPanel server
ssh root@your-server-ip
# Or if using specific user:
ssh yourusername@your-server-ip
```

### Add your SSH public key to server:
```bash
# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add your public key to authorized_keys
echo "your-public-key-content-here" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### Navigate to website directory:
```bash
# Go to your website directory
cd /home/yourdomain.com/public_html

# Initialize Git repository
git init

# Add GitHub as remote
git remote add origin https://github.com/yourusername/my-static-website.git

# Fetch from GitHub
git fetch origin

# Checkout main branch
git checkout main

# Pull latest code
git pull origin main
```

### Set proper permissions:
```bash
# Set file permissions
find /home/yourdomain.com/public_html -type f -exec chmod 644 {} \;
find /home/yourdomain.com/public_html -type d -exec chmod 755 {} \;

# Set ownership (replace 'yourdomain' with your actual domain)
chown -R yourdomain:yourdomain /home/yourdomain.com/public_html
```

---

## 📋 PART 6: TEST DEPLOYMENT

### Make a test change locally:
```bash
# Navigate to project directory
cd c:\Users\Madhusudhan\Desktop\Gitpractice

# Make a small change (add a comment to test)
echo "<!-- CI/CD Test -->" >> index.html

# Check status
git status

# Add changes
git add .

# Commit changes
git commit -m "Test: CI/CD deployment pipeline"

# Push to GitHub (this will trigger automatic deployment)
git push origin main
```

### Watch deployment:
1. Go to your GitHub repository
2. Click the **"Actions"** tab
3. You'll see your workflow running
4. Click on it to see real-time logs

---

## 📋 PART 7: VERIFY DEPLOYMENT

### Check on server:
```bash
# SSH into server
ssh root@your-server-ip

# Navigate to website directory
cd /home/yourdomain.com/public_html

# Check latest commit
git log -1

# Verify files exist
ls -la
```

### Check website in browser:
```
http://yourdomain.com
```

---

## 📋 DAILY WORKFLOW (After Initial Setup)

### Every time you make changes:

```bash
# 1. Navigate to project
cd c:\Users\Madhusudhan\Desktop\Gitpractice

# 2. Check what changed
git status

# 3. Add all changes
git add .

# 4. Commit with descriptive message
git commit -m "Update: describe what you changed"

# 5. Push to GitHub (auto-deploys to CyberPanel)
git push origin main
```

That's it! GitHub Actions will automatically:
- Validate your code
- Create a backup
- Deploy to your server
- Verify deployment
- Notify you of success/failure

---

## 🔧 USEFUL GIT COMMANDS

```bash
# View commit history
git log --oneline

# View current status
git status

# View remote repositories
git remote -v

# View current branch
git branch

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Pull latest changes from GitHub
git pull origin main

# View differences
git diff

# Create new branch
git checkout -b feature-name

# Switch branch
git checkout main

# Merge branch
git merge feature-name
```

---

## 🚨 TROUBLESHOOTING

### If push is rejected:
```bash
git pull origin main --rebase
git push origin main
```

### If you need to force push (use carefully):
```bash
git push origin main --force
```

### If deployment fails:
```bash
# Check GitHub Actions logs in the Actions tab
# SSH into server and check manually:
ssh root@your-server-ip
cd /home/yourdomain.com/public_html
git pull origin main
```

### Reset server to match GitHub:
```bash
ssh root@your-server-ip
cd /home/yourdomain.com/public_html
git fetch origin
git reset --hard origin/main
```

---

## ✅ QUICK CHECKLIST

- [ ] GitHub repository created
- [ ] Local repo connected to GitHub (`git remote add origin`)
- [ ] Initial push completed (`git push -u origin main`)
- [ ] GitHub secrets configured (SERVER_HOST, SSH_PRIVATE_KEY, etc.)
- [ ] SSH key added to server
- [ ] Server Git repository initialized
- [ ] Server pulled code from GitHub
- [ ] File permissions set correctly
- [ ] Test deployment successful
- [ ] Website accessible in browser

---

## 📞 NEED HELP?

If something doesn't work:
1. Check GitHub Actions logs (Actions tab)
2. Check server logs: `tail -f /var/log/website-deployment.log`
3. Verify SSH connection: `ssh root@your-server-ip`
4. Check file permissions on server
5. Verify GitHub secrets are correct

---

**You're all set! Happy deploying! 🚀**
