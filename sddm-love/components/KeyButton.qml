import QtQuick 2.15

Rectangle {
    id: key

    property string label: ""
    property string icon: ""
    property real keyWidth: 56
    property bool active: false
    property bool accent: false
    property color accentColor: "#3584e4"
    property string fontFamily: "Cantarell"
    property bool down: false
    signal clicked()

    implicitWidth: keyWidth
    implicitHeight: 42
    radius: 8
    color: accent
        ? accentColor
        : (down
            ? Qt.rgba(1, 1, 1, 0.34)
            : (active ? Qt.rgba(1, 1, 1, 0.26) : Qt.rgba(1, 1, 1, 0.13)))
    border.width: 1
    border.color: accent ? "transparent" : Qt.rgba(1, 1, 1, 0.10)

    Behavior on color {
        ColorAnimation { duration: 80 }
    }

    Text {
        anchors.centerIn: parent
        visible: key.icon.length === 0
        text: key.label
        color: "#ffffff"
        font.family: key.fontFamily
        font.pixelSize: key.label.length > 2 ? 12 : 16
    }

    Icon {
        anchors.centerIn: parent
        visible: key.icon.length > 0
        name: key.icon
        size: 17
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressedChanged: key.down = pressed
        onClicked: key.clicked()
    }

    Accessible.role: Accessible.Button
    Accessible.name: key.label.length > 0 ? key.label : key.icon
}
