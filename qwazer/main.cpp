#include <QtGui/QApplication>
#include <QtDeclarative>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeView view;
    QObject::connect(view.engine(), SIGNAL(quit()),
                        &app, SLOT(quit()));
    QDir qwazerDir = QDir(app.applicationDirPath());

    QString mainQML;
#ifdef Q_WS_MAEMO_5
    view.engine()->addImportPath(QString("/opt/qtm12/imports"));
    qwazerDir.cdUp();
    view.showMaximized();
    mainQML = QString("/qml/maemo/main.qml");
#elif Q_WS_MAEMO_6
    qwazerDir.cdUp();
    view.showMaximized();
    mainQML = QString("/qml/meego/main.qml");
#else
    view.showNormal();
#endif

    view.setSource(QUrl(QString(qwazerDir.absolutePath()).append(mainQML)));

    return app.exec();
}
