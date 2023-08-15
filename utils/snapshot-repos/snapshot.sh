#!/bin/sh

set -euo pipefail

# This script can be used to snapshot a select set of repositories to create
# a frozen state. For asz-warehouse, this is useful to snapshot the constantly
# changing and not archived CentOS Stream repositories to create a local frozen
# state to develop and build system images against.
#
# Script parameters:
#   ${1}: repo name
#   ${2}: repo path
#   ${3}: download directory (optional)

function print_usage()
{
  echo "Usage: $0 repo_name repo_path [download_directory]" 2>&1
}

repo_name="${1:-}"
repo_path="${2:-}"
download_dir="${3:-${repo_name}}"

if [ -z "${repo_name}" ]; then
  echo "Error: repo_name not set." >&2
  print_usage
  exit 1
fi

if [ -z "${repo_path}" ]; then
  echo "Error: repo_path not set." >&2
  print_usage
  exit 1
fi

mkdir -p "${download_dir}"
dnf reposync \
  --delete \
  --download-metadata \
  --norepopath \
  --download-path "${download_dir}" \
  --disablerepo "*" \
  --enablerepo "${repo_name}" \
  --repofrompath "${repo_name},${repo_path}"
