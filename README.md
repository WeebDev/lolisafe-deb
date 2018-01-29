# lolisafe-deb
Debian Repository for the lolisafe PPA.

## Installing:
```bash
sudo add-apt-repository ppa:weebdev/ppa
sudo apt-get update
sudo apt install lolisafe
```

## Starting/Stopping:
In this instance, lolisafe is controlled via a service file. Starting is as easy as `sudo service lolisafe start` and stopping is the same `sudo service lolisafe stop`. 

The service runs under the user `lolisafe` so if something happens, you can always do `sudo killall -u lolisafe`.

The logfile for any output (good or bad) will be in `/var/log/lolisafe.log`

## Files and their locations:
This debian package accesses three locations, as show below:

Note: You will see duplicate of files in places, such as `/usr/share/lolisafe/config.js`. This is a symlink! To edit the config you must go to `/etc/lolisafe/config.js`

### `/usr/share/lolisafe/`
This is the main location for the files, including the main script `lolisafe.js`, `node_modules/` etc.
### `/var/www/lolisafe/`
This is the location for all file that are access via the web interafce. This include the actual images themselves as well as the various icons and default images.
### `/etc/lolisafe/`
This is the location for all configuration files for lolisafe. For configuration help, look at the lolisafe README, as it is already explained there.
