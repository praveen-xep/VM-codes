#!/bin/bash
# Install the cron package
sudo dnf install -y cronie

# Start the service
sudo systemctl start crond

# Enable it so it starts automatically on every reboot
sudo systemctl enable crond

# 1. Define the full path to the script you want to run
# Use $(pwd) if the target script is in the same folder
TARGET_SCRIPT="/home/ec2-user/my_worker_script.sh"
CRON_SCHEDULE="0 * * * *" # Every hour

# 2. Ensure the target script is actually executable
chmod +x "$TARGET_SCRIPT"

# 3. Define the full cron line
CRON_JOB="$CRON_SCHEDULE $TARGET_SCRIPT >> /home/ec2-user/cron_output.log 2>&1"

# 4. Check if the job already exists to avoid duplicates
(crontab -l 2>/dev/null | grep -F "$TARGET_SCRIPT") >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Check: Cron job already exists. Skipping."
else
    # 5. Append the new job to the existing crontab
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Success: Cron job added successfully."
fi