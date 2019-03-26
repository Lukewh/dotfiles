from shutil import copy
from os.path import expanduser, dirname, abspath, isdir, isfile
from os import mkdir
from distutils.dir_util import copy_tree

files = [
    ".zshrc",
    ".vimrc",
    ".profile",
    ".gitignore",
    ".gitconfig",
    ".config/lock.py",
    ".config/lock-image.jpg",
    ".config/lock-image.png",
    "bin/=",
    "bin/battery.sh",
    "bin/emoj",
    "bin/youtube.sh"
]

folders = [
    ".vim",
    ".emacs.d",
    ".config/i3",
    ".config/i3blocks",
    ".config/i3status",
    ".config/rofi"
]

for file in files:
    src_path = "/".join([
        expanduser("~"),
        file
    ])

    dest_path = "/".join([
        dirname(abspath(__file__)),
        "files",
        file
    ])
    

    dest_parts = dest_path.split("/")[1:-1]
    
    current_path = ""
    for part in dest_parts:
        current_path = "/".join([current_path, part])
        if not isdir(current_path) and not isfile(current_path):
            mkdir(current_path)

    copy(src_path, dest_path)

for folder in folders:
    src_path = "/".join([
        expanduser("~"),
        folder
    ])

    dest_path = "/".join([
        dirname(abspath(__file__)),
        "files",
        folder
    ])

    copy_tree(src_path, dest_path)

