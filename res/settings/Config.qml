import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls 1.4

Dialog {
    id: configDialog
    width: 600
    height: 400
    title: "设置"
    standardButtons: StandardButton.Ok | StandardButton.Cancel

    TabView {
        anchors.fill: parent

        Tab {
            anchors.fill: parent
            title: "通用"

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

    onAccepted: {
        dmj.color = backgroundColor.color
        dmj.generalFont = generalFont.font
        dmj.generalUserColor = generalUserColor.color
        dmj.generalOtherColor = generalOtherColor.color
        dmj.giftBackgroundColor = giftBackgroundColor.color
    }

    ColorDialog {
        id: backgroundColor
        title: "选择弹幕姬背景颜色"
        showAlphaChannel: true
    }

    FontDialog {
        id: generalFont
        title: "选择弹幕字体"
    }

    ColorDialog {
        id: generalUserColor
        title: "选择弹幕里昵称的字体颜色"
        showAlphaChannel: true
    }

    ColorDialog {
        id: generalOtherColor
        title: "选择弹幕其余部分的字体颜色"
        showAlphaChannel: true
    }

    ColorDialog {
        id: giftBackgroundColor
        title: "选择礼物弹幕高亮显示的背景颜色"
        showAlphaChannel: true
    }
}
