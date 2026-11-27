import QtQuick 2.15
import "components"

Item {
    id: root

    width: 1920
    height: 1080

    // ------------------------------------------------------------------ theme
    readonly property string fontFamily: (config.font && config.font.length > 0) ? config.font : "Cantarell"
    readonly property color accentColor: (config.accent && config.accent.length > 0) ? config.accent : "#3584e4"
    readonly property url backgroundSource: config.background ? Qt.resolvedUrl(config.background) : ""
    readonly property color fallbackBackground: (config.color && config.color.length > 0) ? config.color : "#101014"
    readonly property var themeLocale: (config.locale && config.locale.length > 0)
        ? Qt.locale(config.locale)
        : Qt.locale()
    readonly property string dateFormat: (config.dateFormat && config.dateFormat.length > 0)
        ? config.dateFormat
        : "dddd, d MMMM"

    // ------------------------------------------------------------------ state
    property int userIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
    property int sessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0

    property string currentUserName: userModel.lastUser
    property string currentRealName: userModel.lastUser
    property url currentUserIcon: ""
    property bool currentUserNeedsPassword: true

    property string sessionName: ""
    property bool busy: false
    property string errorText: ""
    property string infoText: ""
    property date now: new Date()
    property var activeField: null

    readonly property int panelWidth: Math.min(430, root.width - 48)
    readonly property int fieldWidth: Math.min(320, panelWidth - 96)
    readonly property bool anyMenuOpen: userMenu.opened || sessionMenu.opened || keyboardMenu.opened || powerMenu.opened

    readonly property string keyboardShortName: {
        var layouts = keyboard.layouts
        if (!layouts || layouts.length === undefined || layouts.length === 0)
            return ""
        var index = keyboard.currentLayout
        if (index < 0 || index >= layouts.length || !layouts[index])
            return ""
        return layouts[index].shortName
    }

    // O SDDM entrega um ícone genérico quando o usuário não tem avatar.
    // Nesse caso é mais bonito mostrar a inicial do nome.
    function isGenericFace(icon) {
        if (!icon)
            return true
        var value = icon.toString()
        return value.length === 0 || value.indexOf("/faces/.face.icon") !== -1
    }

    // ------------------------------------------------------------------ data
    Repeater {
        model: userModel

        delegate: Item {
            width: 0
            height: 0
            visible: false

            readonly property bool isCurrent: index === root.userIndex

            function refresh() {
                if (!isCurrent)
                    return
                root.currentUserName = model.name
                root.currentRealName = (model.realName && model.realName.length > 0) ? model.realName : model.name
                root.currentUserIcon = root.isGenericFace(model.icon) ? "" : model.icon
                root.currentUserNeedsPassword = model.needsPassword
            }

            Component.onCompleted: refresh()
            onIsCurrentChanged: refresh()
        }
    }

    Repeater {
        model: sessionModel

        delegate: Item {
            width: 0
            height: 0
            visible: false

            readonly property bool isCurrent: index === root.sessionIndex

            function refresh() {
                if (isCurrent)
                    root.sessionName = model.name
            }

            Component.onCompleted: refresh()
            onIsCurrentChanged: refresh()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Timer {
        id: busyTimeout
        interval: 6000
        repeat: false
        onTriggered: root.busy = false
    }

    // ------------------------------------------------------------------ background
    Rectangle {
        anchors.fill: parent
        color: root.fallbackBackground
    }

    Image {
        anchors.fill: parent
        source: root.backgroundSource
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        visible: status === Image.Ready
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.30) }
            GradientStop { position: 0.45; color: Qt.rgba(0, 0, 0, 0.10) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.42) }
        }
    }

    // ------------------------------------------------------------------ clock
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Math.max(26, Math.round(root.height * 0.05))
        spacing: 0

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.now.toLocaleTimeString(root.themeLocale, "HH:mm")
            color: "#ffffff"
            font.family: root.fontFamily
            font.pixelSize: 42
            font.weight: Font.Light
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.now.toLocaleDateString(root.themeLocale, root.dateFormat)
            color: Qt.rgba(1, 1, 1, 0.7)
            font.family: root.fontFamily
            font.pixelSize: 15
        }
    }

    // ------------------------------------------------------------------ login card
    Item {
        id: panel

        width: root.panelWidth
        height: panelColumn.height + 64
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: virtualKeyboard.visible ? -76 : 28

        Rectangle {
            anchors.fill: parent
            anchors.margins: -14
            radius: 42
            color: Qt.rgba(0, 0, 0, 0.16)
        }

        Rectangle {
            anchors.fill: parent
            radius: 28
            color: Qt.rgba(0.055, 0.055, 0.075, 0.72)
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.08)
        }

        Column {
            id: panelColumn

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 32
            spacing: 11

            Avatar {
                id: userAvatar
                anchors.horizontalCenter: parent.horizontalCenter
                size: 96
                source: root.currentUserIcon
                name: root.currentRealName.length > 0 ? root.currentRealName : root.currentUserName
                fontFamily: root.fontFamily

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (userModel.count > 0) root.toggleMenu(userMenu)
                }
            }

            Text {
                width: parent.width - 48
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.currentRealName.length > 0
                    ? root.currentRealName
                    : (root.currentUserName.length > 0 ? root.currentUserName : qsTr("Welcome"))
                color: "#ffffff"
                font.family: root.fontFamily
                font.pixelSize: 21
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (userModel.count > 0) root.toggleMenu(userMenu)
                }
            }

            Text {
                width: parent.width - 48
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.currentUserName.length > 0
                text: "@" + root.currentUserName
                color: Qt.rgba(1, 1, 1, 0.5)
                font.family: root.fontFamily
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            Item {
                width: 1
                height: 5
            }

            InputField {
                id: userNameField
                width: root.fieldWidth
                anchors.horizontalCenter: parent.horizontalCenter
                visible: userModel.count === 0
                placeholder: qsTr("Username")
                passwordMode: false
                fontFamily: root.fontFamily
                accentColor: root.accentColor
                onFocused: root.activeField = userNameField
                onAccepted: passwordField.forceInputFocus()
            }

            Item {
                id: fieldRow

                width: parent.width
                height: 48
                property real shakeOffset: 0
                transform: Translate { x: fieldRow.shakeOffset }

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    InputField {
                        id: passwordField
                        width: root.fieldWidth
                        height: 48
                        placeholder: qsTr("Password")
                        passwordMode: true
                        hasError: root.errorText.length > 0
                        fontFamily: root.fontFamily
                        accentColor: root.accentColor

                        onAccepted: root.doLogin()
                        onEdited: {
                            root.errorText = ""
                            root.infoText = ""
                        }
                        onFocused: root.activeField = passwordField
                    }

                    PrimaryButton {
                        id: loginButton
                        width: 48
                        height: 48
                        accentColor: root.accentColor
                        busy: root.busy
                        enabled: (passwordField.text.length > 0 || !root.currentUserNeedsPassword) && !root.busy
                        onClicked: root.doLogin()
                    }
                }
            }

            Text {
                width: parent.width - 64
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.errorText.length > 0
                text: root.errorText
                color: "#ff8a80"
                font.family: root.fontFamily
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width - 64
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.infoText.length > 0
                text: root.infoText
                color: Qt.rgba(0.65, 0.8, 1.0, 1.0)
                font.family: root.fontFamily
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: keyboard.capsLock
                spacing: 6

                Icon {
                    name: "alert-warning"
                    size: 14
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: qsTr("Caps Lock is on")
                    color: Qt.rgba(1, 0.82, 0.4, 0.95)
                    font.family: root.fontFamily
                    font.pixelSize: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    // ------------------------------------------------------------------ bottom bar
    Item {
        id: bottomBar

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        anchors.bottomMargin: 20
        height: 40

        Row {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            height: 38
            spacing: 8

            PillButton {
                id: keyboardButton
                anchors.verticalCenter: parent.verticalCenter
                visible: keyboard.enabled && keyboard.layouts && keyboard.layouts.length > 0
                icon: "keyboard"
                text: root.keyboardShortName
                fontFamily: root.fontFamily
                onClicked: root.toggleMenu(keyboardMenu)
            }

            Rectangle {
                id: numLockChip
                anchors.verticalCenter: parent.verticalCenter
                visible: keyboard.numLock === true
                width: numLockContent.implicitWidth + 20
                height: 30
                radius: 15
                color: Qt.rgba(1, 1, 1, 0.10)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.09)

                Row {
                    id: numLockContent
                    anchors.centerIn: parent
                    spacing: 5

                    Icon {
                        name: "numlock"
                        size: 13
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Num"
                        color: Qt.rgba(1, 1, 1, 0.85)
                        font.family: root.fontFamily
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            IconButton {
                id: virtualKeyboardButton
                anchors.verticalCenter: parent.verticalCenter
                icon: "touch"
                iconSize: 20
                padding: 9
                active: virtualKeyboard.visible
                Accessible.role: Accessible.Button
                Accessible.name: qsTr("On-screen keyboard")
                onClicked: root.toggleVirtualKeyboard()
            }
        }

        Row {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 6

            PillButton {
                id: sessionButton
                visible: sessionModel.count > 0
                icon: "monitor"
                text: root.sessionName.length > 0 ? root.sessionName : qsTr("Session")
                fontFamily: root.fontFamily
                onClicked: root.toggleMenu(sessionMenu)
            }

            IconButton {
                id: powerButton
                visible: sddm.canPowerOff || sddm.canReboot || sddm.canSuspend || sddm.canHibernate
                icon: "power"
                iconSize: 20
                padding: 9
                onClicked: root.toggleMenu(powerMenu)
            }
        }
    }

    // ------------------------------------------------------------------ overlay
    Rectangle {
        id: overlay

        anchors.fill: parent
        color: "#55000000"
        opacity: root.anyMenuOpen ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.closeMenus()
        }
    }

    // ------------------------------------------------------------------ virtual keyboard
    VirtualKeyboard {
        id: virtualKeyboard

        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: bottomBar.top
        anchors.bottomMargin: 16
        scale: Math.min(1, (root.width - 48) / implicitWidth)
        transformOrigin: Item.Bottom

        target: root.activeField
        fontFamily: root.fontFamily
        accentColor: root.accentColor

        onAccepted: {
            if (root.activeField)
                root.activeField.accepted()
        }
    }

    // ------------------------------------------------------------------ user menu
    MenuSurface {
        id: userMenu
        width: 300
        x: Math.round((root.width - width) / 2)
        y: (panel.y + panel.height + 12 + height <= root.height - 24)
            ? panel.y + panel.height + 12
            : Math.max(24, panel.y - height - 12)
        origin: Item.Top

        Repeater {
            model: userModel

            delegate: MenuRow {
                label: (model.realName && model.realName.length > 0) ? model.realName : model.name
                sublabel: "@" + model.name
                avatarSource: root.isGenericFace(model.icon) ? "" : model.icon
                showAvatar: true
                selected: index === root.userIndex
                fontFamily: root.fontFamily
                onClicked: root.selectUser(index)
            }
        }
    }

    // ------------------------------------------------------------------ session menu
    MenuSurface {
        id: sessionMenu
        width: 280
        x: Math.max(12, root.width - width - 24)
        y: root.height - bottomBar.height - 28 - height
        origin: Item.Bottom

        Repeater {
            model: sessionModel

            delegate: MenuRow {
                label: model.name
                sublabel: model.comment
                icon: "monitor"
                selected: index === root.sessionIndex
                fontFamily: root.fontFamily
                onClicked: root.selectSession(index)
            }
        }
    }

    // ------------------------------------------------------------------ keyboard menu
    MenuSurface {
        id: keyboardMenu
        width: 240
        x: 24
        y: root.height - bottomBar.height - 28 - height
        origin: Item.Bottom

        Repeater {
            model: keyboard.layouts

            delegate: MenuRow {
                label: modelData.shortName
                sublabel: modelData.longName
                icon: "keyboard"
                selected: index === keyboard.currentLayout
                fontFamily: root.fontFamily
                onClicked: root.selectLayout(index)
            }
        }
    }

    // ------------------------------------------------------------------ power menu
    property var powerItems: {
        var items = []
        if (sddm.canSuspend)
            items.push({ "label": qsTr("Suspend"), "icon": "suspend", "action": "suspend" })
        if (sddm.canHibernate)
            items.push({ "label": qsTr("Hibernate"), "icon": "hibernate", "action": "hibernate" })
        if (sddm.canReboot)
            items.push({ "label": qsTr("Restart"), "icon": "restart", "action": "reboot" })
        if (sddm.canPowerOff)
            items.push({ "label": qsTr("Power off"), "icon": "power", "action": "powerOff" })
        return items
    }

    MenuSurface {
        id: powerMenu
        width: 220
        x: Math.max(12, root.width - width - 24)
        y: root.height - bottomBar.height - 28 - height
        origin: Item.Bottom

        Repeater {
            model: root.powerItems

            delegate: MenuRow {
                label: modelData.label
                icon: modelData.icon
                fontFamily: root.fontFamily
                onClicked: root.doPowerAction(modelData.action)
            }
        }
    }

    // ------------------------------------------------------------------ actions
    function closeMenus() {
        userMenu.opened = false
        sessionMenu.opened = false
        keyboardMenu.opened = false
        powerMenu.opened = false
    }

    function toggleMenu(menu) {
        var wasOpen = menu.opened
        closeMenus()
        if (!wasOpen)
            menu.opened = true
    }

    function toggleVirtualKeyboard() {
        closeMenus()
        virtualKeyboard.visible = !virtualKeyboard.visible
        if (virtualKeyboard.visible && !root.activeField)
            root.activeField = passwordField
        if (root.activeField)
            root.activeField.forceInputFocus()
    }

    function selectUser(index) {
        root.userIndex = index
        root.errorText = ""
        root.infoText = ""
        passwordField.text = ""
        passwordField.reveal = false
        closeMenus()
        passwordField.forceInputFocus()
    }

    function selectSession(index) {
        root.sessionIndex = index
        root.errorText = ""
        root.infoText = ""
        closeMenus()
        passwordField.forceInputFocus()
    }

    function selectLayout(index) {
        keyboard.currentLayout = index
        root.errorText = ""
        root.infoText = ""
        closeMenus()
        passwordField.forceInputFocus()
    }

    function doPowerAction(action) {
        closeMenus()
        if (action === "suspend")
            sddm.suspend()
        else if (action === "hibernate")
            sddm.hibernate()
        else if (action === "reboot")
            sddm.reboot()
        else if (action === "powerOff")
            sddm.powerOff()
    }

    function doLogin() {
        if (root.busy)
            return

        var user = userModel.count > 0 ? root.currentUserName : userNameField.text

        if (user.length === 0) {
            if (userModel.count === 0)
                userNameField.forceInputFocus()
            return
        }

        if (passwordField.text.length === 0 && root.currentUserNeedsPassword) {
            passwordField.forceInputFocus()
            return
        }

        root.errorText = ""
        root.infoText = ""
        root.busy = true
        busyTimeout.restart()

        sddm.login(user, passwordField.text, root.sessionIndex)

        passwordField.text = ""
        passwordField.reveal = false
    }

    // ------------------------------------------------------------------ signals
    Connections {
        target: sddm

        function onLoginFailed() {
            busyTimeout.stop()
            root.busy = false
            root.errorText = qsTr("Incorrect password. Please try again.")
            shakeAnimation.restart()
            passwordField.text = ""
            passwordField.forceInputFocus()
        }

        function onLoginSucceeded() {
            busyTimeout.stop()
            root.busy = false
        }

        function onInformationMessage(message) {
            busyTimeout.stop()
            root.busy = false
            root.infoText = message
            passwordField.forceInputFocus()
        }
    }

    SequentialAnimation {
        id: shakeAnimation

        NumberAnimation { target: fieldRow; property: "shakeOffset"; to: -10; duration: 50 }
        NumberAnimation { target: fieldRow; property: "shakeOffset"; to: 10; duration: 70 }
        NumberAnimation { target: fieldRow; property: "shakeOffset"; to: -6; duration: 60 }
        NumberAnimation { target: fieldRow; property: "shakeOffset"; to: 6; duration: 60 }
        NumberAnimation { target: fieldRow; property: "shakeOffset"; to: 0; duration: 50 }
    }

    Shortcut {
        sequence: "Esc"
        onActivated: {
            root.closeMenus()
            virtualKeyboard.visible = false
        }
    }

    Component.onCompleted: {
        root.activeField = passwordField
        Qt.callLater(function() {
            passwordField.forceInputFocus()
        })
    }
}
