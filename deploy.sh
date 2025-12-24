#!/bin/bash

# Deployment Script for CyberPanel Static Website
# This script pulls the latest changes from Git and deploys to the web server

set -e  # Exit on error

# Configuration
DEPLOY_PATH="/home/yourdomain.com/public_html"
BRANCH="main"
LOG_FILE="/var/log/website-deployment.log"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages
log_message() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a "$LOG_FILE"
}

# Start deployment
log_message "Starting deployment process..."

# Navigate to deployment directory
if [ ! -d "$DEPLOY_PATH" ]; then
    log_error "Deployment path does not exist: $DEPLOY_PATH"
    exit 1
fi

cd "$DEPLOY_PATH" || exit 1
log_message "Changed to directory: $DEPLOY_PATH"

# Check if it's a git repository
if [ ! -d ".git" ]; then
    log_error "Not a git repository. Please initialize git first."
    exit 1
fi

# Backup current version (optional)
BACKUP_DIR="/home/backups/website-$(date '+%Y%m%d-%H%M%S')"
log_message "Creating backup at: $BACKUP_DIR"
mkdir -p "$(dirname "$BACKUP_DIR")"
cp -r "$DEPLOY_PATH" "$BACKUP_DIR" 2>/dev/null || log_warning "Backup creation failed"

# Fetch latest changes
log_message "Fetching latest changes from remote..."
git fetch origin "$BRANCH"

# Check if there are any changes
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/"$BRANCH")

if [ "$LOCAL" = "$REMOTE" ]; then
    log_message "Already up to date. No deployment needed."
    exit 0
fi

# Pull latest changes
log_message "Pulling latest changes from branch: $BRANCH"
git pull origin "$BRANCH"

# Set proper permissions
log_message "Setting file permissions..."
find "$DEPLOY_PATH" -type f -exec chmod 644 {} \;
find "$DEPLOY_PATH" -type d -exec chmod 755 {} \;

# Clear cache if needed (optional)
if [ -d "$DEPLOY_PATH/.cache" ]; then
    log_message "Clearing cache..."
    rm -rf "$DEPLOY_PATH/.cache"
fi

# Deployment completed
log_message "✅ Deployment completed successfully!"
log_message "Current commit: $(git rev-parse --short HEAD)"
log_message "Commit message: $(git log -1 --pretty=%B)"

# Send notification (optional - requires additional setup)
# curl -X POST -H 'Content-type: application/json' \
#   --data '{"text":"Website deployed successfully!"}' \
#   YOUR_WEBHOOK_URL

exit 0
