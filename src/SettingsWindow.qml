import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import QtCore

Window {
    id: settingsWindow

    property Window owner
    property Settings appSettings

    title: "aaxview settings"
    width: appSettings.settingsWidth
    height: appSettings.settingsHeight
    transientParent: owner
    flags: Qt.Dialog
    color: "transparent"
    modality: Qt.WindowModal

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

    TextMetrics {
        id: _labelMetrics
        font.pixelSize: settingsWindow.appSettings.fontSize
        font.family: settingsWindow.appSettings.fontFamily
        text: "default smoothing:"
    }

    Rectangle {
        anchors.fill: parent
        color: settingsWindow.opaqueColor(settingsWindow.appSettings.bgColor)
        opacity: settingsWindow.colorAlpha(settingsWindow.appSettings.bgColor)
    }

    ScrollView {
        id: scrollContainer
        anchors.fill: parent
        clip: true
        Component.onCompleted: contentItem.boundsBehavior = Flickable.StopAtBounds

        ColumnLayout {
            id: settingsLayout
            x: (scrollContainer.availableWidth - implicitWidth) / 2
            width: implicitWidth
            spacing: 4

            TapHandler {
                onTapped: settingsLayout.forceActiveFocus()
            }

            Item { width: parent.width; height: 16 }

            Text {
                text: "Coloring"
                font.pixelSize: settingsWindow.appSettings.fontSize + 4
                font.family: settingsWindow.appSettings.fontFamily
                color: settingsWindow.owner.rgbaToColor(settingsWindow.appSettings.fgColor)
                Layout.topMargin: 8
                Layout.bottomMargin: 4
            }

            TextSetting {
                label: "background:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.bgColor
                appSettings: settingsWindow.appSettings
                isColor: true
                onAccepted: editedValue => settingsWindow.appSettings.bgColor = editedValue
            }

            TextSetting {
                label: "accent bg:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.bgColor2
                appSettings: settingsWindow.appSettings
                isColor: true
                onAccepted: editedValue => settingsWindow.appSettings.bgColor2 = editedValue
            }

            TextSetting {
                label: "foreground:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.fgColor
                appSettings: settingsWindow.appSettings
                isColor: true
                onAccepted: editedValue => settingsWindow.appSettings.fgColor = editedValue
            }

            TextSetting {
                label: "accent fg:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.fgColor2
                appSettings: settingsWindow.appSettings
                isColor: true
                onAccepted: editedValue => settingsWindow.appSettings.fgColor2 = editedValue
            }

            Text {
                text: "Binds"
                font.pixelSize: settingsWindow.appSettings.fontSize + 4
                font.family: settingsWindow.appSettings.fontFamily
                color: settingsWindow.owner.rgbaToColor(settingsWindow.appSettings.fgColor)
                Layout.topMargin: 16
                Layout.bottomMargin: 4
            }

            TextSetting {
                label: "next:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.next
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.next = editedValue
            }

            TextSetting {
                label: "previous:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.previous
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.previous = editedValue
            }

            TextSetting {
                label: "toggle smooth:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.toggleSmooth
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.toggleSmooth = editedValue
            }

            TextSetting {
                label: "reset image:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.reset
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.reset = editedValue
            }

            TextSetting {
                label: "rotate cw:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.rotate
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.rotate = editedValue
            }

            TextSetting {
                label: "rotate ccw:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.rotateBack
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.rotateBack = editedValue
            }

            TextSetting {
                label: "open settings:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.toggleSettings
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.toggleSettings = editedValue
            }

            TextSetting {
                label: "quit:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.quit
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.quit = editedValue
            }

            Text {
                text: "Miscellaneous"
                font.pixelSize: settingsWindow.appSettings.fontSize + 4
                font.family: settingsWindow.appSettings.fontFamily
                color: settingsWindow.owner.rgbaToColor(settingsWindow.appSettings.fgColor)
                Layout.topMargin: 16
                Layout.bottomMargin: 4
            }

            DropdownSetting {
                label: "font family:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.fontFamily
                options: [""].concat(Qt.fontFamilies())
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.fontFamily = editedValue
            }

            TextSetting {
                label: "font size:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.fontSize
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.fontSize = parseInt(editedValue)
            }

            DropdownSetting {
                label: "smooth default:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.smoothDefault
                options: [true, false]
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.smoothDefault = editedValue
            }

            TextSetting {
                label: "popup width:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.settingsWidth
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.settingsWidth = parseInt(editedValue)
            }

            TextSetting {
                label: "popup height:"
                labelWidth: _labelMetrics.advanceWidth + 8
                value: settingsWindow.appSettings.settingsHeight
                appSettings: settingsWindow.appSettings
                onAccepted: editedValue => settingsWindow.appSettings.settingsHeight = parseInt(editedValue)
            }

            Item { width: parent.width; height: 16 }
        }
    }

    Shortcut {
        sequence: settingsWindow.appSettings.quit
        context: Qt.WindowShortcut
        enabled: settingsWindow.visible
        onActivated: settingsWindow.visible = false
    }
}
