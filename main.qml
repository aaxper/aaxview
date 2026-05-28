import QtQuick
import QtQuick.Window
import Qt.labs.folderlistmodel

Window {
    id: root
    visible: true
    title: "aaxview"

    color: "transparent"
    Rectangle {
        anchors.fill: parent
        color: "#141721"
        opacity: 0.9
    }

    function getDirectory(filePath) {
        return filePath.substring(0, filePath.lastIndexOf("/") + 1);
    }

    FolderListModel {
        id: folderModel
        folder: getDirectory(imagePath)
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

    Item {
        focus: true
        Keys.onPressed: event => {
            if (event.key == Qt.Key_Right) {
                if (folderModel.count > 0)
                    folderModel.setFileIndex(mod(folderModel.fetchIndex + 1, folderModel.count));
                event.accepted = true;
            }
            if (event.key == Qt.Key_Left) {
                if (folderModel.count > 0)
                    folderModel.setFileIndex(mod(folderModel.fetchIndex - 1, folderModel.count));
                event.accepted = true;
            }
            if (event.key == Qt.Key_S) {
                image.smooth = !image.smooth;
                event.accepted = true;
            }
            if (event.key == Qt.Key_R) {
                image.width = parent.width;
                image.height = parent.height;
                image.x = 0;
                image.y = 0;
                image.rotation = 0;
                event.accepted = true;
            }
            if (event.key == Qt.Key_Escape) {
                event.accepted = true;
                Qt.quit();
            }
            if (event.key == Qt.Key_T) {
                if (event.modifiers & Qt.ShiftModifier)
                    image.rotation -= 90;
                else
                    image.rotation += 90;
                event.accepted = true;
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
            zoom(1 + 0.15 * Math.sign(event.angleDelta.y), event.x, event.y);
            event.accepted = false;
        }
    }

    Image {
        id: image
        width: parent.width
        height: parent.height
        x: 0
        y: 0
        fillMode: Image.PreserveAspectFit
        source: folderModel.path
        DragHandler {}
        smooth: true
    }
}
