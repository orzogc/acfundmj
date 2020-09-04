import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls 1.4
import Qt.labs.platform 1.1 as Platform

Dialog {
    id: configDialog
    width: 400
    height: 600
    title: "设置"
    standardButtons: StandardButton.Close
    modality: Qt.NonModal

    Column {
        spacing: 5
        anchors.fill: parent
        topPadding: 20

        Row {
            spacing: 10
            leftPadding: 20

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "弹幕姬背景颜色："
            }

            Button {
                text: "设置"
                onClicked: backgroundColor.open()
            }
        }

        Row {
            spacing: 10
            leftPadding: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "弹幕姬的字体："
            }
            Button {
                text: "设置"
                onClicked: generalFont.open()
            }
        }

        Row {
            spacing: 10
            leftPadding: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "弹幕里昵称的字体颜色："
            }
            Button {
                text: "设置"
                onClicked: generalUserColor.open()
            }
        }

        Row {
            spacing: 10
            leftPadding: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "弹幕其余部分的字体颜色："
            }
            Button {
                text: "设置"
                onClicked: generalOtherColor.open()
            }
        }

        Row {
            spacing: 10
            leftPadding: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "直播间信息的字体颜色："
            }
            Button {
                text: "设置"
                onClicked: infoColor.open()
            }
        }

        Row {
            spacing: 10
            leftPadding: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "守护徽章的字体颜色："
            }
            Button {
                text: "设置"
                onClicked: medalColor.open()
            }
        }

        Row {
            spacing: 10
            leftPadding: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "礼物弹幕高亮显示的背景颜色："
            }
            Button {
                text: "设置"
                onClicked: giftBackgroundColor.open()
            }
        }

        Row {
            spacing: 10
            leftPadding: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "礼物图片高度："
            }
            Rectangle {
                width: inputHeight.contentWidth < 30 ? 30 : inputHeight.contentWidth + 10
                height: inputHeight.contentHeight + 5

                TextInput {
                    id: inputHeight
                    anchors.fill: parent
                    anchors.margins: 2
                    validator: IntValidator {
                        bottom: 1
                        top: 1000
                    }
                    selectByMouse: true

                    Component.onCompleted: {
                        if (dmj.giftPicHeight > 0) {
                            insert(0, dmj.giftPicHeight)
                        }
                    }

                    onTextChanged: dmj.giftPicHeight = text
                }
            }
        }

        Row {
            spacing: 10
            leftPadding: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "窗口边框颜色："
            }
            Button {
                text: "设置"
                onClicked: borderColor.open()
            }
        }
    }

    Component.onCompleted: {
        backgroundColor.color = dmj.color
        generalFont.font = dmj.generalFont
        generalUserColor.color = dmj.generalUserColor
        generalOtherColor.color = dmj.generalOtherColor
        infoColor.color = dmj.infoColor
        medalColor.color = dmj.medalColor
        giftBackgroundColor.color = dmj.giftBackgroundColor
        borderColor.color = dmj.borderColor
    }

    Platform.ColorDialog {
        id: backgroundColor
        title: "选择弹幕姬背景颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
        modality: Qt.NonModal
        property bool firstRun: true
        onCurrentColorChanged: {
            // 避免currentColor会忽略alpha通道的bug
            if (firstRun) {
                firstRun = false
            } else {
                dmj.color = currentColor
            }
        }
    }

    Platform.FontDialog {
        id: generalFont
        title: "选择弹幕姬的字体"
        options: Platform.FontDialog.NoButtons
        modality: Qt.NonModal
        onCurrentFontChanged: dmj.generalFont = currentFont
    }

    Platform.ColorDialog {
        id: generalUserColor
        title: "选择弹幕里昵称的字体颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
        modality: Qt.NonModal
        property bool firstRun: true
        onCurrentColorChanged: {
            if (firstRun) {
                firstRun = false
            } else {
                dmj.generalUserColor = currentColor
            }
        }
    }

    Platform.ColorDialog {
        id: generalOtherColor
        title: "选择弹幕其余部分的字体颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
        modality: Qt.NonModal
        property bool firstRun: true
        onCurrentColorChanged: {
            if (firstRun) {
                firstRun = false
            } else {
                dmj.generalOtherColor = currentColor
            }
        }
    }

    Platform.ColorDialog {
        id: infoColor
        title: "选择直播间信息的字体颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
        modality: Qt.NonModal
        property bool firstRun: true
        onCurrentColorChanged: {
            if (firstRun) {
                firstRun = false
            } else {
                dmj.infoColor = currentColor
            }
        }
    }

    Platform.ColorDialog {
        id: medalColor
        title: "选择守护徽章的字体颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
        modality: Qt.NonModal
        property bool firstRun: true
        onCurrentColorChanged: {
            if (firstRun) {
                firstRun = false
            } else {
                dmj.medalColor = currentColor
            }
        }
    }

    Platform.ColorDialog {
        id: giftBackgroundColor
        title: "选择礼物弹幕高亮显示的背景颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
        modality: Qt.NonModal
        property bool firstRun: true
        onCurrentColorChanged: {
            if (firstRun) {
                firstRun = false
            } else {
                dmj.giftBackgroundColor = currentColor
            }
        }
    }

    Platform.ColorDialog {
        id: borderColor
        title: "选择窗口边框颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
        modality: Qt.NonModal
        property bool firstRun: true
        onCurrentColorChanged: {
            if (firstRun) {
                firstRun = false
            } else {
                dmj.borderColor = currentColor
            }
        }
    }
}
