import QtQuick 2.15

Item {
    id: row

    property string label: ""
    property string sublabel: ""
    property url avatarSource: ""
    property bool showAvatar: false
    property string icon: ""
    property bool selected: false
    property bool available: true
    property string fontFamily: "Cantarell"
    signal clicked()

    width: parent ? parent.width : 0
    height: 52
    opacity: available ? 1 : 0.4

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: mouse.containsMouse && row.available ? Qt.rgba(1, 1, 1, 0.10) : "transparent"

        Behavior on color {
            ColorAnimation { duration: 100 }
        }
    }

    Avatar {
        id: avatar
        visible: row.showAvatar || row.avatarSource.toString().length > 0
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        size: 32
        source: row.avatarSource
        name: row.label
        fontFamily: row.fontFamily
    }

    Icon {
        id: leadingIcon
        visible: !avatar.visible && row.icon.length > 0
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        name: row.icon
        size: 20
    }

    Column {
        anchors.left: avatar.visible ? avatar.right : (leadingIcon.visible ? leadingIcon.right : parent.left)
        anchors.leftMargin: (avatar.visible || leadingIcon.visible) ? 12 : 14
        anchors.right: check.visible ? check.left : parent.right
        anchors.rightMargin: check.visible ? 10 : 14
        anchors.verticalCenter: parent.verticalCenter
        spacing: 1

        Text {
            width: parent.width
            text: row.label
            color: "#ffffff"
            font.family: row.fontFamily
            font.pixelSize: 14
            font.weight: Font.Medium
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            visible: row.sublabel.length > 0
            text: row.sublabel
            color: Qt.rgba(1, 1, 1, 0.55)
            font.family: row.fontFamily
            font.pixelSize: 12
            elide: Text.ElideRight
        }
    }

    Icon {
        id: check
        visible: row.selected
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        name: "check"
        size: 18
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: row.available
        cursorShape: Qt.PointingHandCursor
        onClicked: row.clicked()
    }
}
