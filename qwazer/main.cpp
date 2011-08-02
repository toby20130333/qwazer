#include <QtGui/QApplication>
#include <QtDeclarative>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeView view;
    QObject::connect(view.engine(), SIGNAL(quit()),
                        &app, SLOT(quit()));
    QDir qwazerDir = QDir(app.applicationDirPath());

#ifdef Q_WS_MAEMO_5
    view.engine()->addImportPath(QString("/opt/qtm12/imports"));
    qwazerDir.cdUp();
    view.showMaximized();
#else
    view.showNormal();
#endif

    view.setSource(QUrl(QString(qwazerDir.absolutePath()).append("/qml/maemo/main.qml")));

    return app.exec();
}
