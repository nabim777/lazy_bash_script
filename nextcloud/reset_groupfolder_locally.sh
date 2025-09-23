#  !/bin/bash

# ============================================
# Script: Reset Groupfolder Apps in Nextcloud
# ============================================


# We can remove user, group folder, group
# and it is dynamically done

# ENV Variables:
# - SHOW_BASH_OUTPUT: (Options) Set to 'true' to show command output (default is false)
# - NC_USERNAME: (optional) Nextcloud username (default is Openproject)
# - DEBUG: (Opional) by default set to false


# Example:
#   export NEXTCLOUD_CONTAINER_ID=bbe57f6c08ae
#   export SHOW_BASH_OUTPUT=true
#   NC_USERNAME=alice
#   DEBUG=true


# Command to run script:
#  bash reset_groupfolder_locally.sh


# helper function

PATH_FILE="/home/nabin/www/stable31"
cd $PATH_FILE
echo -e "First go to path $PATH_FILE \n"

log_error() {
  echo -e "\e[31m$1\e[0m"
}

log_info() {
  echo -e "\e[37m$1\e[0m"
}

log_success() {
  echo -e "\e[32m$1\e[0m"
}

if [[ $DEBUG == "true" ]]; then
  log_info "Debug mode is enabled"
  set -x
  set -v
fi

# By default delete the Openproject user
if [[ -z "$NC_USERNAME" ]]; then
  NC_USERNAME='OpenProject'
fi

# By default delete the Openproject group
if [[ -z "$NC_GROUPNAME" ]]; then
  NC_GROUPNAME=("OpenProject" "OpenProjectNoAutomaticProjectFolders")
fi

# Dcoker related
LOCAL_COMMAND="sudo -u www-data php"

# Occ command
OCC_DISABLE_IO_COMMAND='occ a:d integration_openproject'
OCC_ENABLE_IO_COMMAND='occ a:e integration_openproject'
OCC_LIST_FOLDER_COMMAND='occ groupfolders:list'
OCC_DELETE_FOLDER_COMMAND='occ groupfolders:delete'
OCC_DELETE_USER_COMMAND='occ user:delete'
OCC_DELETE_GROUP_COMMAND='occ group:delete'

if([[ "$SHOW_BASH_OUTPUT" == "true" ]]); then
    log_info "Bash Message will be shown"
    SHOW_BASH_OUTPUT=
else
    log_info "Note: To show the Bash output need env 'SHOW_BASH_OUTPUT=true'"
    SHOW_BASH_OUTPUT='> /dev/null'
fi


echo -e "\nStep 1: Disabling the integration_openprojet ..."
IO_ENABLE_OUTPUT=$($LOCAL_COMMAND $OCC_DISABLE_IO_COMMAND 2>/dev/null)
log_info "$IO_ENABLE_OUTPUT"

echo -e "\nStep 2: Listing the group folder ..."
FILE_LIST=$($LOCAL_COMMAND $OCC_LIST_FOLDER_COMMAND 2>/dev/null)
folder_ids=($(printf '%s\n' "$FILE_LIST" | grep -E '^\| [0-9]+' | cut -d'|' -f2 | tr -d ' '))
SKIP3=false
if [[ -z "$folder_ids" ]]; then
  log_info "Nothing to delete group folders"
  log_info "So, skipping step 3\n\nstep 3: Deleting the folder ..."
  SKIP3=true
fi

if [[ $SKIP3 == false ]]; then
  echo -e "\nStep 3: Deleteing the folder ..."
  for id in "${folder_ids[@]}"; do
    log_info "Deleting folder having id $id"
    $LOCAL_COMMAND $OCC_DELETE_FOLDER_COMMAND $id -f 2>/dev/null
  done
fi


echo -e "\nStep 4: Deleting the user \"$NC_USERNAME\"..."
$LOCAL_COMMAND $OCC_DELETE_USER_COMMAND $NC_USERNAME 2>/dev/null

echo -e "\nStep 5:"
for str in ${NC_GROUPNAME[@]}; do
  log_info "\nDeleting the group \"$str\"..."
  $LOCAL_COMMAND $OCC_DELETE_GROUP_COMMAND $NC_GROUPNAME 2>/dev/null
done


echo -e "\nStep 6: Enabling the integration_openprojet ..."
IO_DISABLE_OUTPUT=$($LOCAL_COMMAND $OCC_ENABLE_IO_COMMAND 2>/dev/null)
log_info "$IO_DISABLE_OUTPUT"

## to do
# env SHOW_BASH_OUTPUT not working when true


## to do
## dynamically do for local set up also