import QtQuick 2.15

Item {
    id: button

    property color accentColor: "#3584e4"
    property bool busy: false
    signal clicked()

    implicitWidth: 48
    implicitHeight: 48
    opacity: enabled ? 1 : 0.4
    scale: mouse.pressed && enabled ? 0.94 : 1.0

    Behavior on scale {
        NumberAnimation { duration: 90 }
    }

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: !button.enabled
            ? Qt.rgba(1, 1, 1, 0.12)
            : (mouse.containsMouse ? Qt.lighter(button.accentColor, 1.12) : button.accentColor)

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    Icon {
        anchors.centerIn: parent
        name: "arrow-right"
        size: 22
        visible: !button.busy
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: button.clicked()
    }
}
