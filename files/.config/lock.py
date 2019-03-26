import requests
import os
import urllib.request
import time
import pickle

# set variables
CONFIG_PATH = '/home/luke/.config/' # full path
PKL_FILE = CONFIG_PATH + 'wallpaper_updated.pkl'
UPDATE_VAR = 'LAST_LOCKPAPER_UPDATE'
UNSPLASH_CLIENT_ID = '6b269bca730067038c6c23e4a110112bebd997466316dc231d007f386c3bbad0'
UPDATE_INTERVAL = 3600 # once an hour
RES_W = '1920'
RES_H = '1080'
#COLLECTION = '1223439' # https://unsplash.com/collections/1242150/abstract-landscapenature
COLLECTION = '357786'

# get the current timestamp
now = int(time.time())

# check the pkl file exists
# this is used to keep track of when the last update happened
if os.path.isfile(PKL_FILE):
    persistence = open(PKL_FILE, 'rb')
    data = pickle.load(persistence)
    persistence.close()
else:
    data = {}

# if the image hasn't been updated in the last UPDATE_INTERVAL
# or it's never been run, do the magic (takes a couple of seconds)
# otherwise, don't (makes screen locking a lot quicker)
if not UPDATE_VAR in data or now - data[UPDATE_VAR] > UPDATE_INTERVAL:
    url = ''.join([
            'https://api.unsplash.com/photos/random',
        '?client_id=',
        UNSPLASH_CLIENT_ID,
        '&featured=true&w=' + RES_W + '&h=' + RES_H + '&orientation=landscape',
        '&collections=' + COLLECTION])
    result = requests.get(url).json()

    photo = result['urls']['custom']

    urllib.request.urlretrieve(photo, CONFIG_PATH + 'lock-image.jpg')

    os.system('convert ' + CONFIG_PATH + 'lock-image.jpg ' + CONFIG_PATH + 'lock-image.png')

    # persist the last update to a file
    data[UPDATE_VAR] = now
    persistence = open(PKL_FILE, 'wb')
    pickle.dump(data, persistence)
    persistence.close()

# lock the screen
os.system('i3lock -i ' + CONFIG_PATH + 'lock-image.png -t')
os.system('feh --bg-scale ' + CONFIG_PATH + 'lock-image.png')
