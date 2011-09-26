#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"

#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#define MAIN_QML_STR TOSTRING(MAIN_QML)

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QmlApplicationViewer viewer;

    QObject::connect(viewer.engine(), SIGNAL(quit()),
                        &app, SLOT(quit()));

#if defined(Q_WS_MAEMO_5)
    viewer.engine()->addImportPath(QString("/opt/qtm12/imports"));
#endif
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    viewer.setMainQmlFile(QLatin1String(MAIN_QML_STR));
    viewer.showExpanded();

    return app.exec();
}
