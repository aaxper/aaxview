import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

RowLayout {
    id: root

    property string label
    property real labelWidth: 120
    property var options
    property var value
    property Settings appSettings
    property bool isColor: false

    signal accepted(var editedValue)

    spacing: 8

    function rgbaToColor(rgbaHex, forceOpaque = false) {
        var r = parseInt(rgbaHex.substr(1, 2), 16) / 255
        var g = parseInt(rgbaHex.substr(3, 2), 16) / 255
        var b = parseInt(rgbaHex.substr(5, 2), 16) / 255
        var a = (rgbaHex.length == 7 || forceOpaque) ? 1 : parseInt(rgbaHex.substr(7, 2), 16) / 255
        return Qt.rgba(r, g, b, a)
    }

    Text {
        text: root.label
        font.pixelSize: root.appSettings.fontSize
        font.family: root.appSettings.fontFamily
        color: root.rgbaToColor(root.appSettings.fgColor)
        Layout.preferredWidth: root.labelWidth
        Layout.alignment: Qt.AlignVCenter
    }

    ComboBox {
        id: input
        model: root.options
        currentIndex: root.options.indexOf(root.value)
        font.pixelSize: root.appSettings.fontSize
        font.family: root.appSettings.fontFamily
        palette.buttonText: root.rgbaToColor(root.appSettings.fgColor2)
        Layout.minimumWidth: 120
        background: Rectangle {
            color: root.rgbaToColor(root.appSettings.bgColor2)
            radius: 3
        }
        popup: Popup {
            y: input.height - 1
            width: input.width
            padding: 0
            background: Rectangle {
                color: root.rgbaToColor(root.appSettings.bgColor2, true)
                radius: 3
            }
            contentItem: ListView {
                clip: true
                implicitHeight: Math.min(contentHeight, 300)
                model: input.delegateModel
                currentIndex: input.highlightedIndex
                highlightMoveDuration: 0
            }
        }
        onCurrentIndexChanged: root.accepted(root.options[currentIndex])
    }
}
