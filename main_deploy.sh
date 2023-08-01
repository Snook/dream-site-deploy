#! /bin/bash
sysifs=$IFS

while getopts :u:p:r:v:e:lu:lg: flag; do
  case "${flag}" in
  u) username=${OPTARG} ;;
  p) password=${OPTARG} ;;
  s) svn=${OPTARG} ;;
  r) repo=${OPTARG} ;;
  v) revision=${OPTARG} ;;
  e) export=${OPTARG} ;;
  y) linux_user=${OPTARG} ;;
  z) linux_group=${OPTARG} ;;
  :)
    echo "Option -$OPTARG requires an argument." >&2
    exit 1
    ;;
  esac
done

if [ -z ${svn+x} ]; then
  svn="https://dreamdinners.sourcerepo.com"
fi

if [ -z ${repo+x} ]; then
  repo="dreamdinners/main/trunk/src/DreamSite"
fi

if [ -z ${export+x} ]; then
  export="htaccess,assets,www,includes,page,processor,templates,form,phplib,utility_scripts"
fi

if [ -z ${username+x} ]; then
  echo -n "Please enter SVN username: "
  read -e username
fi

if [ -z ${password+x} ]; then
  echo -n "Please enter SVN password: "
  read -e password
fi

if [ -z ${revision+x} ]; then
  echo -n "Please enter the revision number (press enter for HEAD): "
  read -e revision
  if [ "$revision" = "" ]; then
    revision="HEAD"
  fi
fi

if [ -z ${linux_user+x} ]; then
  linux_user="dreamweb"
fi

if [ -z ${linux_group+x} ]; then
  linux_group="webdev"
fi

# explode export directories
IFS=',' read -ra EXPRT <<<"$export"
for export_dir in "${EXPRT[@]}"; do
  case "$export_dir" in
  htaccess)
    (
      echo -e "Deploying /DreamSite/www/.htaccess ..."
      svn export -q --non-interactive --username $username --password $password --force -r $revision $svn/dreamdinners/main/trunk/src/DreamSite/htaccess/$HOSTNAME/.htaccess /DreamSite/www/.htaccess
    ) &
    ;;
  utility_scripts)
    (
      echo -e "Deploying /DreamSite/www/web_resources ..."
      svn export -q --non-interactive --username $username --password $password --force -r $revision $svn/dreamdinners/main/trunk/src/WebResources /DreamSite/www/web_resources
    ) &
    ;;
  htaccess)
    (
      echo -e "Deploying /DreamSite/_development/_utility_scripts ..."
      svn export -q --non-interactive --username $username --password $password --force -r $revision $svn/dreamdinners/main/trunk/src/_development/_utility_scripts /DreamSite/_development/_utility_scripts
    ) &
    ;;
  *)
    (
      echo -e "Deploying /DreamSite/$export_dir ..."
      svn export -q --non-interactive --username $username --password $password --force -r $revision $svn/$repo/$export_dir /DreamSite/$export_dir
    ) &
    ;;
  esac
done
wait

sh ./main_update_perms.sh -y $linux_user -z $linux_group

IFS=$sysifs

echo -e "\nDeployment complete!\n"