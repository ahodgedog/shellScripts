#!/bin/bash

# Check if a log file was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

logfile=$1
tempfile=$(mktemp)

# Function to anonymize IPs, emails, usernames, and hostnames
anonymize_log() {
    # Anonymize IPv4 addresses
    sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/[REDACTED_IP]/g' |
    # Anonymize email addresses
    sed -E 's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/[REDACTED_EMAIL]/g' |
    # Anonymize user names and hostnames (very basic; might need adjustments)
    sed -E 's/\b([a-zA-Z0-9_-]{3,})\b/[REDACTED_USER_OR_HOST]/g'
}

# Anonymize the log file and output to a temporary file
cat "$logfile" | anonymize_log > "$tempfile"

# Optionally, move the temporary file back to the original log file
# mv "$tempfile" "$logfile"

# For safety, we're just showing the path to the sanitized log
echo "Sanitized log created at: $tempfile"
echo "Review the sanitized log, and if it's acceptable, you can replace the original log file with it."

# Clean up if you uncomment the mv command above
# rm "$tempfile"
