#!/bin/bash
#Date:08-08-2023
#Author: Prakash Ashokan

IP=$1

# Define the regex pattern for a valid IP address
REGEX_IP='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'

# Check if the IP matches the regex pattern
if [[ ${IP} =~ ${REGEX_IP} ]]; then
    IFS='.' read -ra OCTETS <<< "$IP"

    if [[ ${OCTETS[0]} -le 255 && ${OCTETS[1]} -le 255 && ${OCTETS[2]} -le 255 && ${OCTETS[3]} -le 255 ]]; then
        echo "Valid IP: ${IP}"
    else
        echo "Invalid IP range"
    fi
else
    echo "Invalid IP format"
fi
