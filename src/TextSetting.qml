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

    function colorAlpha(color) {
        if (color.length === 9)
            return parseInt(color.slice(7, 9), 16) / 255;
        return 1;
    }

    function opaqueColor(color) {
        if (color.length === 9)
            return color.slice(0, 7);
        return color;
    }

    Text {
        text: root.label
        font.pixelSize: root.appSettings.fontSize
        font.family: root.appSettings.fontFamily
        color: root.opaqueColor(root.appSettings.fgColor)
        opacity: root.colorAlpha(root.appSettings.fgColor)
        Layout.preferredWidth: root.labelWidth
        Layout.alignment: Qt.AlignVCenter
    }

    TextField {
        id: input
        text: root.isColor ? root.value.slice(1) : root.value
        placeholderText: root.isColor ? root.value.slice(1) : root.value
        font.pixelSize: root.appSettings.fontSize
        font.family: root.appSettings.fontFamily
        color: root.opaqueColor(root.appSettings.fgColor2)
        opacity: root.colorAlpha(root.appSettings.fgColor2)
        Layout.minimumWidth: 120
        background: Rectangle {
            color: root.opaqueColor(root.appSettings.bgColor2)
            opacity: root.colorAlpha(root.appSettings.bgColor2)
            radius: 3
        }
        onEditingFinished: root.accepted(root.isColor ? "#" + text : text)
    }
}
