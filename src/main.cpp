#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFileInfo>
#include <QUrl>
#include <QStandardPaths>
#include <QDir>
#include <QFile>

static QString lastFilePath()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/lastfile";
}

static QString loadLastFile()
{
    QFile f(lastFilePath());
    if (f.open(QIODevice::ReadOnly))
        return QString::fromUtf8(f.readAll()).trimmed();
    return {};
}

static void saveLastFile(const QString &path)
{
    if (path.isEmpty())
        return;
    QString dir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir().mkpath(dir);
    QFile f(lastFilePath());
    if (f.open(QIODevice::WriteOnly | QIODevice::Truncate))
        f.write(path.toUtf8());
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("aaxview");
    app.setApplicationName("aaxview");

    QString imagePath;
    if (argc > 1) {
        QString inputPath = QString::fromLocal8Bit(argv[1]);
        if (!QFile::exists(inputPath)) {
            qWarning("Error: Input file does not exist: %s", qUtf8Printable(inputPath));
            return 1;
        }
        imagePath = QUrl::fromLocalFile(QFileInfo(inputPath).absoluteFilePath()).toString();
    } else {
        imagePath = loadLastFile();
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(
        "imagePath",
        imagePath
    );
    engine.loadFromModule("aaxview", "Main");
    if (engine.rootObjects().isEmpty())
        return -1;

    QObject *folderModel = engine.rootObjects().first()->findChild<QObject*>("folderModel");
    QObject::connect(&app, &QGuiApplication::aboutToQuit, [folderModel]() {
        if (folderModel)
            saveLastFile(folderModel->property("path").toString());
    });

    return app.exec();
}
