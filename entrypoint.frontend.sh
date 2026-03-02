#!/bin/sh
set -e

echo "Starting Coderr Frontend..."

# Get API URL from environment or use default
API_URL="${API_BASE_URL:-http://localhost/api/}"

echo "Configuring frontend with API_BASE_URL: $API_URL"

# Update config.js with environment variables
if [ -f /usr/share/nginx/html/shared/js/config.js ]; then
    sed -i "s|const API_BASE_URL = \".*\";|const API_BASE_URL = \"$API_URL\";|g" /usr/share/nginx/html/shared/js/config.js
    echo "✅ config.js updated successfully"
else
    echo "⚠️  Warning: config.js not found at expected location"
fi

echo "Starting Nginx..."
exec nginx -g 'daemon off;'
