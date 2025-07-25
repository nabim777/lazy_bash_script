#  !/bin/bash

#!/bin/bash

# Required Configurable variables
# FOLDER_PATH
# BRANCH_CHECKOUT
# OWNER
# REPO
# GITHUB_TOKEN
# OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID

# for more information 
# Go to file owncloud/ReadMe_bump_ocis.md

echo "==================================="
echo "Script: Bump lastest ocis commit id" 
echo "==================================="

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


required_vars=(
  FOLDER_PATH
  BRANCH_CHECKOUT
  OWNER
  REPO
  GITHUB_TOKEN
  OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID
)

# Check if required var is set or not
for var in "${required_vars[@]}"; do
  if [[ -z "${!var}" ]]; then
    log_error "❌ Error: $var is not set."
    exit 1
  fi
done

echo "1: Entering folder: $FOLDER_PATH" 
if [[ ! -d $FOLDER_PATH ]]; then
    log_error "❌ Error: $FOLDER_PATH file not found!"
    exit 1
fi
cd "$FOLDER_PATH"
log_success "✅ Done"


echo "2: Checking out branch: $BRANCH_CHECKOUT .."
if git checkout "$BRANCH_CHECKOUT"; then
  log_success "✅ Done"
else
  log_error "❌ Error: Failed to checkout branch '$BRANCH_CHECKOUT'"
  exit 1
fi


echo "3: Pulling latest changes .."
git pull
log_success "✅ Done"


echo "4: Creating new branch.."
NEW_BRANCH="bump/ocis-latest-commit-id-$(date '+%y%m%d-%H%M%S')"
if git checkout -b "$NEW_BRANCH"; then
  log_success "✅ Done"
else
  log_error "❌ Error: Failed to create new branch '$NEW_BRANCH'"
  exit 1
fi
echo "✅ Done"


echo "5: Updating .drone.env with latest OCIS master commit .."
OCIS_COMMIT=$(git ls-remote https://github.com/owncloud/ocis.git refs/heads/${OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID} | cut -f1)
# Example: Replace a line like `ocis_commit = "old-sha"` with new one
if [[ ! -f .drone.env ]]; then
    log_error "❌ Error: .drone.env file not found!"
    exit 1
fi

if [[ "$REPO" == "reva" ]]; then
    sed -i "s/^APITESTS_COMMITID=.*/APITESTS_COMMITID=${OCIS_COMMIT}/" .drone.env
elif [[ "$REPO" == "web" ]]; then
    sed -i "s/^OCIS_COMMITID=.*/OCIS_COMMITID=${OCIS_COMMIT}/" .drone.env
else
    log_error "❌ Error: Unsupported repository '$REPO'. Only 'reva' and 'web' are supported till now."
    exit 1
fi
echo "✅ Done"


echo "6: Git adding and commiting .."
git add .drone.env
git commit -s -m "bump latest commit id"
log_success "✅ Done"


echo "7: Pushing branch .."
git push -u origin "$NEW_BRANCH"
log_success "✅ Done"


echo "8: Creating pull request"
# PR_BODY=$(cat <<EOF
# ## Description
# Bump latest ocis \`$OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID\` branch commit id.
# Part of: https://github.com/owncloud/QA/issues/$QA_ISSUE_NO
# EOF
# )

curl -L \
-X POST \
-H "Accept: application/vnd.github.v3+json" \
-H "Authorization: token $GITHUB_TOKEN" \
"https://api.github.com/repos/$OWNER/$REPO/pulls" \
-d "{
\"title\": \"[tests-only][full-ci] Bump latest ocis commit id on $BRANCH_CHECKOUT branch\",
\"body\": \"## Description\nBump latest ocis \`$OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID\` branch commit id.\n\nPart of: https://github.com/owncloud/QA/issues/$QA_ISSUE_NO\",
\"head\": \"$NEW_BRANCH\",
\"base\": \"$BRANCH_CHECKOUT\"
}"

log_success "✅ Complete"



# need to do
# handle errror in certain steps