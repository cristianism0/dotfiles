import QtQuick 2.15

Item {
    id: avatar

    property url source
    property string name: ""
    property string fontFamily: "Cantarell"
    property int size: 96

    width: size
    height: size

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "#2a2a33"
        clip: true

        Image {
            id: image
            anchors.fill: parent
            source: avatar.source
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            visible: status === Image.Ready
        }

        Text {
            anchors.centerIn: parent
            visible: image.status !== Image.Ready
            text: avatar.name.length > 0 ? avatar.name.charAt(0).toUpperCase() : "?"
            color: Qt.rgba(1, 1, 1, 0.9)
            font.family: avatar.fontFamily
            font.pixelSize: Math.round(avatar.size * 0.42)
            font.weight: Font.DemiBold
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.width: 2
        border.color: Qt.rgba(1, 1, 1, 0.5)
    }
}
