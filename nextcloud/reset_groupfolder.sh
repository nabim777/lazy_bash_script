#  !/bin/bash

# ============================================
# Script: Reset Groupfolder Apps in Nextcloud
# ============================================


# We can remove user, group folder, group
# and it is dynamically done

# ENV Variables:
# - NEXTCLOUD_CONTAINER_ID: (Required) Docker container ID of the Nextcloud instance
# - SHOW_BASH_OUTPUT: (Options) Set to 'true' to show command output (default is false)
# - NC_USERNAME: (optional) Nextcloud username (default is Openproject)
# - DEBUG: (Opional) by default set to false


# Example:
#   export NEXTCLOUD_CONTAINER_ID=bbe57f6c08ae
#   export SHOW_BASH_OUTPUT=true
#   NC_USERNAME=alice
#   DEBUG=true


# Command to run script:
#   NEXTCLOUD_CONTAINER_ID=bbe57f6c08ae bash reset_groupfolder.sh


# helper function
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

# Check if required env var is set
if [[ -z "${NEXTCLOUD_CONTAINER_ID:-}" ]]; then
    log_error "Error: NEXTCLOUD_CONTAINER_ID is not set."
    exit 1
fi

# By default delete the Openproject user
if [[ -z "$NC_USERNAME" ]]; then
  NC_USERNAME='OpenProject'
fi

# By default delete the Openproject group
if [[ -z "$NC_GROUPNAME" ]]; then
  NC_GROUPNAME='OpenProject'
fi

# Dcoker related
DOCKER_COMMAND="docker exec -it $NEXTCLOUD_CONTAINER_ID sh -c"

# Occ command
OCC_DISABLE_IO_COMMAND='occ a:d integration_openproject'
OCC_ENABLE_IO_COMMAND='occ a:e integration_openproject'
OCC_LIST_FOLDER_COMMAND='occ groupfolders:list'
OCC_DELETE_FOLDER_COMMAND='occ groupfolders:delete'
OCC_DELETE_USER_COMMAND='php occ user:delete'
OCC_DELETE_GROUP_COMMAND='php occ group:delete'

if([[ "$SHOW_BASH_OUTPUT" == "true" ]]); then
    log_info "Bash Message will be shown"
    SHOW_BASH_OUTPUT=
else
    log_info "Note: To show the Bash output need env 'SHOW_BASH_OUTPUT=true'"
    SHOW_BASH_OUTPUT='> /dev/null'
fi


echo -e "\nStep 1: Disabling the integration_openprojet ..."
IO_ENABLE_OUTPUT=$($DOCKER_COMMAND "${OCC_DISABLE_IO_COMMAND}")
log_info "$IO_ENABLE_OUTPUT"

echo -e "\nStep 2: Listing the group folder ..."
FILE_LIST=$($DOCKER_COMMAND "${OCC_LIST_FOLDER_COMMAND}" $SHOW_BASH_OUTPUT)
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
    $DOCKER_COMMAND "${OCC_DELETE_FOLDER_COMMAND} ${id} -f"
  done
fi


echo -e "\nStep 4: Deleting the user \"$NC_USERNAME\"..."
$DOCKER_COMMAND "${OCC_DELETE_USER_COMMAND} ${NC_USERNAME}"


echo -e "\nStep 5: Deleting the group \"$NC_GROUPNAME\"..."
$DOCKER_COMMAND "${OCC_DELETE_GROUP_COMMAND} ${NC_GROUPNAME}"


echo -e "\nStep 6: Enabling the integration_openprojet ..."
IO_DISABLE_OUTPUT=$($DOCKER_COMMAND "${OCC_ENABLE_IO_COMMAND}")
log_info "$IO_DISABLE_OUTPUT"

## to do
# env SHOW_BASH_OUTPUT not working when true


## to do
## dynamically do for local set up also