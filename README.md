# Linuxhost-DNS-scanner

enhanced script to check DNS configurations for ports, misconfigured DNS entries, and validate them for the given host


Instructions:


1. Save the script as dns_full_check.sh.

2. Make it executable: chmod +x dns_full_check.sh.

3. Run the script by providing a hostname, e.g., ./dns_full_check.sh example.com.


Script Breakdown:

a. DNS Checks: It checks A, CNAME, MX, NS, and TXT records for a domain.

b. Port Checks: It checks for open DNS ports and other common ports like HTTP and HTTPS.

c. Misconfiguration Check: Detects potential issues like open recursive DNS servers or non-existent domain responses.

d. DNS Validation: Validates DNS records for the given host to ensure proper resolution.

The results will be logged in a file with a timestamp.
