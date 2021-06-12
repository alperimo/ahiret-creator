#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QtQuick/QQuickView>

#include "squircle.h"

#include "openglitem.h"
#include "mytreemodel.h"

#include <iostream>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    std::cout << "int main()" << std::endl;

    qmlRegisterType<CustomItem>("OpenGLUnderQML", 1, 0, "CustomItem");
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
    engine.load(url);

    return app.exec();
}
