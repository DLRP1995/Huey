import os
import logging
import subprocess
from system_checks import check_error

logger = logging.getLogger(__name__)

def backup_config():
    logger.info("Backing up Configurations...")
    backup_dir = os.path.expanduser("~/Backup/repo/config")
    os.makedirs(backup_dir, exist_ok=True)
    backup = subprocess.run(['cp', '-r', os.path.expanduser("~/Source/repo/config"), backup_dir], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    check_error(backup, "Backup Configurations")

def restore_config():
    logger.info("Restoring Configurations...")
    restore = subprocess.run(['cp', '-r', os.path.expanduser("~/Backup/repo/config"), os.path.expanduser("~/Source/repo/config")], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    check_error(restore, "Restore Configurations")