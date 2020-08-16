import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls 1.4

Dialog {
    width: 300
    height: 150
    title: "设置"
    standardButtons: StandardButton.Ok | StandardButton.Cancel

    property int uid: 0

    onAccepted: {
        uid = inputUID.text
        if (uid > 0){
            if (backEnd.started) {
                backEnd.stop()
            }
            timer.start()
        }
    }

    Row {
        spacing: 10
        anchors.centerIn: parent

        Text {
            text: "请输入主播uid："
        }

        Rectangle {
            width: inputUID.contentWidth < 100 ? 100 : inputUID.contentWidth + 10
            height: inputUID.contentHeight + 5

            TextInput {
                id: inputUID
                anchors.fill: parent
                anchors.margins: 2
                focus: true
                validator: IntValidator {
                    bottom: 1
                }
                selectByMouse: true

                Component.onCompleted: {
                    if (uid > 0) {
                        insert(0, uid)
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton

                    onClicked: textMenu.popup()

                    Menu {
                        id: textMenu
                        MenuItem {
                            text: "复制"
                            onTriggered: inputUID.copy()
                        }
                        MenuItem {
                            text: "剪切"
                            onTriggered: inputUID.cut()
                        }
                        MenuItem {
                            text: "粘贴"
                            onTriggered: inputUID.paste()
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: timer
        interval: 500
        onTriggered: {
            danmuModel.clear()
            backEnd.comboNum = 0
            backEnd.comboGift.clear()
            for (var i in backEnd.timers) {
                backEnd.timers[i].stop()
                backEnd.timers[i].destroy()
            }
            backEnd.timers = []
            backEnd.start(uid)
            backEnd.started = true
            hintText.visible = false
        }
    }
}
