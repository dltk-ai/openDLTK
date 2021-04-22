import docker
import os
from time import sleep

from termcolor import colored

client = docker.from_env()


def is_container_running(container_name):
    container_ids = client.containers.list(filters={'name': container_name, 'status': 'running'})
    if len(container_ids) > 0:
        return True
    else:
        return False


def install_service(container_name, containers_details, root_user, base_dir):
    container_detail = containers_details[container_name]
    terminal_size = int(os.get_terminal_size().columns)
    print(f"\n{colored(container_detail['log'].center(terminal_size, '-'), 'blue')}\n")
    os.chdir(container_detail['dir'])
    for command in container_detail['commands']:
        os.system(f"{root_user}{command}")
    os.chdir(base_dir)
    print(f'Setting up {container_name}...', end=' ')
    sleep(container_detail['sleep'])
    print(colored('done', 'green'))

    return


def stop_container(container_name):
    try:
        # get list of running docker images
        container_ids = client.containers.list(filters={'name': container_name})
        if len(container_ids) > 0:
            container = container_ids[0]
            # stop containers
            container.stop()
            # remove container
            container.remove(force=True)
        return True
    except Exception as e:
        print(f"Unable to stop container due to {e}")
        return False


def uninstall_container(container_name):
    # get list of running docker images
    container_ids = client.containers.list(filters={'name': container_name})
    if len(container_ids) > 0:
        container = container_ids[0]
        associated_image = container.image.id
        # stop containers
        container.kill()
        # Remove Containers
        container.remove(force=True)
        # Wait for container to be down
        try:
            print(f'Stopping {container_name} container...', end=' ')
            sleep(30)
            # Remove associated image
            client.images.remove(associated_image, force=True)
            print(colored('done', 'green'))
        except:
            try:
                sleep(30)
                client.images.remove(associated_image, force=True)
                print(colored('done', 'green'))
            finally:
                print(colored(f"Unable to remove {container_name} container, please remove that manually using 'docker rmi {associated_image}' command", 'red'))

    return


def create_network(network_name):
    print(colored("Creating DLTK network", "yellow"))
    networks_name = [network.name for network in client.networks.list()]
    if network_name in networks_name:
        return True
    else:
        print(f"Creating '{network_name}' network")
        client.networks.create(network_name, driver="bridge")
    return True


def kill_container(container_name):
    # get list of running docker images
    container_ids = client.containers.list(filters={'name': container_name})
    if len(container_ids) > 0:
        container = container_ids[0]
        # kill containers
        container.kill()
    return True


def remove_images(all_dltk_image_names):
    for image in client.images.list():
        image_tags = image.tags
        if len(image_tags) > 0:
            if image_tags[0] in all_dltk_image_names:
                try:
                    client.images.remove(image_tags[0])
                finally:
                    print(f"WARNING: Unable to remove {image_tags[0]}")
    return
