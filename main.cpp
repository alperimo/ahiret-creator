#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QtQuick/QQuickView>

#include <QFontInfo>

#include <QIcon>

#include "squircle.h"

#include "openglitem.h"
#include "mytreemodel.h"

#include <iostream>

/*Q_DECLARE_METATYPE( Qml_camera* )
Q_DECLARE_OPAQUE_POINTER(Qml_camera*)*/

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    //QGuiApplication app(argc, argv);

    QApplication app(argc, argv);

    app.setWindowIcon(QIcon("images/ahiret.ico"));

    std::cout << "int main()" << std::endl;



    qmlRegisterType<CustomItem>("OpenGLUnderQML", 1, 0, "CustomItem");

    //qRegisterMetaType<Qml_camera*>("Qml_camera*");

    qmlRegisterType<Qml_camera>("OpenGLCamera", 1, 0, "Qml_camera");

    //qmlRegisterType<Qml_camera>();

    //qmlRegisterType<Qml_camera>("OpenGLUnderQML", 1, 0, "Qml_camera");

    //qmlRegisterUncreatableType<Qml_camera>("OpenGLCamera", 1, 0, "Qml_camera", "test");

    qmlRegisterType<MyTreeModel>("MyTreeModel", 1, 0, "MyTreeModel");

    /*
    qmlRegisterType<Squircle>("OpenGLUnderQML", 1, 0, "Squircle");
    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:/main2.qml"));
    view.show();*/



    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    //CustomItem customItem;

    engine.load(url);

    return app.exec();
}
