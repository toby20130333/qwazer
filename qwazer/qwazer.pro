# MeeGo
exists($$QMAKE_INCDIR_QT"/../qmsystem2/qmkeys.h"){
    DEFINES += Q_WS_MAEMO_6 MEEGO_EDITION_HARMATTAN
} else:maemo5 {
    DEFINES += Q_WS_MAEMO_5
}

# Add more folders to ship with the application, here
folder_01.source = qml/qwazer
folder_01.target = qml

contains(DEFINES, Q_WS_MAEMO_6) {
    folder_02.source = qml/meego
    folder_02.target = qml
    desktop_file = qwazer_harmattan.desktop
    DEFINES += "MAIN_QML=/opt/qwazer/qml/meego/main.qml"
} else:maemo5 {
    folder_02.source = qml/maemo
    folder_02.target = qml
    desktop_file = qwazer_fremantle.desktop
    DEFINES += "MAIN_QML=/opt/qwazer/qml/maemo/main.qml"
} else {
    folder_02.source = qml/maemo
    folder_02.target = qml
    desktop_file = qwazer_fremantle.desktop
    DEFINES += "MAIN_QML=qml/maemo/main.qml"
    CONFIG += mobility
    MOBILITY += location multimedia
}


DEPLOYMENTFOLDERS = folder_01 folder_02

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

QT+= core gui declarative
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
#CONFIG += mobility
#MOBILITY += location multimedia

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    ${desktop_file} \
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
    qwazer_s.png \
    qwazer_m.png \
    qwazer_icon.odg

# Please do not modify the following two lines. Required for deployment.
include(deployment.pri)
qtcAddDeployment()

# enable booster
CONFIG += qdeclarative-boostable
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic





