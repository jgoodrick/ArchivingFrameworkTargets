#!/bin/sh

# Fix errors:
# conflicting deployment targets, both 'MACOSX_DEPLOYMENT_TARGET' and 'IPHONEOS_DEPLOYMENT_TARGET' are present in environment
unset MACOSX_DEPLOYMENT_TARGET
# conflicting deployment targets, both 'IPHONEOS_DEPLOYMENT_TARGET' and 'TVOS_DEPLOYMENT_TARGET' are present in environment
unset TVOS_DEPLOYMENT_TARGET
# conflicting deployment targets, both 'IPHONEOS_DEPLOYMENT_TARGET' and 'WATCHOS_DEPLOYMENT_TARGET' are present in environment
unset WATCHOS_DEPLOYMENT_TARGET
# conflicting deployment targets, both 'IPHONEOS_DEPLOYMENT_TARGET' and 'DRIVERKIT_DEPLOYMENT_TARGET' are present in environment
unset DRIVERKIT_DEPLOYMENT_TARGET


# Custom error handling function
function handle_error {
    local exit_status=$?
    local error_command="${BASH_COMMAND}"

    echo "Error occurred in command: ${error_command}"
    echo "Exit status: ${exit_status}"

    SUBTITLE="Due to error in: ${error_command}…"
    osascript -e 'on run argv' -e 'display notification (item 1 of argv) with title "Failed to distribute XCFramework"' -e 'end run' "$SUBTITLE"

    # Exit the script with a non-zero status to indicate an error
    exit 1
}

# Set up the error handler with 'trap'
trap 'handle_error' ERR

# Set bash script to exit immediately if any commands fail
set -e

# Check if the PRODUCT_NAME environment variable is set
if [ -z "$PRODUCT_NAME" ]; then
    # If PRODUCT_NAME is not set, provide a fallback value
    PRODUCT_NAME="XCFrameworkForArchive"
fi
ORIGINAL_DIR=$(pwd)

SANITIZED_FULL_VERSION="1"
OUTPUT_FILENAME="${PRODUCT_NAME}-${SANITIZED_FULL_VERSION}"

REPO_DIR=$(readlink -f "$ORIGINAL_DIR/../..")
REL_EXPORT_PATH="${REPO_DIR}/../Artifacts/XCFrameworks/$PRODUCT_NAME/$SANITIZED_FULL_VERSION"
WORKSPACE_PATH="${REPO_DIR}/Workspace/ArchivingXCFrameworks.xcworkspace"

# Remove build directory for this version if it exists from previous run
echo "Removing build directory for this version if it exists from previous run"
rm -rf ${REL_EXPORT_PATH}

mkdir -p "$REL_EXPORT_PATH"

EXPORT_PATH=$(readlink -f "${REL_EXPORT_PATH}")

function archivePathSimulator {
  echo ${EXPORT_PATH}/archives/"${1}-SIMULATOR"
}

# Archive takes 3 params
#
# 1st == SCHEME
# 2nd == destination
# 3rd == archivePath
function makeArchives {
    echo
    echo "▸ Started archiving the scheme: ${1} for destination: ${2} at archive path: ${3}.xcarchive"
    echo
    xcodebuild archive \
        -workspace ${WORKSPACE_PATH} \
        -scheme ${1} \
        -destination "${2}" \
        -archivePath "${3}" \
        -xcconfig ${PRODUCT_NAME}.xcconfig \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        SKIP_INSTALL=NO
}

# Builds archive for iOS simulator & device
function buildArchives {
  SCHEME=${1}

  makeArchives $SCHEME "generic/platform=iOS Simulator" $(archivePathSimulator $SCHEME)
}

LOG_FILE="$EXPORT_PATH/script.log"

# Xcode doesn't show run script errors in build log.
exec > "$LOG_FILE" 2>&1

echo "Log now writing to $LOG_FILE"

open -a "Console" "$LOG_FILE"

buildArchives ${PRODUCT_NAME}



# Open the folder that was created, which also signals completion.
open "$EXPORT_PATH"
