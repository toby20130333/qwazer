#include <QtGui/QApplication>
#include <QtDeclarative>

#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#define MAIN_QML_STR TOSTRING(MAIN_QML)

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeView view;
    QObject::connect(view.engine(), SIGNAL(quit()),
                        &app, SLOT(quit()));

    QUrl mainQML(MAIN_QML_STR);
#if defined(Q_WS_MAEMO_5)
    view.engine()->addImportPath(QString("/opt/qtm12/imports"));
    view.showMaximized();
#elif defined(Q_WS_MAEMO_6) || defined(QT_SIMULATOR)
    view.showFullScreen();
#endif

    view.setSource(mainQML);

    return app.exec();
}
