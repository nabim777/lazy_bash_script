# Bump ocis commit latest id
## Configurable variables

`FOLDER_PATH`  _Replace with your actual folder path (Eg: FOLDER_PATH=www/web)_

`BRANCH_CHECKOUT` _Replace if you want a different base branch (Eg: BRANCH_CHECKOUT=master)_

`OWNER` _GitHub username/org (Eg: OWNER=owncloud)_

`REPO` _GitHub repo (Eg: REPO="momo-restro-list" )_

`GITHUB_TOKEN` _GitHub personal access token (Eg: GITHUB_TOKEN=gph-***********)_

`OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID` _ocis branch which need to get latest commit id (Eg: OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID=master)_

## For example;

## for web stable-12
```bash
FOLDER_PATH=~/www/web QA_ISSUE_NO=890 BRANCH_CHECKOUT=stable-12 OWNER=owncloud REPO=web OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID=stable-7.2 bash ./bump_ocis_latest_commit_id.sh
```

## for web master
```bash
FOLDER_PATH=~/www/web QA_ISSUE_NO=890 BRANCH_CHECKOUT=master OWNER=owncloud REPO=web OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID=master bash ./bump_ocis_latest_commit_id.sh
```

## for reva main
```bash
FOLDER_PATH=~/www/reva-owncloud QA_ISSUE_NO=890 BRANCH_CHECKOUT=main OWNER=owncloud REPO=reva OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID=master bash ./bump_ocis_latest_commit_id.sh
```


## for web stable-12.2
```bash
FOLDER_PATH=~/www/web QA_ISSUE_NO=890 BRANCH_CHECKOUT=stable-12.2 OWNER=owncloud REPO=web OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID=master bash ./bump_ocis_latest_commit_id.sh
```