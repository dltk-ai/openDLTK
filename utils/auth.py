import dotenv

from utils.docker_utils import is_container_running, install_service, stop_container, uninstall_container, \
    kill_container


def enable_auth(dotenv_filepath, affected_services, service_details, root_user, base_dir):
    """
    This function is to enable authentication
    :param dotenv_filepath: file path of solution service
    :param affected_services: containers which needs to be restarted
    :param service_details: Container details
    :return: True if process successful
    """
    # update auth in required .env files
    dotenv.load_dotenv(dotenv_filepath)
    dotenv.set_key(dotenv_filepath, "AUTH_ENABLED", 'true')

    # Restart registry, base, kong
    # stop containers
    for service in affected_services:
        container_names = service_details[service].get('container_names', [])
        for container_name in container_names:
            if is_container_running(container_name):
                print(f"restarting container {container_name}")
                kill_container(container_name)

    # start containers
    for service in affected_services:
        install_service(service, service_details, root_user, base_dir)
        print("restarted container")

    return True


def disable_auth(dotenv_filepath, affected_services, ui_container_name, service_details, root_user, base_dir):
    """
    This function is to disable authentication in DLTK services
    :param affected_services: containers which needs to be restarted
    :param ui_container_name: container name of UI portal for user management
    :param service_details: container details
    :return: True, if process is successful
    """

    # update auth in required .env files
    dotenv.load_dotenv(dotenv_filepath)
    dotenv.set_key(dotenv_filepath, "AUTH_ENABLED", 'false')

    # stop all necessary containers
    # stop containers
    for service in affected_services:
        container_names = service_details[service].get('container_names', [])
        for container_name in container_names:
            if is_container_running(container_name):
                print(f"restarting container {container_name}")
                kill_container(container_name)

    # uninstall UI container - both image & container
    uninstall_container(ui_container_name)

    # Start required services
    for service in affected_services:
        if service != ui_container_name:
            install_service(service, service_details, root_user, base_dir)

    return True
