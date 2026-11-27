import QtQuick 2.15

Image {
    id: icon

    property string name: ""
    property int size: 20

    width: size
    height: size
    source: name.length > 0 ? Qt.resolvedUrl("../assets/icons/" + name + ".svg") : ""
    sourceSize.width: Math.ceil(size * 2)
    sourceSize.height: Math.ceil(size * 2)
    fillMode: Image.PreserveAspectFit
    smooth: true
    cache: true
}
