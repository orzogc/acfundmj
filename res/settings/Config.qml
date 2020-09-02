import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls 1.4
import Qt.labs.platform 1.1 as Platform

Dialog {
    id: configDialog
    width: 600
    height: 400
    title: "设置"
    standardButtons: StandardButton.Close

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
                text: "弹幕字体："
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
    }

    Component.onCompleted: {
        backgroundColor.color = dmj.color
        generalFont.font = dmj.generalFont
        generalUserColor.color = dmj.generalUserColor
        generalOtherColor.color = dmj.generalOtherColor
        giftBackgroundColor.color = dmj.giftBackgroundColor
    }

    Platform.ColorDialog {
        id: backgroundColor
        title: "选择弹幕姬背景颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
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
        title: "选择弹幕字体"
        options: Platform.FontDialog.NoButtons
        onCurrentFontChanged: dmj.generalFont = currentFont
    }

    Platform.ColorDialog {
        id: generalUserColor
        title: "选择弹幕里昵称的字体颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
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
        id: giftBackgroundColor
        title: "选择礼物弹幕高亮显示的背景颜色"
        options: Platform.ColorDialog.ShowAlphaChannel | Platform.ColorDialog.NoButtons
        property bool firstRun: true
        onCurrentColorChanged: {
            if (firstRun) {
                firstRun = false
            } else {
                dmj.giftBackgroundColor = currentColor
            }
        }
    }
}
