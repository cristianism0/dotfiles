import QtQuick 2.15

Rectangle {
    id: surface

    property bool opened: false
    property int origin: Item.Bottom
    default property alias contentData: column.data

    width: 280
    height: column.implicitHeight + 16
    radius: 16
    color: Qt.rgba(0.075, 0.075, 0.095, 1.0)
    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.12)

    visible: opacity > 0
    opacity: opened ? 1 : 0
    scale: opened ? 1 : 0.97
    transformOrigin: surface.origin

    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    Behavior on scale {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 8
        spacing: 2
    }
}
