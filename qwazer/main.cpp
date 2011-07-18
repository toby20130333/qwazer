#include <QtGui/QApplication>
#include <QtDeclarative>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeView view;
    QObject::connect(view.engine(), SIGNAL(quit()),
                        &app, SLOT(quit()));
    view.setSource(QUrl("qrc:/qml/main.qml"));
#ifdef Q_WS_MAEMO_5
    view.showFullScreen();
#else
    view.showNormal();
#endif
    return app.exec();
}
