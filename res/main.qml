import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0
import "settings"
import BackEnd 1.0 as BackEnd

Window {
    id: dmj
    visible: true
    width: 400
    height: 800
    minimumWidth: 100
    minimumHeight: 100
    color: "#50808080"
    flags: Qt.Window | Qt.FramelessWindowHint

    property bool alwaysOnTop: false
    property bool mergeGift: true
    property bool highlightGift: true
    property bool banLike: false
    property bool banEnter: false
    property bool banFollow: false
    property bool banGift: false
    property bool showPic: true
    property bool autoScroll: true

    property var generalFont: defaultText.font
    property var generalUserColor: "#0000ff"
    property var generalOtherColor: "#000000"
    property var giftBackgroundColor: "#ff0000"

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
        property alias autoScroll: dmj.autoScroll
        property alias uid: setUID.uid
        property alias generalFont: dmj.generalFont
        property alias generalUserColor: dmj.generalUserColor
        property alias generalOtherColor: dmj.generalOtherColor
        property alias giftBackgroundColor: dmj.giftBackgroundColor
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
                danmuModel.insert(0, {bgColor: false,
                                      time: 0, uid: 0, gid: 0,
                                      danmuUser: danmu,
                                      danmuOther: "", image: "", imageHeight: 0,
                                      animation: false})
                return
            }
            switch(data.Type) {
            case 0:
                danmuModel.insert(comboNum, {bgColor: false,
                                      time: data.SendTime,
                                      uid: data.UserID,
                                      gid: 0,
                                      danmuUser: data.Nickname,
                                      danmuOther: "：" + data.Comment,
                                      image: "", imageHeight: 0,
                                      animation: false})
                break
            case 1:
                if (!banLike) {
                    danmuModel.insert(comboNum, {bgColor: false,
                                          time: data.SendTime,
                                          uid: data.UserID,
                                          gid: 0,
                                          danmuUser: data.Nickname,
                                          danmuOther: " 点赞了",
                                          image: dmj.lovePic,
                                          imageHeight: 24,
                                          animation: false})
                }
                break
            case 2:
                if (!banEnter) {
                    danmuModel.insert(comboNum, {bgColor: false,
                                          time: data.SendTime,
                                          uid: data.UserID,
                                          gid: 0,
                                          danmuUser: data.Nickname,
                                          danmuOther: " 进入直播间",
                                          image: "", imageHeight: 0,
                                          animation: false})
                }
                break
            case 3:
                if (!banFollow) {
                    danmuModel.insert(comboNum, {bgColor: false,
                                          time: data.SendTime,
                                          uid: data.UserID,
                                          gid: 0,
                                          danmuUser: data.Nickname,
                                          danmuOther: " 关注了主播",
                                          image: "", imageHeight: 0,
                                          animation: false})
                }
                break
            case 4:
                if (!banGift) {
                    danmuModel.insert(comboNum, {bgColor: true,
                                          time: data.SendTime,
                                          uid: data.UserID,
                                          gid: 0,
                                          danmuUser: data.Nickname,
                                          danmuOther: " 送出 " + data.BananaCount + " 个香蕉",
                                          image: "", imageHeight: 0,
                                          animation: false})
                }
                break
            case 5:
                if (!banGift) {
                    if (mergeGift && data.Gift.Combo > 1) {
                        if (comboGift.has(data.UserID)) {
                            var giftInfo = comboGift.get(data.UserID)
                            if (data.Gift.Combo > giftInfo[0]) {
                                timers[giftInfo[1]].restart()
                                danmuModel.setProperty(giftInfo[1], "animation", false)
                                danmuModel.set(giftInfo[1], {bgColor: true,
                                                   time: data.SendTime,
                                                   uid: data.UserID,
                                                   gid: data.Gift.ID,
                                                   danmuUser: data.Nickname,
                                                   danmuOther: " 送出 "+ (data.Gift.Count * data.Gift.Combo) + " 个" + data.Gift.Name,
                                                   image: data.Gift.SmallPngPic,
                                                   imageHeight: 48,
                                                   animation: true})
                                comboGift.set(data.UserID, [data.Gift.Combo, giftInfo[1]])
                                break
                            }
                        } else {
                            comboGift.set(data.UserID, [data.Gift.Combo, comboNum])
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
                            var timer = Qt.createQmlObject(`import QtQuick 2.15;Timer{id:danmuTimer;interval:3500;property var userID;property var index;onTriggered:{danmuModel.move(index,backEnd.comboNum-1,1);backEnd.comboNum--;backEnd.comboGift.delete(userID);backEnd.timers.splice(index,1);for(let [u,c] of backEnd.comboGift){if(c[1]>index){backEnd.comboGift.set(u,[c[0],c[1]-1])}}for(var i in backEnd.timers){if(i>=index){backEnd.timers[i].index=i}}danmuTimer.destroy();}}`,
                                                           backEnd, "")
                            timer.userID = data.UserID
                            timer.index = comboNum
                            timer.start()
                            timers.push(timer)
                            danmuModel.insert(comboNum, {bgColor: true,
                                                  time: data.SendTime,
                                                  uid: data.UserID,
                                                  gid: data.Gift.ID,
                                                  danmuUser: data.Nickname,
                                                  danmuOther: " 送出 "+ (data.Gift.Count * data.Gift.Combo) + " 个" + data.Gift.Name,
                                                  image: data.Gift.SmallPngPic,
                                                  imageHeight: 48,
                                                  animation: true})
                            comboNum ++
                            break
                        }
                    } else {
                        danmuModel.insert(comboNum, {bgColor: true,
                                              time: data.SendTime,
                                              uid: data.UserID,
                                              gid: data.Gift.ID,
                                              danmuUser: data.Nickname,
                                              danmuOther: " 送出 "+ (data.Gift.Count * data.Gift.Combo) + " 个" + data.Gift.Name,
                                              image: data.Gift.SmallPngPic,
                                              imageHeight: 48,
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
        width: parent.width
        height: parent.height - 20
        anchors.centerIn: parent
        verticalLayoutDirection: ListView.BottomToTop
        spacing: 3
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
                color: highlightGift && bgColor ? dmj.giftBackgroundColor : "#00000000"
                radius: 20

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

            Text {
                id: danmuText
                width: parent.width
                leftPadding: 15
                rightPadding: 15
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                font: generalFont

                property string imgstyle: `<style>img{vertical-align:bottom;}`
                property string userStyle: `user{color:${dmj.generalUserColor};}`
                property string otherStyle: `other{color:${dmj.generalOtherColor};}</style>`
                property string imageStr: image === "" || !dmj.showPic ? "" : `<img src="` + image + `" height="` + imageHeight +`">`

                text: imgstyle + userStyle + otherStyle + `<user>` + danmuUser + `</user><other>` + danmuOther +`</other>` + imageStr
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        property var clickPos
        onPressed: clickPos = Qt.point(mouse.x, mouse.y)
        onPositionChanged: {
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            dmj.x += delta.x
            dmj.y += delta.y
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: rightClickMenu.popup()

        Menu {
            id: rightClickMenu
            MenuItem {
                text: "输入直播间uid"
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
                text: "屏蔽点赞信息"
                onToggled: banLike = checked
            }
            MenuItem {
                checkable: true
                checked: banEnter
                text: "屏蔽进场信息"
                onToggled: banEnter = checked
            }
            MenuItem {
                checkable: true
                checked: banFollow
                text: "屏蔽关注信息"
                onToggled: banFollow = checked
            }
            MenuItem {
                checkable: true
                checked: banGift
                text: "屏蔽礼物信息"
                onToggled: banGift = checked
            }
            MenuItem {
                checkable: true
                checked: showPic
                text: "显示点赞爱心和礼物图片"
                onToggled: showPic = checked
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

    onAlwaysOnTopChanged: {
        if (alwaysOnTop) {
            dmj.flags |= Qt.WindowStaysOnTopHint
        } else {
            dmj.flags &= ~Qt.WindowStaysOnTopHint
        }
    }

    Text {
        id: hintText
        anchors.centerIn: parent
        font.pointSize: 20
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

    Resize {
        anchors.fill: parent
        size: 5
    }

    property string lovePic: `data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iMjRweCIgaGVpZ2h0PSIyNHB4IiB2aWV3Qm94PSIwIDAgMjQgMjQiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDY0ICg5MzUzNykgLSBodHRwczovL3NrZXRjaC5jb20gLS0+CiAgICA8dGl0bGU+aGFydDwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxkZWZzPgogICAgICAgIDxsaW5lYXJHcmFkaWVudCB4MT0iMTcuMzEzMjk4MSUiIHkxPSI5LjY1MjEyMDI2JSIgeDI9IjcyLjgzODEwNSUiIHkyPSI3Ny44NTY5Nzk3JSIgaWQ9ImxpbmVhckdyYWRpZW50LTEiPgogICAgICAgICAgICA8c3RvcCBzdG9wLWNvbG9yPSIjRkY4Mzk1IiBvZmZzZXQ9IjAlIj48L3N0b3A+CiAgICAgICAgICAgIDxzdG9wIHN0b3AtY29sb3I9IiNGRDRDNUMiIG9mZnNldD0iMTAwJSI+PC9zdG9wPgogICAgICAgIDwvbGluZWFyR3JhZGllbnQ+CiAgICA8L2RlZnM+CiAgICA8ZyBpZD0iaGFydCIgc3Ryb2tlPSJub25lIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCI+CiAgICAgICAgPGcgaWQ9IlBhZ2UtMS1Db3B5Ij4KICAgICAgICAgICAgPGc+CiAgICAgICAgICAgICAgICA8cmVjdCBpZD0iTWFzayIgZmlsbD0iI0Q4RDhEOCIgb3BhY2l0eT0iMCIgeD0iLTYuMjUyNzc2MDdlLTEzIiB5PSIwIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiPjwvcmVjdD4KICAgICAgICAgICAgICAgIDxwYXRoIGQ9Ik0xNi4wNSw0LjI1IEMxNC41NTc2Nzg5LDQuMjUgMTMuMTI1ODcwNSw0Ljk1Mjc3Mzc4IDExLjgwODgyMiw2LjA2MjAyNTQxIEMxMC44NzQxMjk1LDQuOTUyNzczNzggOS40NDIzMjExLDQuMjUgNy45NSw0LjI1IEM2LjYzNDMwNzM2LDQuMjUgNS40NTkxNTM3MSw0Ljc3MTY0MjA4IDQuNjEzMjA1OTIsNS42MjY1NTQxNCBDMy43NjYzMTgyOCw2LjQ4MjQxNiAzLjI1LDcuNjcxNDU0MjcgMy4yNSw5LjAwMjQ1MzcgQzMuMjUsMTEuOTk1NTI4NyA1LjY1MzA4NTQ5LDE0LjExMTk0MzYgOS4zNDY0NDUyOCwxNy40NTE1NzY3IEM5LjgzMDQ3ODIzLDE3Ljg4OTI1MiAxMC4zMzcwMjMzLDE4LjM0NzI4NTcgMTAuODYzOTA1LDE4LjgzMDEyMjcgTDEyLjMzNTg1MTMsMTkuNTQxODk2NSBMMTMuMTQwMDM2NSwxOC44MzU2ODIyIEMxMy42NjgyMTgsMTguMzUwNTMzNSAxNC4xNzk3Nzg4LDE3Ljg4NzEwNjUgMTQuNjY4MzM3OCwxNy40NDQ1MTkzIEMxOC4zNTMyNzc4LDE0LjEwNjMyMDIgMjAuNzUsMTEuOTkxNTQ2NyAyMC43NSw5LjAwMjQ1MzcgQzIwLjc1LDcuNjcxNDU0MjcgMjAuMjMzNjgxNyw2LjQ4MjQxNiAxOS4zODY3OTQxLDUuNjI2NTU0MTQgQzE4LjU0MDg0NjMsNC43NzE2NDIwOCAxNy4zNjU2OTI2LDQuMjUgMTYuMDUsNC4yNSBaIiBpZD0iTWFzayIgc3Ryb2tlPSIjMTgxNzFBIiBzdHJva2Utd2lkdGg9IjAuNSIgZmlsbD0idXJsKCNsaW5lYXJHcmFkaWVudC0xKSI+PC9wYXRoPgogICAgICAgICAgICAgICAgPGVsbGlwc2UgaWQ9Ik92YWwiIGZpbGw9IiNGRkZGRkYiIG9wYWNpdHk9IjAuNSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNi42NjY2NjcsIDYuODMzMzMzKSByb3RhdGUoNTEuMDAwMDAwKSB0cmFuc2xhdGUoLTYuNjY2NjY3LCAtNi44MzMzMzMpICIgY3g9IjYuNjY2NjY2NjciIGN5PSI2LjgzMzMzMzMzIiByeD0iMSIgcnk9IjEuMTY2NjY2NjciPjwvZWxsaXBzZT4KICAgICAgICAgICAgICAgIDxlbGxpcHNlIGlkPSJPdmFsLUNvcHktMiIgZmlsbD0iI0ZGRkZGRiIgb3BhY2l0eT0iMC4zMDA5NDQwMSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNS4wMDAwMDAsIDkuODMzMzMzKSByb3RhdGUoLTcuMDAwMDAwKSB0cmFuc2xhdGUoLTUuMDAwMDAwLCAtOS44MzMzMzMpICIgY3g9IjUiIGN5PSI5LjgzMzMzMzMzIiByeD0iMSIgcnk9IjEiPjwvZWxsaXBzZT4KICAgICAgICAgICAgPC9nPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+`
}
