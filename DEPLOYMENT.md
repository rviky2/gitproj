# CI/CD Deployment Guide for CyberPanel

This guide explains how to set up automated CI/CD deployment for your static website to CyberPanel.

## 🚀 Deployment Options

### Option 1: GitHub Actions (Recommended)
### Option 2: GitLab CI/CD
### Option 3: Manual Deployment Script
### Option 4: Git Hooks (Server-side)

---

## 📋 Option 1: GitHub Actions CI/CD

### Step 1: Set Up GitHub Repository

1. Create a new repository on GitHub
2. Push your code:
```bash
git remote add origin https://github.com/yourusername/your-repo.git
git branch -M main
git push -u origin main
```

### Step 2: Configure GitHub Secrets

Go to your repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add the following secrets:

| Secret Name | Description | Example |
|------------|-------------|---------|
| `SERVER_HOST` | Your CyberPanel server IP or domain | `123.45.67.89` |
| `SERVER_USERNAME` | SSH username (usually root or domain user) | `root` |
| `SSH_PRIVATE_KEY` | Your SSH private key | `-----BEGIN RSA PRIVATE KEY-----...` |
| `SSH_PORT` | SSH port (default: 22) | `22` |
| `DEPLOY_PATH` | Path to your website | `/home/yourdomain.com/public_html` |

### Step 3: Generate SSH Key (if needed)

On your local machine:
```bash
ssh-keygen -t rsa -b 4096 -C "github-actions"
```

Copy the public key to your server:
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@your-server-ip
```

Copy the private key content for GitHub secrets:
```bash
cat ~/.ssh/id_rsa
```

### Step 4: Initialize Git on Server

SSH into your CyberPanel server:
```bash
ssh user@your-server-ip
cd /home/yourdomain.com/public_html
git init
git remote add origin https://github.com/yourusername/your-repo.git
git fetch
git checkout main
```

### Step 5: Test Deployment

Push a change to trigger the workflow:
```bash
git add .
git commit -m "Test CI/CD deployment"
git push origin main
```

Check the **Actions** tab in your GitHub repository to see the deployment progress.

---

## 📋 Option 2: Manual Deployment Script

### Step 1: Upload Deployment Script

Upload `deploy.sh` to your server:
```bash
scp deploy.sh user@your-server:/home/yourdomain.com/
```

### Step 2: Make Script Executable

SSH into your server:
```bash
ssh user@your-server-ip
chmod +x /home/yourdomain.com/deploy.sh
```

### Step 3: Edit Configuration

Edit the script to match your setup:
```bash
nano /home/yourdomain.com/deploy.sh
```

Update these variables:
```bash
DEPLOY_PATH="/home/yourdomain.com/public_html"
BRANCH="main"
```

### Step 4: Run Deployment

```bash
./deploy.sh
```

### Step 5: Set Up Cron Job (Optional)

For automatic deployments every hour:
```bash
crontab -e
```

Add this line:
```bash
0 * * * * /home/yourdomain.com/deploy.sh >> /var/log/deployment.log 2>&1
```

---

## 📋 Option 3: Git Hooks (Server-side Auto-Deploy)

### Step 1: Set Up Bare Repository

On your server:
```bash
mkdir -p /home/git/yourdomain.git
cd /home/git/yourdomain.git
git init --bare
```

### Step 2: Install Post-Receive Hook

```bash
cp hooks/post-receive /home/git/yourdomain.git/hooks/
chmod +x /home/git/yourdomain.git/hooks/post-receive
```

Edit the hook to match your paths:
```bash
nano /home/git/yourdomain.git/hooks/post-receive
```

### Step 3: Add Remote to Local Repository

On your local machine:
```bash
git remote add production user@your-server:/home/git/yourdomain.git
```

### Step 4: Deploy by Pushing

```bash
git push production main
```

The website will automatically deploy when you push!

---

## 🔧 CyberPanel Specific Configuration

### Set Proper Permissions

```bash
cd /home/yourdomain.com/public_html
chown -R yourdomain:yourdomain .
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
```

### Configure Git User

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Allow Git Operations

If using CyberPanel's user:
```bash
usermod -aG git yourdomain
```

---

## 🔐 Security Best Practices

1. **Use SSH Keys** - Never use passwords in CI/CD
2. **Restrict SSH Access** - Use specific deploy keys
3. **Set Proper Permissions** - Files: 644, Directories: 755
4. **Use Environment Variables** - Never commit secrets
5. **Enable Firewall** - Only allow necessary ports
6. **Regular Backups** - Automated before each deployment

---

## 📊 Monitoring & Logging

### View Deployment Logs

```bash
tail -f /var/log/website-deployment.log
```

### GitHub Actions Logs

Check the **Actions** tab in your GitHub repository

### Server Logs

```bash
journalctl -u nginx -f  # For Nginx logs
tail -f /usr/local/lsws/logs/error.log  # For LiteSpeed logs
```

---

## 🐛 Troubleshooting

### Issue: Permission Denied

```bash
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

### Issue: Git Pull Fails

```bash
cd /home/yourdomain.com/public_html
git reset --hard origin/main
git clean -fd
```

### Issue: SSH Connection Timeout

Check firewall:
```bash
sudo ufw allow 22/tcp
```

### Issue: Deployment Not Triggering

Check GitHub Actions workflow file syntax:
```bash
yamllint .github/workflows/deploy.yml
```

---

## 🎯 Workflow Summary

### Development Workflow

1. Make changes locally
2. Test locally (open `index.html` in browser)
3. Commit changes: `git commit -m "Description"`
4. Push to GitHub: `git push origin main`
5. GitHub Actions automatically deploys to CyberPanel
6. Verify deployment on your live website

### Rollback Procedure

```bash
cd /home/yourdomain.com/public_html
git log --oneline  # Find the commit to rollback to
git reset --hard <commit-hash>
```

---

## 📝 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [CyberPanel Documentation](https://cyberpanel.net/docs/)
- [Git Hooks Guide](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

---

## ✅ Checklist

- [ ] GitHub repository created
- [ ] SSH keys generated and configured
- [ ] GitHub secrets added
- [ ] Server Git repository initialized
- [ ] Deployment script tested
- [ ] Permissions configured correctly
- [ ] First deployment successful
- [ ] Monitoring and logging set up
- [ ] Backup strategy in place
- [ ] Documentation updated

---

**Your CI/CD pipeline is now ready! Every push to main will automatically deploy to your CyberPanel server.** 🚀
