#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFileInfo>
#include <QUrl>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QString imagePath;
    if (argc > 1)
        imagePath = QUrl::fromLocalFile(QFileInfo(argv[1]).absoluteFilePath()).toString();
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(
        "imagePath",
        imagePath
    );
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
