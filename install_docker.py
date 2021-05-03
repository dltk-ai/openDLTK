import os
from shutil import which


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



