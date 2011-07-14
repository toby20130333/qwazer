# Add more folders to ship with the application, here

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

QT+= declarative
symbian:TARGET.UID3 = 0xEB2035FC

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp


OTHER_FILES += \
    qwazer.desktop \
    qwazer.svg \
    qwazer.png \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qtc_packaging/debian_fremantle/rules \
    qtc_packaging/debian_fremantle/README \
    qtc_packaging/debian_fremantle/copyright \
    qtc_packaging/debian_fremantle/control \
    qtc_packaging/debian_fremantle/compat \
    qtc_packaging/debian_fremantle/changelog \
    qml/GPSProvider.qml \
    qml/SettingsPage.qml \
    qml/AddressResultsPage.qml \
    qml/BusyPage.qml \
    qml/qwazer/CourseResultsListModel.qml \
    qml/SearchAddressPage.qml \
    qml/MainPage.qml \
    qml/main.qml \
    qml/qwazer/QwazerSettings.qml \
    qml/qwazer/QwazerMap.qml \
    qml/qwazer/PathSelectionPage.qml \
    qml/qwazer/InstructionsControl.qml \
    qml/qwazer/Translator.qml \
    qml/qwazer/search_qml/SelectedAddressDetailsPage.qml \
    qml/qwazer/search_qml/FindResultsModel.qml \
    qml/qwazer/js/WazeEmbeddedMap.jsh \
    qml/qwazer/js/translator.js \
    qml/qwazer/js/Storage.js \
    qml/qwazer/js/OpenLayers.jsh \
    qml/qwazer/js/MapLogic.js \
    qml/qwazer/js/jquery.jsh \
    qml/qwazer/js/WazeEmbeddedMap.jsh \
    qml/qwazer/js/translator.js \
    qml/qwazer/js/Storage.js \
    qml/qwazer/js/OpenLayers.jsh \
    qml/qwazer/js/jquery.jsh \
    qml/qwazer/js/translations/qwazer.he.js

RESOURCES += \
    res.qrc

# Please do not modify the following two lines. Required for deployment.
include(deployment.pri)
qtcAddDeployment()

# enable booster
CONFIG += qdeclarative-boostable
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic
