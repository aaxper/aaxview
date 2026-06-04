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

    ComboBox {
        id: input
        model: root.options
        currentIndex: root.options.indexOf(root.value)
        font.pixelSize: root.appSettings.fontSize
        font.family: root.appSettings.fontFamily
        palette.buttonText: root.opaqueColor(root.appSettings.fgColor2)
        opacity: root.colorAlpha(root.appSettings.fgColor2)
        Layout.minimumWidth: 120
        background: Rectangle {
            color: root.opaqueColor(root.appSettings.bgColor2)
            opacity: root.colorAlpha(root.appSettings.bgColor2)
            radius: 3
        }
        popup: Popup {
            y: input.height - 1
            width: input.width
            padding: 0
            background: Rectangle {
                color: root.opaqueColor(root.appSettings.bgColor2)
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
