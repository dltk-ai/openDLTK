
from shutil import which


def install_docker(root_user):
    if os.name == "posix":
        print("Installing Docker")
        install_commands = [f'{root_user} apt-get update',
                            'curl -fsSL https://get.docker.com -o get-docker.sh',
                            'sh get-docker.sh',
                            f'{root_user} curl -L "https://github.com/docker/compose/releases/download/1.28.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose',
                            f'{root_user} chmod +x /usr/local/bin/docker-compose']
        for command in install_commands:
            os.system(command)

        print("Installed docker images")

    elif os.name == "nt":
        print("For installing docker on windows Home machine please refer to https://docs.docker.com/docker-for-windows/install-windows-home/")
        print("For installing docker on windows Pro, Enterprise please refer to https://docs.docker.com/docker-for-windows/install/")

    return


def is_docker_present(name):
    """Check whether `name` is on PATH and marked as executable."""
    print(which(name))
    return which(name) is not None


sys_name = os.name
root_user = ''
if sys_name == 'posix' or sys_name == 'mac':
    print('Linux Distribution detected')
    print('Are you a root User?[Y/N]:')
    root = input()
    if root == 'Y' or root == 'y':
        root_user = 'sudo '
elif sys_name == 'nt':
    print('Windows OS detected')



if is_docker_present('docker'):
    print('Docker is installed and is present on executable path in this environment')
else:
    install_docker(root_user)
