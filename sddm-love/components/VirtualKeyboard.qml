import QtQuick 2.15

Item {
    id: kb

    property var target: null
    property string fontFamily: "Cantarell"
    property color accentColor: "#3584e4"
    property int page: 0
    property bool shift: false

    signal accepted()

    implicitWidth: 680
    implicitHeight: 288

    readonly property real keyWidth: 56
    readonly property real keyHeight: 42
    readonly property real gap: 8
    readonly property real padding: 22

    readonly property var letterRows: [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        [{ "icon": "chevron-up", "action": "shift", "w": 1.5 },
         "z", "x", "c", "v", "b", "n", "m",
         { "icon": "backspace", "action": "backspace", "w": 1.5 }],
        [{ "label": "?123", "action": "symbols", "w": 1.5 },
         { "label": "espaço", "action": "space", "w": 5.0 },
         { "icon": "arrow-right", "action": "enter", "w": 1.5, "accent": true }]
    ]

    readonly property var symbolRows: [
        ["!", "@", "#", "$", "%", "&", "*", "(", ")", "-"],
        ["_", "=", "+", "/", "\\", "|", "~", "^", "<", ">"],
        ["[", "]", "{", "}", ":", ";", "'", "\"", "`", "?"],
        ["á", "é", "í", "ó", "ú", "ç", "ã", "õ", "â", "ê"],
        [{ "label": "ABC", "action": "letters", "w": 1.5 },
         { "label": "espaço", "action": "space", "w": 5.0 },
         { "icon": "backspace", "action": "backspace", "w": 1.5 },
         { "icon": "arrow-right", "action": "enter", "w": 1.5, "accent": true }]
    ]

    readonly property var rows: page === 0 ? letterRows : symbolRows

    function press(value) {
        if (!target)
            return
        var text = (shift && page === 0) ? value.toUpperCase() : value
        target.insertText(text)
        if (shift)
            shift = false
    }

    function handleKey(key) {
        if (typeof key === "string") {
            press(key)
        } else if (key.action === "shift") {
            shift = !shift
        } else if (key.action === "backspace") {
            if (target)
                target.backspaceText()
        } else if (key.action === "space") {
            press(" ")
        } else if (key.action === "enter") {
            accepted()
        } else if (key.action === "symbols") {
            page = 1
            shift = false
        } else if (key.action === "letters") {
            page = 0
            shift = false
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 22
        color: Qt.rgba(0.055, 0.055, 0.075, 0.94)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.10)
    }

    Column {
        anchors.centerIn: parent
        spacing: kb.gap

        Repeater {
            model: kb.rows

            delegate: Item {
                width: kb.width - kb.padding * 2
                height: kb.keyHeight

                Row {
                    anchors.centerIn: parent
                    spacing: kb.gap

                    Repeater {
                        model: modelData

                        delegate: KeyButton {
                            readonly property var key: modelData
                            readonly property bool isObject: typeof key === "object"

                            label: isObject
                                ? (key.label || "")
                                : (kb.shift && kb.page === 0 ? String(key).toUpperCase() : String(key))
                            icon: isObject ? (key.icon || "") : ""
                            keyWidth: kb.keyWidth * (isObject && key.w ? key.w : 1)
                            accent: isObject && key.accent === true
                            active: (isObject && key.action === "shift") ? kb.shift : false
                            fontFamily: kb.fontFamily
                            accentColor: kb.accentColor
                            onClicked: kb.handleKey(key)
                        }
                    }
                }
            }
        }
    }
}
