#include <QtGui/QApplication>
#include <QtDeclarative>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeView view;
    QObject::connect(view.engine(), SIGNAL(quit()),
                        &app, SLOT(quit()));
    QDir qwazerDir = QDir("/opt/qwazer");

    QString mainQML;
#ifdef Q_WS_MAEMO_5
    view.engine()->addImportPath(QString("/opt/qtm12/imports"));
    view.showMaximized();
    mainQML = QString("/qml/maemo/main.qml");
#elif Q_WS_MAEMO_6
    view.showFullScreen();
    mainQML = QString("/qml/meego/main.qml");
#else
    view.showNormal();
#endif

    view.setSource(QUrl(QString(qwazerDir.absolutePath()).append(mainQML)));

    return app.exec();
}
