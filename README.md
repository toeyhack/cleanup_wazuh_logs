# Delete WAZUH raw logs
- How to use
  - 1. Copy cleanup_wazuh_logs.sh to /var/ossec/logs/alerts
    2. chmod +x cleanup_wazuh_logs.sh
    3. ./cleanup_wazuh_logs.sh
- Adjust Day to keep log
  - 1. nano cleanup_wazuh_logs.sh
    2. edit DAYS_TO_KEEP=
- How to run
  - 1. /cleanup_wazuh_logs.sh
    2. Confirm to delete 
       
