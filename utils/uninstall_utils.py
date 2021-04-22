import os
import shutil

from termcolor import colored


def delete_folder(dir_path):
    # for windows
    if os.name == "nt":
        shutil.rmtree(dir_path)

    # for linux/mac
    if os.name == "posix" or os.name == 'mac':
        os.system(f"sudo rm -rf {dir_path}")

    return


def dotenv_parser(file_path):
    with open(file_path, 'r') as fh:
        vars_dict = {}
        for line in fh.readlines():
            if not (line.startswith('#') or line.strip() == ''):
                vars_dict[line.split('=')[0]] = line.split('=')[1].strip().replace('"', '').replace("'", '')
    return vars_dict


def delete_mapped_volumes(config, list_of_volumes_key_names):
    """
    This function uses config.env & list of volume IDs to delete them
    """

    print(colored("Deleting Mapped volumes", "red"))

    for volume_key_name in list_of_volumes_key_names:
        volume_path = config.get(volume_key_name)
        if os.path.exists(volume_path):
            delete_folder(volume_path)
    return
