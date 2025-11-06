#!/bin/bash
APP_DIR="/var/www/myapp"
SERVICE_NAME="myapp"

echo "Cleaning old deployment..."
rm -rf $APP_DIR/old || true
mkdir -p $APP_DIR

echo "Copying new files..."
cp -r /tmp/deploy/* $APP_DIR

cd $APP_DIR

echo "Installing dependencies..."
npm install --production

echo "Restarting Node.js app..."
# Example: using pm2 to manage Node.js apps
pm2 stop $SERVICE_NAME || true
pm2 start app.js --name $SERVICE_NAME

echo "Deployment successful!"
