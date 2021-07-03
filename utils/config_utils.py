from dotenv import dotenv_values, set_key
from pathlib import Path
from termcolor import colored
import os
import filecmp
import shutil


def override_default_config(override_config_file_path, ignore_envs=[]):
    print(f"updating default config from {override_config_file_path}")
    override_config = dotenv_values(override_config_file_path)

    for env_path in Path('').rglob('*.env'):

        if str(env_path) not in ignore_envs:
            env_config = dotenv_values(env_path)
            difference_found = False
            for key, value in override_config.items():
                if key in env_config:
                    if env_config[key] != value:
                        if not difference_found:
                            print('\n%-50s%-50s%-20s' % (f"({colored(env_path, 'blue')}) keys", "Old Value", "Updated Value"), f"\n{'-' * 140}")
                            difference_found = True

                        print('%-50s%-50s%-50s' % (colored(key, 'yellow'), colored(env_config[key], 'white'), colored(value, 'green')))
                        set_key(env_path, key, value)

    sys_name = os.name
    if sys_name == 'posix' or sys_name == 'mac':
        os.system(f"sudo chown -R $USER:$USER {os.path.dirname(os.path.abspath(__file__))}")

    # Note:  Update GCS json file
    gcs_file_path = override_config.get('GCP_SERVICE_ACCOUNT_FILE_PATH', None)
    dst_gcs_file_path = "base/solution-config/dltk-ai.json"
    if gcs_file_path is not None and os.path.exists(gcs_file_path):
        shutil.copyfile(gcs_file_path, dst_gcs_file_path)
        
    return
