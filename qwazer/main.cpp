#include <QtGui/QApplication>
#include <QtDeclarative>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeView view;
    QObject::connect(view.engine(), SIGNAL(quit()),
                        &app, SLOT(quit()));
    QDir qwazerDir = QDir(app.applicationDirPath());


//#ifdef Q_WS_MAEMO_5
//    qwazerDir.cdUp();
    view.setSource(QUrl(QString(qwazerDir.absolutePath()).append("/qml/maemo/main.qml")));
//    view.showFullScreen();
//#else
//    view.setSource(QUrl(QString(qwazerDir.absolutePath()).append("/qml/meego/main.qml")));
    view.showNormal();
//#endif
    return app.exec();
}
