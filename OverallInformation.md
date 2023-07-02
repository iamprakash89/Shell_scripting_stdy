#!/bin/bash

# Email notification settings
TO_ADDRESS="your_email@example.com"
FROM_ADDRESS="sender_email@example.com"
SUBJECT="System Threshold Alert"

# Thresholds
CPU_THRESHOLD=80
RAM_THRESHOLD=80
LOAD_THRESHOLD=2

# Get current CPU usage
CPU_USAGE=$(mpstat 1 1 | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }')

# Get current RAM usage
RAM_USAGE=$(free | awk '/Mem:/ { print ($3/$2) * 100 }')

# Get current load average
LOAD_AVERAGE=$(uptime | awk -F'load average:' '{ print $2 }' | awk -F',' '{ print $1 }')

# Check CPU usage
if (( $(echo "$CPU_USAGE >= $CPU_THRESHOLD" | bc -l) )); then
    MESSAGE+="High CPU usage: $CPU_USAGE%\n"
fi

# Check RAM usage
if (( $(echo "$RAM_USAGE >= $RAM_THRESHOLD" | bc -l) )); then
    MESSAGE+="High RAM usage: $RAM_USAGE%\n"
fi

# Check load average
if (( $(echo "$LOAD_AVERAGE >= $LOAD_THRESHOLD" | bc -l) )); then
    MESSAGE+="High load average: $LOAD_AVERAGE\n"
fi

# Send email if thresholds are crossed
if [ -n "$MESSAGE" ]; then
    echo -e "$MESSAGE" | mailx -s "$SUBJECT" -r "$FROM_ADDRESS" "$TO_ADDRESS"
fi


#!/bin/bash

# Email notification settings
TO_ADDRESS="your_email@example.com"
FROM_ADDRESS="sender_email@example.com"
SUBJECT="Website Status Alert"

# Website URL to monitor
WEBSITE_URL="https://example.com"

# Perform a GET request and check the HTTP status code
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$WEBSITE_URL")

# Send email if HTTP status code is not 200 OK
if [ "$HTTP_STATUS" != "200" ]; then
    MESSAGE="The website $WEBSITE_URL returned an HTTP status code of $HTTP_STATUS."
    echo "$MESSAGE" | mailx -s "$SUBJECT" -r "$FROM_ADDRESS" "$TO_ADDRESS"
fi



#!/bin/bash

# Email notification settings
TO_ADDRESS="your_email@example.com"
FROM_ADDRESS="sender_email@example.com"
SUBJECT="Service Status Alert"

# Service name to check
SERVICE_NAME="your_service_name"

# Check service status
SERVICE_STATUS=$(systemctl is-active $SERVICE_NAME)

# Send email if service is not running
if [ "$SERVICE_STATUS" != "active" ]; then
    echo "Service $SERVICE_NAME is not running" | mailx -s "$SUBJECT" -r "$FROM_ADDRESS" "$TO_ADDRESS"
fi



#!/bin/bash

# Email notification settings
TO_ADDRESS="your_email@example.com"
FROM_ADDRESS="sender_email@example.com"
SUBJECT="Error Log Messages"

# Log file path
LOG_FILE="/path/to/log/file.log"

# Get today's date in the format YYYY-MM-DD
TODAY=$(date +"%Y-%m-%d")

# Search for error messages in the log file for today's date
ERROR_MESSAGES=$(grep "$TODAY" "$LOG_FILE" | grep "ERROR")

# Send email with error messages if any are found
if [ -n "$ERROR_MESSAGES" ]; then
    echo "$ERROR_MESSAGES" | mailx -s "$SUBJECT" -r "$FROM_ADDRESS" "$TO_ADDRESS"
fi


#!/bin/bash

# Email notification settings
TO_ADDRESS="your_email@example.com"
FROM_ADDRESS="sender_email@example.com"
SUBJECT="File System Usage Alert"

# File system to monitor
FILE_SYSTEM="/dev/sda1"

# Threshold for file system usage (in percentage)
THRESHOLD=90

# Get file system usage in percentage
FILE_SYSTEM_USAGE=$(df -h | grep "$FILE_SYSTEM" | awk '{print $5}' | sed 's/%//')

# Check file system usage and send email if threshold is exceeded
if (( FILE_SYSTEM_USAGE > THRESHOLD )); then
    MESSAGE="File system usage for $FILE_SYSTEM is $FILE_SYSTEM_USAGE% which exceeds the threshold of $THRESHOLD%."
    echo "$MESSAGE" | mailx -s "$SUBJECT" -r "$FROM_ADDRESS" "$TO_ADDRESS"
fi


#!/bin/bash

# Directory to check
DIRECTORY="/path/to/directory"

# Check if the directory exists
if [ -d "$DIRECTORY" ]; then
    # Print the files inside the directory
    ls "$DIRECTORY"
else
    # Display a message if the directory doesn't exist
    echo "No directory exists at: $DIRECTORY"
fi



#!/bin/bash

# Update and upgrade packages on Ubuntu
if [[ -f /etc/lsb-release ]]; then
    echo "Updating packages on Ubuntu..."
    sudo apt update
    sudo apt upgrade -y

# Update and upgrade packages on CentOS
elif [[ -f /etc/centos-release ]]; then
    echo "Updating packages on CentOS..."
    sudo yum update -y
    sudo yum upgrade -y

# Update and upgrade packages on Debian
elif [[ -f /etc/debian_version ]]; then
    echo "Updating packages on Debian..."
    sudo apt update
    sudo apt upgrade -y

# Unsupported distribution
else
    echo "Unsupported distribution. Package update and upgrade cannot be performed."
    exit 1
fi



#!/bin/bash

# File to read
FILE="path/to/file.txt"

# Read the file and count occurrences of unique words
WORD_COUNTS=$(cat "$FILE" | tr -cs '[:alnum:]' '[\n*]' | sort | uniq -c)

# Print unique words and their counts
echo "$WORD_COUNTS"
