pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.VectorImage
import QtCore
import QtQuick.Window
import Qt.labs.folderlistmodel

Window {
    id: root
    visible: true
    title: "aaxview"

    color: "transparent"
    Rectangle {
        anchors.fill: parent
        color: root.rgbaToColor(settings.bgColor)
    }

    function getDirectory(filePath) {
        return filePath.substring(0, filePath.lastIndexOf("/") + 1);
    }

    function rgbaToColor(rgbaHex, forceOpaque = false) {
        var r = parseInt(rgbaHex.substr(1, 2), 16) / 255;
        var g = parseInt(rgbaHex.substr(3, 2), 16) / 255;
        var b = parseInt(rgbaHex.substr(5, 2), 16) / 255;
        var a = (rgbaHex.length == 7 || forceOpaque) ? 1 : parseInt(rgbaHex.substr(7, 2), 16) / 255;
        return Qt.rgba(r, g, b, a);
    }

    function isVectorSource(source) {
        var path = String(source).split("?")[0].split("#")[0].toLowerCase();
        return path.slice(-4) === ".svg";
    }

    FolderListModel {
        id: folderModel
        objectName: "folderModel"
        folder: root.getDirectory(imagePath)
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.bmp", "*.gif", "*.webp", "*.svg", "*.tiff", "*.ico"]
        showDirs: false
        sortField: FolderListModel.Name
        sortCaseSensitive: false
        property int fetchIndex: -1
        property string path: imagePath
        onStatusChanged: {
            if (status == FolderListModel.Ready && fetchIndex === -1) {
                fetchIndex = Math.max(0, indexOf(path));
                path = "file://" + get(fetchIndex, "filePath");
            }
        }
        function setFileIndex(index) {
            fetchIndex = index;
            path = "file://" + get(fetchIndex, "filePath");
        }
    }

    function mod(n, m) {
        return ((n % m) + m) % m;
    }

    function nextImage() {
        if (folderModel.count > 0)
            folderModel.setFileIndex(mod(folderModel.fetchIndex + 1, folderModel.count));
    }

    function previousImage() {
        if (folderModel.count > 0)
            folderModel.setFileIndex(mod(folderModel.fetchIndex - 1, folderModel.count));
    }

    function resetImage() {
        image.width = root.width;
        image.height = root.height;
        image.x = 0;
        image.y = 0;
        image.rotation = 0;
    }

    Shortcut {
        sequence: settings.next
        context: Qt.WindowShortcut
        onActivated: root.nextImage()
    }

    Shortcut {
        sequence: settings.previous
        context: Qt.WindowShortcut
        onActivated: root.previousImage()
    }

    Shortcut {
        sequence: settings.toggleSmooth
        context: Qt.WindowShortcut
        onActivated: rasterImage.smooth = !rasterImage.smooth
    }

    Shortcut {
        sequence: settings.reset
        context: Qt.WindowShortcut
        onActivated: root.resetImage()
    }

    Shortcut {
        sequence: settings.quit
        context: Qt.WindowShortcut
        enabled: !settingsPopupLoader.active || !settingsPopupLoader.item.visible
        onActivated: Qt.quit()
    }

    Shortcut {
        sequence: settings.rotate
        context: Qt.WindowShortcut
        onActivated: image.rotation += 90
    }

    Shortcut {
        sequence: settings.rotateBack
        context: Qt.WindowShortcut
        onActivated: image.rotation -= 90
    }

    Shortcut {
        sequence: settings.toggleSettings
        context: Qt.WindowShortcut
        onActivated: {
            if (settingsPopupLoader.active) {
                settingsPopupLoader.item.visible = !settingsPopupLoader.item.visible;
            } else {
                settingsPopupLoader.active = true;
                settingsPopupLoader.item.visible = true;
            }
        }
    }

    function zoom(ratio, x, y) {
        image.width = image.width * ratio;
        image.height = image.height * ratio;
        var xOffset = x - image.x;
        var yOffset = y - image.y;
        image.x = x - xOffset * ratio;
        image.y = y - yOffset * ratio;
    }

    WheelHandler {
        target: null
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            root.zoom(1 + 0.15 * Math.sign(event.angleDelta.y), event.x, event.y);
            event.accepted = false;
        }
    }

    Item {
        id: image
        width: root.width
        height: root.height
        readonly property bool vectorSource: root.isVectorSource(folderModel.path)
        DragHandler {
            target: image
        }

        Image {
            id: rasterImage
            anchors.fill: parent
            visible: !image.vectorSource
            fillMode: Image.PreserveAspectFit
            source: image.vectorSource ? "" : folderModel.path
            Component.onCompleted: smooth = settings.smoothDefault
        }

        VectorImage {
            id: svgImage
            anchors.fill: parent
            visible: image.vectorSource
            fillMode: VectorImage.PreserveAspectFit
            preferredRendererType: VectorImage.CurveRenderer
            source: image.vectorSource ? folderModel.path : ""
        }
    }

    Settings {
        id: settings
        property string bgColor: "#000000ff"
        property string fgColor: "#ccccccff"
        property string bgColor2: "#888888ff"
        property string fgColor2: "#ffffffff"
        property bool smoothDefault: true
        property string next: "right"
        property string previous: "left"
        property string toggleSmooth: "S"
        property string reset: "R"
        property string quit: "esc"
        property string rotate: "T"
        property string rotateBack: "shift+T"
        property string toggleSettings: "P"
        property string barVisibility: "visible"
        property string fontFamily: ""
        property int fontSize: 14
        property int settingsWidth: 380
        property int settingsHeight: 600
    }

    Loader {
        id: settingsPopupLoader
        active: false
        sourceComponent: SettingsWindow {
            owner: root
            appSettings: settings
        }
    }
}
