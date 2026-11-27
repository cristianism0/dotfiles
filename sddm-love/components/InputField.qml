import QtQuick 2.15

Item {
    id: field

    property alias text: input.text
    property string placeholder: ""
    property bool passwordMode: true
    property bool reveal: false
    property bool hasError: false
    property color accentColor: "#3584e4"
    property string fontFamily: "Cantarell"
    property int fontPixelSize: 16
    signal accepted()
    signal edited()
    signal focused()

    implicitWidth: 300
    implicitHeight: 48

    function forceInputFocus() {
        input.forceActiveFocus()
    }

    function insertText(value) {
        if (value.length === 0)
            return
        var pos = input.cursorPosition
        input.text = input.text.substring(0, pos) + value + input.text.substring(pos)
        input.cursorPosition = pos + value.length
        field.edited()
    }

    function backspaceText() {
        var pos = input.cursorPosition
        if (pos <= 0)
            return
        input.text = input.text.substring(0, pos - 1) + input.text.substring(pos)
        input.cursorPosition = pos - 1
        field.edited()
    }

    Rectangle {
        id: background
        anchors.fill: parent
        radius: height / 2
        color: input.activeFocus ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(1, 1, 1, 0.10)
        border.width: field.hasError ? 2 : 1
        border.color: field.hasError
            ? "#e01b24"
            : (input.activeFocus ? field.accentColor : Qt.rgba(1, 1, 1, 0.18))

        Behavior on color {
            ColorAnimation { duration: 140 }
        }

        Behavior on border.color {
            ColorAnimation { duration: 140 }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        onClicked: input.forceActiveFocus()
    }

    TextInput {
        id: input
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: field.passwordMode ? 46 : 20
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        verticalAlignment: TextInput.AlignVCenter
        color: "#ffffff"
        font.family: field.fontFamily
        font.pixelSize: field.fontPixelSize
        selectionColor: field.accentColor
        selectedTextColor: "#ffffff"
        echoMode: field.passwordMode && !field.reveal ? TextInput.Password : TextInput.Normal
        passwordCharacter: "\u25CF"
        passwordMaskDelay: 0
        selectByMouse: true
        clip: true

        onAccepted: field.accepted()
        onTextEdited: field.edited()
        onActiveFocusChanged: if (activeFocus) field.focused()
    }

    Text {
        anchors.left: input.left
        anchors.right: input.right
        anchors.verticalCenter: parent.verticalCenter
        text: field.placeholder
        color: Qt.rgba(1, 1, 1, 0.45)
        font.family: field.fontFamily
        font.pixelSize: field.fontPixelSize
        elide: Text.ElideRight
        visible: input.text.length === 0
    }

    IconButton {
        id: eyeButton
        visible: field.passwordMode
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        icon: field.reveal ? "eye-off" : "eye"
        iconSize: 18
        padding: 8

        Accessible.role: Accessible.Button
        Accessible.name: field.reveal ? qsTr("Hide password") : qsTr("Show password")

        onClicked: {
            field.reveal = !field.reveal
            input.forceActiveFocus()
        }
    }
}
