# Nokia N900 instructions #

## v0.0.3 and above ##

Simply download the deb from the site and install it using the package manager (double click in file browser).

## v0.0.2 ##
### Install ###
  1. download and extract to some directory on your N900
  1. Install dependencies
```
apt-get install libqtm-12-dec* qt4-experimental-declarative-qmlviewer
```

### Execute ###
Run
```
qmlviewer -I /opt/qtm12/imports <path to extracted>/qwazer.qml
```