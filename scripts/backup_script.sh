# scripts/backup_script.sh
#!/bin/bash

source ~/send_notification.sh  # Adjust path to your send_notification.sh file

USER_NAME=$(whoami)  
BACKUP_DIR="./backups/${USER_NAME}"
BACKUP_FILE="backup_${USER_NAME}_$(date +'%Y%m%d_%H%M%S').tar.gz"
HOME_DIR="$HOME"
LOG_FILE="./logs/backup.log"
EMAIL_RECIPIENT="vikash.1@freecharge.com"
RETENTION_DAYS=1  

send_email "Backup Start - ${USER_NAME}" "Backup process started at $(date)." "${EMAIL_RECIPIENT}"

if [ ! -d "${BACKUP_DIR}" ]; then
    mkdir -p "${BACKUP_DIR}"
    echo "Backup directory created at ${BACKUP_DIR}" >> "${LOG_FILE}"
fi

echo "Starting backup..." >> "${LOG_FILE}"
if tar -czvf "${BACKUP_DIR}/${BACKUP_FILE}" -C "${HOME_DIR}" . >> "${LOG_FILE}" 2>&1; then
    send_email "Backup Success - ${USER_NAME}" "The backup was successful. File: ${BACKUP_FILE}" "${EMAIL_RECIPIENT}"
else
    send_email "Backup Failure - ${USER_NAME}" "Backup failed at $(date). Check the log: ${LOG_FILE}" "${EMAIL_RECIPIENT}"
    exit 1
fi

echo "Cleaning up old backups..." >> "${LOG_FILE}"
old_files=$(find "${BACKUP_DIR}" -type f -name "*.tar.gz" -mtime +${RETENTION_DAYS} -exec rm -f {} \;)
if [ $? -eq 0 ]; then
    send_email "Backup Cleanup Success - ${USER_NAME}" "Old backups older than ${RETENTION_DAYS} days have been cleaned up." "${EMAIL_RECIPIENT}"
else
    send_email "Backup Cleanup Failure - ${USER_NAME}" "Failed to clean up old backups at $(date). Check the log: ${LOG_FILE}" "${EMAIL_RECIPIENT}"
    exit 1
fi

send_email "Backup Complete - ${USER_NAME}" "Backup and cleanup completed successfully at $(date)." "${EMAIL_RECIPIENT}"

