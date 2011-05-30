#include <QtGui/QApplication>
#include <QDeclarativeEngine>
#include "qmlapplicationviewer.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.addImportPath(QString("/opt/qtm12/imports"));
    viewer.setMainQmlFile(QLatin1String("qml/qwazer/qwazer.qml"));
    viewer.showExpanded();

    return app.exec();
}
