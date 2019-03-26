from shutil import copy
from os.path import expanduser, dirname, abspath, isdir, isfile
from os import mkdir, listdir
from distutils.dir_util import copy_tree

src = "/".join([
    dirname(abspath(__file__)),
    "files"
])
files = listdir(src)

print(files)

home_dir = expanduser("~")

for file in files:
    dest_path = "/".join([
        home_dir,
        file
    ])

    src_path = "/".join([
        src,
        file
    ])

    dest_parts = dest_path.split("/")[1:-1]
    
    current_path = ""
    for part in dest_parts:
        current_path = "/".join([current_path, part])
        if not isdir(current_path) and not isfile(current_path):
            mkdir(current_path)

    if isfile(src_path):
        print(src_path + " is file")
        copy(src_path, dest_path)
    elif isdir(src_path):
        print(src_path + " is dir")
        copy_tree(src_path, dest_path)

