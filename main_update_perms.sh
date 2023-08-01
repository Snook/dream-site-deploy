#!/bin/bash

while getopts :y:z: flag; do
  case "${flag}" in
  y) linux_user=${OPTARG} ;;
  z) linux_group=${OPTARG} ;;
  :)
    echo "Option -$OPTARG requires an argument." >&2
    exit 1
    ;;
  esac
done

if [ -z ${linux_user+x} ]; then
  linux_user="dreamweb"
fi

if [ -z ${linux_group+x} ]; then
  linux_group="webdev"
fi

cd /DreamSite

echo Refreshing file and directory permissions ...

(
  chown -R $linux_user:$linux_group /DreamSite/* 2>/dev/null
  chown -R apache:webdev /DreamSite/www/theme/dreamdinners/images/charts/* 2>/dev/null
  chown -R apache:webdev /DreamSite/assets/* 2>/dev/null
) &

directory=0
file=0
total=0

# save the current system IFS so we can restore it later
sysifs=$IFS

# the next line is purposely broken over 2 lines! it literally
# reads as IFS="<tab><enter>"; and it must stay that way to work.
IFS="
"

for a in $(find ./); do
  if test -d $a; then
    directory=$(($directory + 1))
    #echo "Set Permissions=775 On Directory: $a"
    chmod 775 $a
  else
    file=$(($file + 1))
    #echo "Set Permissions=664 On File: $a"
    chmod 664 $a
  fi

  total=$(($total + 1))

done

# restore the system IFS
IFS=$sysifs

(
  chmod -R 700 /DreamSite/www/theme/dreamdinners/images/charts/* 2>/dev/null
  chmod -R 774 /DreamSite/assets/* 2>/dev/null
) &

echo Permissions set on $directory directories.
echo Permissions set on $file files.
echo Permissions update complete!