import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0
import "frameless"
import "settings"
import BackEnd 1.0 as BackEnd

Window {
    id: dmj
    visible: true
    width: 400
    height: 800
    minimumWidth: 100
    minimumHeight: 100
    color: "#00000000"
    flags: alwaysOnTop ? (Qt.Window | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground | Qt.WindowStaysOnTopHint) : (Qt.Window | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground)

    property bool alwaysOnTop: false
    property bool mergeGift: true
    property bool highlightGift: true
    property bool banLike: false
    property bool banEnter: false
    property bool banFollow: false
    property bool banGift: false
    property bool showPic: true
    property bool showAvatar: true
    property bool autoScroll: true

    property var generalFont: defaultText.font
    property var generalUserColor: "#0000ff"
    property var generalOtherColor: "#000000"
    property var giftBackgroundColor: "#ff0000"
    property int giftPicHeight: 60

    Settings {
        category: "General"
        property alias width: dmj.width
        property alias height: dmj.height
        property alias color: dmj.color
        property alias alwaysOnTop: dmj.alwaysOnTop
        property alias mergeGift: dmj.mergeGift
        property alias banLike: dmj.banLike
        property alias banEnter: dmj.banEnter
        property alias banFollow: dmj.banFollow
        property alias banGift: dmj.banGift
        property alias showPic: dmj.showPic
        property alias showAvatar: dmj.showAvatar
        property alias autoScroll: dmj.autoScroll
        property alias uid: setUID.uid
        property alias generalFont: dmj.generalFont
        property alias generalUserColor: dmj.generalUserColor
        property alias generalOtherColor: dmj.generalOtherColor
        property alias giftBackgroundColor: dmj.giftBackgroundColor
        property alias giftPicHeight: dmj.giftPicHeight
    }

    BackEnd.Danmu {
        id: backEnd
        property bool started: false
        property int comboNum: 0
        property var comboGift: new Map()
        property var timers: []

        onNewDanmu: function(danmu) {
            var data
            try {
                data = JSON.parse(danmu)
            } catch (e) {
                for (var i in timers) {
                    timers[i].stop()
                    timers[i].destroy()
                }
                danmuModel.insert(0, {avatar: "",
                                      bgColor: false,
                                      time: 0, uid: 0, gid: 0,
                                      danmuUser: danmu,
                                      danmuOther: "", image: "",
                                      animation: false})
                return
            }
            switch(data.Type) {
            case 0:
                danmuModel.insert(comboNum, {avatar: data.Avatar,
                                      bgColor: false,
                                      time: data.SendTime,
                                      uid: data.UserID,
                                      gid: 0,
                                      danmuUser: data.Nickname,
                                      danmuOther: "：" + data.Comment,
                                      image: "",
                                      animation: false})
                break
            case 1:
                if (!banLike) {
                    danmuModel.insert(comboNum, {avatar: data.Avatar,
                                          bgColor: false,
                                          time: data.SendTime,
                                          uid: data.UserID,
                                          gid: 0,
                                          danmuUser: data.Nickname,
                                          danmuOther: " 点赞了 爱心",
                                          image: "",
                                          animation: false})
                }
                break
            case 2:
                if (!banEnter) {
                    danmuModel.insert(comboNum, {avatar: data.Avatar,
                                          bgColor: false,
                                          time: data.SendTime,
                                          uid: data.UserID,
                                          gid: 0,
                                          danmuUser: data.Nickname,
                                          danmuOther: " 进入直播间",
                                          image: "",
                                          animation: false})
                }
                break
            case 3:
                if (!banFollow) {
                    danmuModel.insert(comboNum, {avatar: data.Avatar,
                                          bgColor: false,
                                          time: data.SendTime,
                                          uid: data.UserID,
                                          gid: 0,
                                          danmuUser: data.Nickname,
                                          danmuOther: " 关注了主播",
                                          image: "",
                                          animation: false})
                }
                break
            case 4:
                if (!banGift) {
                    danmuModel.insert(comboNum, {avatar: "",
                                          bgColor: true,
                                          time: data.SendTime,
                                          uid: data.UserID,
                                          gid: 0,
                                          danmuUser: data.Nickname,
                                          danmuOther: " 送出 " + data.BananaCount + " 个香蕉",
                                          image: "",
                                          animation: false})
                }
                break
            case 5:
                if (!banGift) {
                    if (mergeGift && data.Gift.Combo > 1) {
                        // 出现连击
                        var giftInfo = comboGift.get(data.UserID)
                        if (comboGift.has(data.UserID) && giftInfo[2] === data.Gift.Count) {
                            // 已有连击记录
                            if (data.Gift.Combo > giftInfo[0]) {
                                timers[giftInfo[1]].restart()
                                danmuModel.setProperty(giftInfo[1], "animation", false)
                                danmuModel.set(giftInfo[1], {avatar: data.Avatar,
                                                   bgColor: true,
                                                   time: data.SendTime,
                                                   uid: data.UserID,
                                                   gid: data.Gift.ID,
                                                   danmuUser: data.Nickname,
                                                   danmuOther: " 送出 "+ (data.Gift.Count * data.Gift.Combo) + " 个" + data.Gift.Name,
                                                   image: data.Gift.SmallPngPic,
                                                   animation: true})
                                comboGift.set(data.UserID, [data.Gift.Combo, giftInfo[1], data.Gift.Count])
                                break
                            }
                        } else {
                            // 没有连击记录
                            comboGift.set(data.UserID, [data.Gift.Combo, comboNum, data.Gift.Count])
                            for (var n=0; n<danmuModel.count; n++) {
                                var model = danmuModel.get(n)
                                if ((data.SendTime - model.time) < 3500000000) {
                                    if (data.UserID === model.uid && data.Gift.ID === model.gid) {
                                        danmuModel.remove(n)
                                        break
                                    }
                                } else {
                                    break
                                }
                            }
                            var timer = Qt.createQmlObject(`import QtQuick 2.15;Timer{id:danmuTimer;interval:3500;property var userID;property var index;onTriggered:{danmuModel.move(index,backEnd.comboNum-1,1);backEnd.comboNum--;backEnd.comboGift.delete(userID);backEnd.timers.splice(index,1);for(let [u,c] of backEnd.comboGift){if(c[1]>index){backEnd.comboGift.set(u,[c[0],c[1]-1,c[2]])}}for(var i in backEnd.timers){if(i>=index){backEnd.timers[i].index=i}}danmuTimer.destroy();}}`,
                                                           backEnd, "")
                            timer.userID = data.UserID
                            timer.index = comboNum
                            timer.start()
                            timers.push(timer)
                            danmuModel.insert(comboNum, {avatar: data.Avatar,
                                                  bgColor: true,
                                                  time: data.SendTime,
                                                  uid: data.UserID,
                                                  gid: data.Gift.ID,
                                                  danmuUser: data.Nickname,
                                                  danmuOther: " 送出 "+ (data.Gift.Count * data.Gift.Combo) + " 个" + data.Gift.Name,
                                                  image: data.Gift.SmallPngPic,
                                                  animation: true})
                            comboNum ++
                            break
                        }
                    } else {
                        // 没有连击
                        danmuModel.insert(comboNum, {avatar: data.Avatar,
                                              bgColor: true,
                                              time: data.SendTime,
                                              uid: data.UserID,
                                              gid: data.Gift.ID,
                                              danmuUser: data.Nickname,
                                              danmuOther: " 送出 "+ (data.Gift.Count * data.Gift.Combo) + " 个" + data.Gift.Name,
                                              image: data.Gift.SmallPngPic,
                                              animation: false})
                    }
                }
                break
            default:
                console.log("未知的弹幕类型：" + data.Type)
                console.log(danmu)
            }
            if (autoScroll) {
                danmuList.positionViewAtBeginning()
            }
        }
    }

    ListView {
        id: danmuList
        anchors {
            top: topBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        verticalLayoutDirection: ListView.BottomToTop
        spacing: 5
        model: ListModel {
            id: danmuModel
        }

        delegate: Rectangle {
            width: danmuList.width
            height: danmuText.contentHeight
            color: "#00000000"

            Rectangle {
                id: backgroundRec
                anchors.fill: parent
                color: dmj.giftBackgroundColor
                radius: 20
                visible: highlightGift && bgColor

                SequentialAnimation {
                    running: animation

                    ScaleAnimator {
                        target: backgroundRec
                        from: 1
                        to: 0.9
                        duration: 100
                    }

                    ScaleAnimator {
                        target: backgroundRec
                        from: 0.9
                        to: 1
                        duration: 100
                    }
                }
            }

            Image {
                id: userAvatar
                width: hintText.contentHeight
                height: hintText.contentHeight
                anchors {
                    left: parent.left
                    leftMargin: 15
                    verticalCenter: parent.verticalCenter
                }
                source: avatar
                visible: dmj.showAvatar
            }

            Text {
                id: danmuText
                anchors {
                    top: parent.top
                    left: dmj.showAvatar ? userAvatar.right : parent.left
                    right: parent.right
                }
                leftPadding: dmj.showAvatar ? 5 : 15
                rightPadding: 15
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                font: generalFont

                property string imgstyle: `<style>img{vertical-align:bottom;}`
                property string userStyle: `user{color:${dmj.generalUserColor};}`
                property string otherStyle: `other{color:${dmj.generalOtherColor};}</style>`
                property string imageStr: image === "" || !dmj.showPic ? "" : `<img src="` + image + `" height="` + dmj.giftPicHeight + `">`

                text: imgstyle + userStyle + otherStyle + `<user>` + danmuUser + `</user><other>` + danmuOther +`</other>` + imageStr
            }
        }
    }

    MouseArea {
        anchors.fill: danmuList
        acceptedButtons: Qt.RightButton
        onClicked: rightClickMenu.popup()

        Menu {
            id: rightClickMenu
            MenuItem {
                text: "输入主播uid"
                onTriggered: setUID.open()
            }
            MenuItem {
                checkable: true
                checked: alwaysOnTop
                text: "总是在其他窗口上面"
                onToggled: alwaysOnTop = checked
            }
            MenuItem {
                checkable: true
                checked: mergeGift
                text: "合并显示礼物连击弹幕"
                onToggled: mergeGift = checked
            }
            MenuItem {
                checkable: true
                checked: highlightGift
                text: "高亮显示礼物弹幕"
                onToggled: highlightGift = checked
            }
            MenuItem {
                checkable: true
                checked: banLike
                text: "屏蔽点赞弹幕"
                onToggled: banLike = checked
            }
            MenuItem {
                checkable: true
                checked: banEnter
                text: "屏蔽进场弹幕"
                onToggled: banEnter = checked
            }
            MenuItem {
                checkable: true
                checked: banFollow
                text: "屏蔽关注弹幕"
                onToggled: banFollow = checked
            }
            MenuItem {
                checkable: true
                checked: banGift
                text: "屏蔽礼物弹幕"
                onToggled: banGift = checked
            }
            MenuItem {
                checkable: true
                checked: showPic
                text: "显示礼物图片"
                onToggled: showPic = checked
            }
            MenuItem {
                checkable: true
                checked: showAvatar
                text: "显示弹幕用户头像"
                onToggled: showAvatar = checked
            }
            MenuItem {
                checkable: true
                checked: autoScroll
                text: "自动滚动到最新弹幕位置"
                onToggled: autoScroll = checked
            }
            MenuItem {
                text: "更多设置"
                onTriggered: config.open()
            }
            MenuItem {
                text: "关闭弹幕姬"
                onTriggered: dmj.close()
            }
        }
    }

    Text {
        id: hintText
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font: generalFont
        text: "AcFun 弹幕姬"
    }

    Text {
        id: defaultText
        visible: false
        font.pointSize: 12
    }

    SetUID {
        id: setUID
    }

    Config {
        id: config
    }

    property point startMousePos
    property point startWindowPos
    property size startWindowSize

    function absoluteMousePos(mouseArea) {
        var windowAbs = mouseArea.mapToItem(null, mouseArea.mouseX, mouseArea.mouseY)
        return Qt.point(windowAbs.x + dmj.x, windowAbs.y + dmj.y)
    }

    TopBar {
        id: topBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 25
        color: "black"
        smooth: true
    }

    ResizingFrames {
        anchors.fill: parent
        size: 5
    }
}
