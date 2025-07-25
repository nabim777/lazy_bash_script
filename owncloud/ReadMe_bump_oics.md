# Bump ocis commit latest id
## Configurable variables

`FOLDER_PATH`  # Replace with your actual folder path (Eg: FOLDER_PATH=www/web)
`BRANCH_CHECKOUT` # Replace if you want a different base branch (Eg: BRANCH_CHECKOUT=master)
`OWNER` # GitHub username/org (Eg: OWNER=owncloud)
`REPO` # GitHub repo (Eg: REPO="momo-restro-list" )
`GITHUB_TOKEN` # GitHub personal access token (Eg: GITHUB_TOKEN=gph-***********)
`OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID` # ocis branch which need to get latest commit id (Eg: OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID=master)

## For example;

## for web stable-11.0

```bash
FOLDER_PATH=~/www/reva-owncloud QA_ISSUE_NO=889 BRANCH_CHECKOUT=main OWNER=owncloud REPO=reva OCIS_BRANCH_TO_GET_LATEST_COMMIT_ID=master bash ./bump_ocis_latest_commit_id.sh
```

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