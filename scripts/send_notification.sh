# scripts/send_notification.sh
#!/bin/bash

send_email() {
    local subject="$1"
    local message="$2"
    local recipient="$3"  # Recipient email address

    if command -v msmtp &> /dev/null; then
        echo -e "Subject: ${subject}\n\n${message}" | msmtp "${recipient}"
    elif command -v mail &> /dev/null; then
        echo -e "Subject: ${subject}\n\n${message}" | mail -s "${subject}" "${recipient}"
    else
        echo "ERROR: Neither msmtp nor mail command found. Please install a mail client."
        exit 1
    fi
}

