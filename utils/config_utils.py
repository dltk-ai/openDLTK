from dotenv import dotenv_values, set_key
from pathlib import Path
from termcolor import colored
import os
import shutil
import json


def override_default_config(override_config_file_path):
    print(f"updating config from {override_config_file_path}")
    override_config = dotenv_values(override_config_file_path)
    print(colored("Overriding default config", "green"))

    with open("sdk_version_image_info.json", "r") as f:
        docker_image_tags = json.load(f)

    for env_path in Path('').rglob('*.env'):
        env_config = dotenv_values(env_path)

        # update all env variables with backup_config.env file
        for key, value in override_config.items():
            if key in env_config:
                if env_config[key] != value:
                    print(f"updating {colored(key,'yellow')}:{colored(env_config[key],'green')} to {colored(key, 'yellow')}:{colored(value,'green')} in {env_path}")
                    set_key(env_path, key, value)

        # update image name using sdk_version_image_info.json
        for image_id, image_name in docker_image_tags[override_config["DLTK_SDK_VERSION"]].items():
            if image_id in env_config:
                set_key(env_path, image_id, image_name)

    sys_name = os.name
    if sys_name == 'posix' or sys_name == 'mac':
        os.system(f"sudo chown -R $USER:$USER {os.path.dirname(os.path.abspath(__file__))}")

    # Note:  Update GCS json file
    gcs_file_path = override_config.get('GCP_SERVICE_ACCOUNT_FILE_PATH', None)
    dst_gcs_file_path = "base/solution-config/dltk-ai.json"
    if gcs_file_path is not None and os.path.exists(gcs_file_path):
        shutil.copyfile(gcs_file_path, dst_gcs_file_path)
        
    return
