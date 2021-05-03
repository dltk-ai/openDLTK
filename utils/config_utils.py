from dotenv import dotenv_values, set_key
from pathlib import Path
from termcolor import colored
import os
import filecmp
import shutil


def override_default_config(override_config_file_path):
    print(f"updating config from {override_config_file_path}")
    override_config = dotenv_values(override_config_file_path)
    print(colored("Overriding default config", "green"))

    for env_path in Path('').rglob('*.env'):
        env_config = dotenv_values(env_path)
        for key, value in override_config.items():
            if key in env_config:
                if env_config[key] != value:
                    print(f"updating {colored(key,'yellow')}:{colored(env_config[key],'green')} to {colored(key, 'yellow')}:{colored(value,'green')} in {env_path}")
                    set_key(env_path, key, value)

    sys_name = os.name
    if sys_name == 'posix' or sys_name == 'mac':
        os.system(f"sudo chown -R $USER:$USER {os.path.dirname(os.path.abspath(__file__))}")


    return
