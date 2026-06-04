import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

RowLayout {
    id: root

    property string label
    property real labelWidth: 120
    property string value
    property Settings appSettings
    property bool isColor: false

    signal accepted(string editedValue)

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

    TextField {
        id: input
        text: root.isColor ? root.value.slice(1) : root.value
        placeholderText: root.isColor ? root.value.slice(1) : root.value
        font.pixelSize: root.appSettings.fontSize
        font.family: root.appSettings.fontFamily
        color: root.rgbaToColor(root.appSettings.fgColor2)
        Layout.minimumWidth: 120
        background: Rectangle {
            color: root.rgbaToColor(root.appSettings.bgColor2)
            radius: 3
        }
        onEditingFinished: root.accepted(root.isColor ? "#" + text : text)
    }
}
