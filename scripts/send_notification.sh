#!/bin/bash

# Function to send email notifications
send_email() {
    local subject="$1"
    local message="$2"
    local recipient="$3"  # Recipient email address

    # Check if msmtp or mail command is available and send email accordingly
    if command -v msmtp &> /dev/null; then
        echo -e "Subject: ${subject}\n\n${message}" | msmtp "${recipient}"
    elif command -v mail &> /dev/null; then
        echo -e "Subject: ${subject}\n\n${message}" | mail -s "${subject}" "${recipient}"
    else
        echo "ERROR: Neither msmtp nor mail command found. Please install a mail client."
        exit 1
    fi
}
