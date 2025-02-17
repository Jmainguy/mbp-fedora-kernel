#!/bin/bash

set -eu -o pipefail

# set -x

# APPLE_BCE_REPOSITORY=https://github.com/kekrby/apple-bce.git
# APPLE_IBRIDGE_REPOSITORY=https://github.com/Redecorating/apple-ib-drv.git

APPLE_SMC_DRIVER_GIT_URL=https://github.com/t2linux/linux-t2-patches
APPLE_SMC_REPO_NAME=linux-t2-patches
APPLE_SMC_DRIVER_BRANCH_NAME=main
APPLE_SMC_DRIVER_COMMIT_HASH=d0e70c9396db0c97b47155a649838bb7ba82a690

TMP_DIR=/tmp/tmp_dir
REPO_PWD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PATCHES_DIR=${PATCHES_DIR:-$REPO_PWD/patches}

rm -rf "${PATCHES_DIR}"
mkdir -p "${PATCHES_DIR}"

mkdir -p "${TMP_DIR}"
cd "${TMP_DIR}" || exit

### AppleSMC and BT aunali fixes
git clone --single-branch --branch ${APPLE_SMC_DRIVER_BRANCH_NAME} ${APPLE_SMC_DRIVER_GIT_URL}
cd "${APPLE_SMC_REPO_NAME}" || exit
git checkout ${APPLE_SMC_DRIVER_COMMIT_HASH}
cd ..
while IFS= read -r file; do
  echo "adding ${file}"
  cp -rfv "${file}" "${PATCHES_DIR}"/"${file##*/}"
done < <(find "${APPLE_SMC_REPO_NAME}" -type f -name "*.patch" | sort)

rm -rf "${TMP_DIR}"
