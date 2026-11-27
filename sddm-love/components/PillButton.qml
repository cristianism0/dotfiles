import QtQuick 2.15

Item {
    id: pill

    property string icon: ""
    property string text: ""
    property bool showChevron: true
    property string fontFamily: "Cantarell"
    signal clicked()

    implicitWidth: content.implicitWidth + 26
    implicitHeight: 38
    opacity: enabled ? 1 : 0.4
    scale: mouse.pressed && enabled ? 0.97 : 1.0

    Behavior on scale {
        NumberAnimation { duration: 90 }
    }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: mouse.containsMouse && pill.enabled ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(1, 1, 1, 0.07)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.09)

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 7

        Icon {
            name: pill.icon
            size: 16
            anchors.verticalCenter: parent.verticalCenter
            visible: pill.icon.length > 0
        }

        Text {
            text: pill.text
            color: Qt.rgba(1, 1, 1, 0.9)
            font.family: pill.fontFamily
            font.pixelSize: 13
            anchors.verticalCenter: parent.verticalCenter
        }

        Icon {
            name: "chevron-up"
            size: 12
            anchors.verticalCenter: parent.verticalCenter
            visible: pill.showChevron
            opacity: 0.7
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: pill.clicked()
    }
}
