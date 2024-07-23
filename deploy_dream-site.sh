#!/bin/bash
sudo -u dreamweb git -C ./dream-site pull origin main

# Check if there are changes
if [[ $(sudo -u dreamweb git -C ./dream-site status --porcelain -uno) ]]; then
  # There are changes, proceed with the rest of the script
  # Update config.ini version with git commit hash
  sed -i -e "/version =/ s/= .*/= $(sudo -u dreamweb git -C ./dream-site/ rev-parse HEAD)/" ./dream-site/includes/config/config.ini

  sudo chown -R dreamweb:dreamweb ./dream-site/* 2>/dev/null
  sudo chown -R dreamweb:webdev ./dream-site/includes/config 2>/dev/null
  sudo chown -R apache:dreamweb ./dream-site/www/theme/dreamdinners/images/charts/* 2>/dev/null
  sudo chown -R apache:dreamweb ./dream-site/assets/* 2>/dev/null

  sudo find ./dream-site/ -type d -exec chmod 775 {} \; ! -path .git
  sudo find ./dream-site/ -type f -exec chmod 664 {} \; ! -path .git
else
  # No changes, exit the script
  echo "No changes detected, exiting script."
  exit 0
fi