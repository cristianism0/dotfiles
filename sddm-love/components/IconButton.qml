import QtQuick 2.15

Item {
    id: button

    property string icon: ""
    property int iconSize: 20
    property int padding: 9
    property bool active: false
    signal clicked()

    implicitWidth: iconSize + padding * 2
    implicitHeight: iconSize + padding * 2
    opacity: enabled ? 1 : 0.35
    scale: mouse.pressed && enabled ? 0.92 : 1.0

    Behavior on scale {
        NumberAnimation { duration: 90 }
    }

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: button.active
            ? Qt.rgba(1, 1, 1, 0.20)
            : (mouse.containsMouse && button.enabled ? Qt.rgba(1, 1, 1, 0.12) : "transparent")

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    Icon {
        anchors.centerIn: parent
        name: button.icon
        size: button.iconSize
        opacity: button.enabled ? 1 : 0.6
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: button.clicked()
    }
}
