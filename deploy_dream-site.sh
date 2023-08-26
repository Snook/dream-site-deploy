sudo -u dreamweb git --git-dir=./dream-site/.git pull origin main

sudo chown -R dreamweb:dreamweb ./dream-site/* 2>/dev/null
sudo chown -R dreamweb:webdev ./dream-site/includes/config 2>/dev/null
sudo chown -R apache:webdev ./dream-site/www/theme/dreamdinners/images/charts/* 2>/dev/null
sudo chown -R apache:webdev ./dream-site/assets/* 2>/dev/null

sudo find ./dream-site/ -type d -exec chmod 755 {} \; ! -path .git
sudo find ./dream-site/ -type f -exec chmod 664 {} \; ! -path .git

sudo chmod -R 700 ./dream-site/www/theme/dreamdinners/images/charts/* 2>/dev/null
sudo chmod -R 774 ./dream-site/assets/* 2>/dev/null