#!/bin/bash

# Show log messages
VERBOSE=true

# Vars
ROOT_DIR="/home/" # Absolute path to this script
LOG_FILES_EXPIRATION=30
SESSION_FILES_EXPIRATION=7
CACHE_IMAGES_EXPIRATION=180
LOG_VISITOR_EXPIRATION_DAYS=7

# Function declarations
function usage() 
{
    echo
    echo "Usage: $0"
    echo

    exit 1
}

function backup_logs()
{
    show_log "Starting the logs backup process..."
    name=$(date '+%d-%m-%Y')
    fullname="logs_$name.tar.gz"
    cd $1/var/log
    tar -zcf $fullname .
    show_log "$fullname successfully created on $1/var/log"
    show_log "Logs backup process finished."
}

function clean_folders()
{
    show_log "Starting the clean folders process..."
    find $1/var/log/* ! -name '*.tar.gz' -type f -exec rm {} \;
    show_log "Log files cleaned."
    find $1/var/report/* -mtime +$LOG_FILES_EXPIRATION -exec rm {} \;
    show_log "Cleaned report files with modification date greater than $LOG_FILES_EXPIRATION days."
    find $1/var/log/* -mtime +$LOG_FILES_EXPIRATION -exec rm {} \;
    show_log "Cleaned logs and .tar.gz files with modification date greater than $LOG_FILES_EXPIRATION days."
    find $1/var/session -name 'sess_*' -type f -mtime +$SESSION_FILES_EXPIRATION -exec rm {} \;
    show_log "Cleaned session files with modification date greater than $SESSION_FILES_EXPIRATION days."
    show_log "Clean folders process finished."
}

function clean_cache_images()
{
    show_log "Starting the clean cache images process..."
    find $1/media/catalog/product/cache/* -type f -mtime +$CACHE_IMAGES_EXPIRATION -exec rm -f {} \;
    show_log "Cleaned cache images with modification date greater than $CACHE_IMAGES_EXPIRATION days."
    show_log "Clean cache images process finished."
}

function clean_visitor_logs()
{
    show_log "Cleaning visitor logs..."
    php shell/log.php clean --days $LOG_VISITOR_EXPIRATION_DAYS
    show_log "Cleaned visitor logs successfully."
}

function clean()
{
    show_log "-----------------------------------------------------------------------"
    show_log "Magento installation found on: $1"    
    backup_logs $1
    clean_folders $1
    clean_visitor_logs $1
    clean_cache_images $1 # Maybe the customer does not want to do this process
    show_log "-----------------------------------------------------------------------"
}

function show_log()
{
    if [ "$VERBOSE" = true ]; then
        echo $1
    fi    
}

# For multiple Magento installations
for dir in *;
do
    # If Magento is found
    if [ -f "$ROOT_DIR$dir/public_html/app/Mage.php" ]; then    
        clean "$ROOT_DIR$dir/public_html"
    fi
done

# For a single Magento installation

# If Magento is found
#if [ -f "$ROOT_DIRapp/Mage.php" ]; then    
#    clean "$ROOT_DIR"
#fi
