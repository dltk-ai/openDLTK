"""
This file is to setup config file
"""
import argparse
import os
from pathlib import Path
import shutil
from termcolor import colored
from dotenv import dotenv_values, set_key
import json

from utils.config_utils import override_default_config


def setup_backup_config(backup_config_path, STORAGE_PATH, latest_config_path):
    with open("sdk_version_image_info.json", 'r') as file:
        dltk_version_info = json.load(file)

    valid_versions = list(dltk_version_info.keys())
    print("Which version you want to install", valid_versions)
    version = input("Enter your input: ")
    assert version in valid_versions, "Please specify a valid version"

    if Path(backup_config_path).is_file():
        # -----If backup config file exists ------------
        # Case 1: There is ADDITIONAL parameter in latest config
        # Action-> a. Copy additional parameter to backup config file with default values
        #          b. Inform user to update them manually at backup file location

        print(f"Using backup config file from {colored(backup_config_path, 'green')}")
        latest_config = dotenv_values(latest_config_path)
        backup_config = dotenv_values(backup_config_path)

        all_key_found = True
        for key, value in latest_config.items():
            if key not in backup_config:
                print(f"Found New parameter:{key}")
                all_key_found = False
                set_key(backup_config_path, key, value)

        if not all_key_found:
            print(colored(f"Please update additional config parameters at {colored(backup_config_path, 'yellow')}", "green"))

        # update containers name based on selected version
        image_details = dltk_version_info[version]
        for image_key, image_name in image_details.items():
            set_key(backup_config_path, image_key, image_name)
        set_key(backup_config_path, 'DLTK_SDK_VERSION', version)
        set_key(backup_config_path, 'STORAGE_PATH', STORAGE_PATH)

    else:
        # Check whether there is already a backup config.env file

        # -----If backup config file doesnt exist ------
        # Action -> a. Copy File from folder to backup folder location
        #           b. Inform User to update them manually at backup file location

        print("File does not exist")
        sys_name = os.name
        backup_config_path = os.path.expanduser(backup_config_path)
        if not os.path.exists(os.path.dirname(backup_config_path)):
            if sys_name == 'posix' or sys_name == 'mac':
                os.mkdir(os.path.dirname(backup_config_path))
            elif sys_name == 'nt':
                os.mkdir(os.path.dirname(backup_config_path))

        shutil.copyfile(latest_config_path, backup_config_path)
        print(colored(f"Please update config in {backup_config_path}", "green"))
        set_key(backup_config_path, 'STORAGE_PATH', STORAGE_PATH)

    return
