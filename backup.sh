#!/bin/bash

# Usage: # /home/user/Scripts/backup.sh /some/destination (as root)

EXCLUSION_LIST=`pwd -P $0`/`dirname $0`/exclude-list.txt
echo $EXCLUSION_LIST
if [ $# -lt 1 ]; then
    echo "No destination defined. Usage: $0 destination" >&2
    exit 1
elif [ $# -gt 1 ]; then
    echo "Too many arguments. Usage: $0 destination" >&2
    exit 1
elif [ ! -d "$1" ]; then
   echo "Invalid path: $1" >&2
   exit 1
elif [ ! -w "$1" ]; then
   echo "Directory not writable: $1" >&2
   exit 1
fi

case "$1" in
  "/mnt") ;;
  "/mnt/"*) ;;
  "/media") ;;
  "/media/"*) ;;
  "/run/media") ;;
  "/run/media/"*) ;;
  *) echo "Destination not allowed." >&2
     exit 1
     ;;
esac

# Rsync options (see man rsync)
# --archive: recursion + preserve everything
# --acls: ACLs conservation
# --xattrs: preserve extended attributes

START=$(date +%s)
rsync --archive --acls --xattrs --delete --verbose --exclude-from $EXCLUSION_LIST /home "$1"
FINISH=$(date +%s)
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds" | tee $1/"Backup from $(date '+%Y-%m-%d, %T, %A')"
