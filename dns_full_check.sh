# Enhanced script to check DNS configurations for ports, misconfigured DNS entries, and validate them for the given host

# for details usage instruction, refer README file


#!/bin/bash

# Check if the user provided a host
if [ -z "$1" ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

HOST=$1
LOG_FILE="dns_check_report_$(date '+%Y-%m-%d_%H-%M-%S').log"

# Function to check basic DNS records
check_dns() {
    local domain=$1
    echo "Checking DNS records for $domain" >> $LOG_FILE
    echo "A Records (IPv4):" >> $LOG_FILE
    dig +short $domain A >> $LOG_FILE
    echo "CNAME Records:" >> $LOG_FILE
    dig +short $domain CNAME >> $LOG_FILE
    echo "MX Records (Mail Servers):" >> $LOG_FILE
    dig +short $domain MX >> $LOG_FILE
    echo "NS Records (Name Servers):" >> $LOG_FILE
    dig +short $domain NS >> $LOG_FILE
    echo "TXT Records (SPF, DKIM, etc.):" >> $LOG_FILE
    dig +short $domain TXT >> $LOG_FILE
    echo "Checking for DNSSEC (If configured):" >> $LOG_FILE
    dig +short $domain +dnssec >> $LOG_FILE
}

# Function to check for open ports related to DNS
check_ports() {
    local domain=$1
    echo "Checking DNS related ports for $domain" >> $LOG_FILE
    nc -zv $domain 53 &>> $LOG_FILE  # Checking DNS port (53)
    nc -zv $domain 443 &>> $LOG_FILE  # Checking HTTPS port
    nc -zv $domain 80 &>> $LOG_FILE   # Checking HTTP port
}

# Function to check for misconfigured DNS
check_misconfigurations() {
    echo "Checking for misconfigurations" >> $LOG_FILE
    # Example: Check if DNS server responds to a non-existent domain
    dig nonexistingdomain.example.com +short >> $LOG_FILE
    # Check for open recursive DNS server
    dig @your.dns.server any . &>> $LOG_FILE
}

# Function to validate DNS entries
validate_dns_entries() {
    echo "Validating DNS entries" >> $LOG_FILE
    # For simplicity, we check if the DNS record returns valid IP addresses
    if [ -z "$(dig +short $HOST)" ]; then
        echo "DNS validation failed for $HOST: No valid IP found!" >> $LOG_FILE
    else
        echo "DNS validation passed for $HOST." >> $LOG_FILE
    fi
}

# Begin DNS checks
echo "DNS Check Report for $HOST - $(date)" > $LOG_FILE
check_dns $HOST
check_ports $HOST
check_misconfigurations
validate_dns_entries

echo "DNS check completed. Report saved to $LOG_FILE"
