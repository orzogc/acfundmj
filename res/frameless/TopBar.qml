import QtQuick 2.15
import QtQuick.Window 2.15

// 代码来自 https://github.com/sylwow/FramelessQmlWindow/blob/master/TopBar.qml
Rectangle {
    id: bar
    MouseArea {
        id: moveBarArea
        anchors{
            top: parent.top
            right: minimalize.left
            left: parent.left
            bottom: parent.bottom
        }

        onPressed: {
            startMousePos = absoluteMousePos(this)
            startWindowPos = Qt.point(dmj.x, dmj.y)
            startWindowSize = Qt.size(dmj.width, dmj.height)
        }
        onMouseXChanged:{
            if(pressed) {
                var abs = absoluteMousePos(this)
                dmj.x = startWindowPos.x + (abs.x - startMousePos.x)
            }
        }
        onMouseYChanged: {
            if(pressed) {
                var abs = absoluteMousePos(this)
                dmj.y = Math.max(Screen.virtualY, startWindowPos.y + (abs.y - startMousePos.y))
            }
        }
    }

    Rectangle {
        id: close
        color: "transparent"
        width: 45
        anchors{
            right: parent.right
            top: parent.top
        }
        height: parent.height
        Rectangle {
            color: "white"
            rotation: -45
            transformOrigin: Item.Center
            anchors.centerIn: parent
            height: parent.height - 7
            width: 2.5
        }
        Rectangle {
            color: "white"
            rotation: 45
            transformOrigin: Item.Center
            anchors.centerIn: parent
            height: parent.height - 7
            width: 2.5
        }
        MouseArea {
           anchors.fill: parent
           hoverEnabled: true;
           onEntered: parent.color = "tomato"
           onExited: parent.color = "transparent"
           onPressed: parent.opacity = 0.6
           onReleased: parent.opacity = 1
           onClicked: dmj.close()
        }
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
        Behavior on opacity {
            OpacityAnimator { duration: 100 }
        }
    }

    Rectangle {
        id: minimalize
        color: "transparent"
        anchors{
            right: close.left
            top: parent.top
        }
        height: parent.height
        width: 35
        Rectangle {
            anchors.centerIn: parent
            height: 2
            width: 15
            color: "white"
        }
        MouseArea {
           anchors.fill: parent
           hoverEnabled: true;
           onEntered: parent.color = "skyblue"
           onExited: parent.color = "transparent"
           onPressed: parent.opacity = 0.6
           onReleased: parent.opacity = 1
           onClicked: dmj.showMinimized()
        }
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
        Behavior on opacity {
            OpacityAnimator { duration: 100 }
        }
    }
}
