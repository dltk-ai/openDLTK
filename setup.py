import os
import argparse
from dotenv import dotenv_values

from setup_init import setup_backup_config
from utils.uninstall_utils import dotenv_parser, delete_mapped_volumes
from utils.auth import enable_auth, disable_auth
from utils.docker_utils import is_container_running, uninstall_container, stop_container, install_service, \
    create_network, remove_images
from colorama import init
from termcolor import colored
from utils.config_utils import override_default_config

init()

installed_containers = []


def get_user_service_selection(service_id_map):
    """
    This function is to get user input on what services they want to install
    User gives input in comma separated format like 2,3 for installing services assigned to these IDs

    :param service_id_map: dictionary containing services name & assigned ID
    :return: list of ids selected by user
    """
    for id, service_name in service_id_map.items():
        print(f'\t{id}. {service_name}')

    print('\nNote: Image Classification,Object Detection and Face Analytics may take an hour to download.\n')
    # Get user selections
    selected_service_ids = input("Choose your selection : ")

    selected_service_ids = selected_service_ids.split(',')

    return selected_service_ids


def check_if_user_is_root(root_user):
    if sys_name == 'posix' or sys_name == 'mac':
        print('Using Root privileges')
        root_user = 'sudo '
    return root_user


parser = argparse.ArgumentParser()
parser.add_argument("-a", "--auth", required=False, help="python setup.py --mode=auth --auth --auth=False")
parser.add_argument("-m", "--mode", required=True, help="python setup.py --mode=init \n"
                                                        "python setup.py --mode=update_config")
parser.add_argument("-p", "--partial", action='store_true', help="to remove specific service")
parser.add_argument("-all", "--all", action='store_true', help="to uninstall service")
parser.add_argument("-r", "--remove", action='store_true', help="to remove only containers")
parser.add_argument("-pu", "--purge", action='store_true', help="to remove containers & images")

args = parser.parse_args()

if args.mode == 'uninstall':
    if not (args.mode == 'uninstall' and (args.partial is True or args.all is True)):
        parser.error("uninstall mode requires --partial or --all.")
    if args.partial:
        if not (args.remove or args.purge):
            parser.error("partial uninstall require argument --remove (to remove only containers) or"
                         " --purge (to remove both containers & images)")

if args.mode == 'auth' and not args.auth:
    parser.error("auth mode required --auth=False or --auth=True arguments")

if args.mode == 'uninstall' and args.all:
    if not (args.remove or args.purge):
        parser.error("uninstall --all require either --remove or --purge")


# Container Initialization Details
service_details = {
    'postgres': {
        'container_names': ['dltk-postgres'],
        'commands': ['docker-compose up -d dltk-postgres'],
        'dir': 'db',
        'log': 'POSTGRES INSTALLATION',
        'sleep': 30
    },
    'influxdb': {
        'container_names': ['dltk-influxdb'],
        'commands': ['docker-compose up -d dltk-influxdb'],
        'dir': 'db',
        'log': 'Influxdb INSTALLATION',
        'sleep': 1
    },
    'redis': {
        'container_names': ['dltk-redis'],
        'commands': ['docker-compose up -d dltk-redis'],
        'dir': 'db',
        'log': 'Redis INSTALLATION',
        'sleep': 1
    },
    'base': {
        'container_names': ['dltk-db-migrations', 'dltk-registry-service', 'dltk-solution-service', 'dltk-kong', 'dltk-kong-migrations-up', 'dltk-kong-migrations'],
        'commands': ['docker-compose up -d dltk-db-migrations',
                    'docker-compose up -d dltk-registry-service dltk-solution-service dltk-kong dltk-kong-migrations-up dltk-kong-migrations'],
        'dir': 'base',
        'log': 'BASE INSTALLATION',
        'sleep': 120
    },
    'ml_wrapper': {
        'container_names': ['dltk-ml-wrapper'],
        'commands': ['docker-compose up -d dltk-ml-wrapper'],
        'dir': 'ml',
        'log': 'ML INSTALLATION',
        'sleep': 100
    },
    'ml_weka': {
        'container_names': ['dltk-ml-weka'],
        'commands': ['docker-compose up -d dltk-ml-weka'],
        'dir': 'ml',
        'log': 'ML WEKA INSTALLATION',
        'sleep': 1
    },
    'ml_scikit': {
        'container_names': ['dltk-ml-scikit'],
        'commands': ['docker-compose up -d dltk-ml-scikit',
                     'docker-compose exec dltk-ml-scikit python manage.py makemigrations core',
                     'docker-compose exec dltk-ml-scikit python manage.py migrate core'],
        'dir': 'ml',
        'log': 'ML SCIKIT INSTALLATION',
        'sleep': 1
    },
    'ml_h2o': {
        'container_names': ['dltk-ml-h2o'],
        'commands': ['docker-compose up -d dltk-ml-h2o',
                     'docker-compose exec dltk-ml-h2o python manage.py makemigrations core',
                     'docker-compose exec dltk-ml-h2o python manage.py migrate core'],
        'dir': 'ml',
        'log': 'ML H2O INSTALLATION',
        'sleep': 30
    },
    'cv_wrapper': {
        'container_names': ['dltk-computer-vision'],
        'commands': ['docker-compose up -d',
                     'docker-compose exec dltk-computer-vision python manage.py makemigrations core',
                     'docker-compose exec dltk-computer-vision python manage.py migrate core'
                     ],
        'dir': 'cv/wrapper',
        'log': 'Computer Vision Base INSTALLATION',
        'sleep': 30,
        'type': 'cv'
    },
    'image_classification': {
        'container_names': ['dltk-image-classifier'],
        'commands': ['docker-compose up -d dltk-image-classifier'],
        'dir': 'cv/pretrained_detectors',
        'log': 'Pretrained Image Classification INSTALLATION',
        'sleep': 30,
        'type': 'cv'
    },
    'object_detection': {
        'container_names': ['dltk-object-detector'],
        'commands': ['docker-compose up -d dltk-object-detector'],
        'dir': 'cv/pretrained_detectors',
        'log': 'Pretrained Object Detection INSTALLATION',
        'sleep': 30,
        'type': 'cv'
    },
    'face_analytics': {
        'container_names': ['dltk-face-detection-mtcnn', 'dltk-face-detection-opencv', 'dltk-face-detection-dlib', 'dltk-face-detection-azure'],
        'commands': ['docker-compose up -d'],
        'dir': 'cv/face_analytics',
        'log': 'Face Analyzer INSTALLATION',
        'sleep': 30,
        'type': 'cv'
    },
    'nlp': {
        'container_names': ['language-service'],
        'commands': ['docker-compose up -d'],
        'dir': 'nlp/',
        'log': 'NLP INSTALLATION',
        'sleep': 30,
        'type': 'nlp'
    },
    'user-app': {
        'container_names': ['dltk-user-app'],
        'commands': ['docker exec -i dltk-postgres psql -U postgres -c "CREATE DATABASE dltk_web_db"',
                     'docker-compose up -d dltk-user-app'
                    ],
        'dir': 'web/',
        'log': 'User UI portal INSTALLATION',
        'sleep': 15,
        'type': 'ui'
    },
}

# Services Required Containers Mapping Details
services_container_map = {
    'ML Scikit': ['postgres', 'redis', 'base', 'ml_wrapper', 'ml_scikit'],
    'ML H2O': ['postgres', 'redis', 'base', 'ml_wrapper', 'ml_h2o'],
    'ML Weka': ['postgres', 'redis', 'base', 'ml_wrapper', 'ml_weka'],
    'Image Classification': ['postgres', 'redis', 'base', 'cv_wrapper', 'image_classification'],
    'Object Detection': ['postgres', 'redis', 'base', 'cv_wrapper', 'object_detection'],
    'Face Analytics': ['postgres', 'redis', 'base', 'cv_wrapper', 'face_analytics'],
    'Natural Language Processing': ['postgres', 'redis', 'base', 'nlp']
}

base_dir = os.path.abspath('')

# System Checks
sys_name = os.name
root_user = ''

if sys_name == 'posix':
    backup_config_path = '/usr/dltk-ai/config.env'
    STORAGE_PATH = "/usr/dltk-ai"

elif sys_name == 'mac':
    backup_config_path = '~/Library/Application Support/dltk-ai/config.env'
    STORAGE_PATH = '~/Library/Application Support/dltk-ai'

elif sys_name == 'nt':
    username = os.getlogin()
    backup_config_path = f'C:/Users/{username}/AppData/Local/dltk-ai/config.env'
    STORAGE_PATH = f"C:/Users/{username}/AppData/Local/dltk-ai"
else:
    raise ValueError("Unknown Operating system detected")


# Setting Up Containers & services
service_id_map = {i + 1: key for i, key in enumerate(services_container_map.keys())}
container_map = {container_name: key for key, val in service_details.items() for container_name in val['container_names']}
all_container_names = list(container_map.keys())

mode = args.mode

if mode == 'init':
    setup_backup_config(backup_config_path, STORAGE_PATH, "config.env")

elif mode == "update_config":
    override_default_config(backup_config_path)

elif mode == 'install':
    root_user = check_if_user_is_root(root_user)
    # Create network if doesn't exists
    create_network('dltk')

    print("\nPlease choose services you want to install from below list\n")
    selected_service_ids = get_user_service_selection(service_id_map)

    # Setting Up Containers & services

    for service_id in selected_service_ids:

        service_name = service_id_map[int(service_id)]

        dependent_services = services_container_map[service_name]
        terminal_size = int(os.get_terminal_size().columns)
        print(colored(f" Setting Up {service_name} ".center(terminal_size, '*'), 'yellow'))

        # Check for dependent services
        for service in dependent_services:

            container_names = service_details[service].get('container_names', None)

            all_dependent_containers_up = True

            # Check if container is not already installed & running
            for container_name in container_names:
                if container_name not in ['dltk-kong-migrations-up', 'dltk-kong-migrations', 'dltk-db-migrations']:
                    if not is_container_running(container_name):
                        all_dependent_containers_up = False
                        break

            if not all_dependent_containers_up:
                # Install dependent container
                install_service(service, service_details, root_user, base_dir)

elif mode == 'auth':
    root_user = check_if_user_is_root(root_user)
    affected_services = ['base', 'influxdb', 'user-app']
    ui_container_name = 'user-app'
    if args.auth == 'True' or args.auth == 'true':
        print("INFO: Enabling Authentication")
        enable_auth('base/.env', affected_services, service_details, root_user, base_dir)
    elif args.auth == 'False' or args.auth == 'false':
        print("INFO: Disabling Authentication")
        disable_auth('base/.env', affected_services, ui_container_name, service_details, root_user, base_dir)
    else:
        print("--auth takes only True or False parameters")

elif mode == 'uninstall' and args.partial:
    root_user = check_if_user_is_root(root_user)
    print(f"\nPlease choose services you want to {colored('RETAIN', 'red')}, other than those all services will be {colored('UNINSTALLED', 'red')}\n")
    selected_service_ids = get_user_service_selection(service_id_map)

    # Ask user which services they want to retain, remaining others can be deleted
    containers_to_retain = []
    env_details = dotenv_parser(backup_config_path)
    if env_details['AUTH_ENABLED'] == 'True' or env_details['AUTH_ENABLED'] == 'true':
        containers_to_retain.append('dltk-influxdb')
        containers_to_retain.append('dltk-user-app')

    for service_id in selected_service_ids:
        service_name = service_id_map[int(service_id)]
        dependent_services = services_container_map[service_name]
        for service in dependent_services:
            container_names = service_details[service].get('container_names', [])
            for container_name in container_names:
                containers_to_retain.append(container_name)

    containers_to_remove = list(set(all_container_names)-set(containers_to_retain))

    # find difference between all_container_names & wanted_container_names
    for container_name in containers_to_remove:
        if is_container_running(container_name):
            print(f"uninstalling {container_name}")
            if args.purge:
                uninstall_container(container_name)
            elif args.remove:
                stop_container(container_name)
            else:
                print("Please pass argument -pu or -r")

elif mode == 'uninstall' and args.all:
    root_user = check_if_user_is_root(root_user)
    # This is complete uninstallation of DLTK container
    if args.remove:
        for container_name in all_container_names:
            stop_container(container_name)

    elif args.purge:
        for container_name in all_container_names:
            uninstall_container(container_name)

        # Remove mapped Volumes
        backup_config = dotenv_values(backup_config_path)
        list_of_volumes_key_names = ['POSTGRES_DATA_VOLUME', 'REDIS_DATA_VOLUME', 'INFLUXDB_DATA_VOLUME', 'DLTK_LOCAL_STORAGE_VOLUME']
        print(f"{colored(f'Removing Mapped Volumes', 'red')}")
        delete_mapped_volumes(backup_config, list_of_volumes_key_names)

        # Remove Docker Images
        images_to_remove = [value for key, value in backup_config.items() if '_IMAGE' in key]
        print(f"{colored(f'Removing {images_to_remove} Images','red')}")
        remove_images(images_to_remove)

else:
    valid_mode = ['install', 'uninstall', 'auth', 'init', 'update_config']
    print(f"please choose a valid --mode from {valid_mode}")
