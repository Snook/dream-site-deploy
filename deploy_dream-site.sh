sudo -u dreamweb git --git-dir=./dream-site/.git pull origin main

sudo chown -R dreamweb:dreamweb ./dream-site/* 2>/dev/null
sudo chown -R dreamweb:webdev ./dream-site/includes/config 2>/dev/null
sudo chown -R apache:dreamweb ./dream-site/www/theme/dreamdinners/images/charts/* 2>/dev/null
sudo chown -R apache:dreamweb ./dream-site/assets/* 2>/dev/null

sudo find ./dream-site/ -type d -exec chmod 775 {} \; ! -path .git
sudo find ./dream-site/ -type f -exec chmod 664 {} \; ! -path .git