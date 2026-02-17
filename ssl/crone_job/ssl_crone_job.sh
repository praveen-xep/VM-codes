#!/bin/bash
# Install the cron package
sudo dnf install -y cronie

# Start the service
sudo systemctl start crond

# Enable it so it starts automatically on every reboot
sudo systemctl enable crond

#!/bin/bash

# 1. Automatically get the ABSOLUTE path of this folder
# This ensures cron knows exactly where to find the script
DIR="$(pwd)"
TARGET_SCRIPT="$DIR/renewer.sh"
LOG_FILE="$DIR/renewer.log"

# 2. Define the schedule (e.g., Every hour at minute 0)
CRON_SCHEDULE="0 9 * * *"

# 3. Ensure the worker script is executable
chmod +x "$TARGET_SCRIPT"

# 4. Define the exact line we want in the crontab
# We use >> to append logs so you can see history if it fails
CRON_JOB="$CRON_SCHEDULE $TARGET_SCRIPT >> $LOG_FILE 2>&1"

# 5. Check if THIS specific script is already in the crontab
if crontab -l 2>/dev/null | grep -Fq "$TARGET_SCRIPT"; then
    echo "------------------------------------------------"
    echo "STATUS: Cron job already exists. No changes made."
    echo "------------------------------------------------"
else
    # 6. Add the job: (List existing jobs + add the new one) | write back to crontab
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "------------------------------------------------"
    echo "SUCCESS: Cron job added!"
    echo "Path: $TARGET_SCRIPT"
    echo "Log:  $LOG_FILE"
    echo "------------------------------------------------"
fi