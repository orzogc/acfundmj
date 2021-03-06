import QtQuick 2.15

// 代码来自 https://github.com/sylwow/FramelessQmlWindow/blob/master/ResizingFrames.qml
Item {
    id: frame
    property Item content
    property int size: 5

    property point startMousePos
    property point startWindowPos
    property size startWindowSize

    function absoluteMousePos(mouseArea) {
        var windowAbs = mouseArea.mapToItem(null, mouseArea.mouseX, mouseArea.mouseY)
        return Qt.point(windowAbs.x + dmj.x, windowAbs.y + dmj.y)
    }

    MouseArea {
        id: resizeTopRight
        anchors{
            top: parent.top
            right: parent.right
        }
        height: size
        width: size
        hoverEnabled: true
        onHoveredChanged: cursorShape = ((containsMouse || pressed) ?  Qt.SizeBDiagCursor :  Qt.ArrowCursor)
        onPressed: {
            startMousePos = absoluteMousePos(this)
            startWindowPos = Qt.point(dmj.x, dmj.y)
            startWindowSize = Qt.size(dmj.width, dmj.height)
        }
        onMouseXChanged:{
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newWidth = Math.max(dmj.minimumWidth, startWindowSize.width + (abs.x - startMousePos.x))
                dmj.setGeometry(dmj.x, dmj.y, newWidth, dmj.height)
            }
        }
        onMouseYChanged: {
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newHeigh = Math.max(dmj.minimumHeight, startWindowSize.height - (abs.y - startMousePos.y))
                var newY = startWindowPos.y - (newHeigh - startWindowSize.height)
                dmj.setGeometry(dmj.x, newY, dmj.width, newHeigh)
            }
        }
    }

    MouseArea {
        id: resizeTopLeft
        anchors{
            top: parent.top
            left: parent.left
        }
        height: size
        width: size
        hoverEnabled: true
        onHoveredChanged: cursorShape = ((containsMouse || pressed) ?  Qt.SizeFDiagCursor :  Qt.ArrowCursor)
        onPressed: {
            startMousePos = absoluteMousePos(this)
            startWindowPos = Qt.point(dmj.x, dmj.y)
            startWindowSize = Qt.size(dmj.width, dmj.height)
        }
        onMouseXChanged:{
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newWidth = Math.max(dmj.minimumWidth, startWindowSize.width - (abs.x - startMousePos.x))
                var newX = startWindowPos.x - (newWidth - startWindowSize.width)
                dmj.setGeometry(newX, dmj.y, newWidth, dmj.height)
            }
        }
        onMouseYChanged: {
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newHeigh = Math.max(dmj.minimumHeight, startWindowSize.height - (abs.y - startMousePos.y))
                var newY = startWindowPos.y - (newHeigh - startWindowSize.height)
                dmj.setGeometry(dmj.x, newY, dmj.width, newHeigh)
            }
        }
    }

    MouseArea {
        id: resizeTop
        anchors{
            top: parent.top
            right: resizeTopRight.left
            left: resizeTopLeft.right
        }
        height: size
        hoverEnabled: true
        onHoveredChanged: cursorShape = ((containsMouse || pressed) ?  Qt.SizeVerCursor :  Qt.ArrowCursor)
        onPressed: {
            startMousePos = absoluteMousePos(this)
            startWindowPos = Qt.point(dmj.x, dmj.y)
            startWindowSize = Qt.size(dmj.width, dmj.height)
        }
        onMouseYChanged: {
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newHeigh = Math.max(dmj.minimumHeight, startWindowSize.height - (abs.y - startMousePos.y))
                var newY = startWindowPos.y - (newHeigh - startWindowSize.height)
                dmj.setGeometry(dmj.x, newY, dmj.width, newHeigh)
            }
        }
    }

    MouseArea {
        id: resizeLeft
        anchors{
            top: resizeTopLeft.bottom
            left: parent.left
            bottom: resizeBottomLeft.top
        }
        width: size
        hoverEnabled: true
        onHoveredChanged: cursorShape = ((containsMouse || pressed) ?  Qt.SizeHorCursor :  Qt.ArrowCursor)
        onPressed: {
            startMousePos = absoluteMousePos(this)
            startWindowPos = Qt.point(dmj.x, dmj.y)
            startWindowSize = Qt.size(dmj.width, dmj.height)
        }
        onMouseXChanged:{
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newWidth = Math.max(dmj.minimumWidth, startWindowSize.width - (abs.x - startMousePos.x))
                var newX = startWindowPos.x - (newWidth - startWindowSize.width)
                dmj.setGeometry(newX, dmj.y, newWidth, dmj.height)
            }
        }
    }

    MouseArea {
        id: resizeBottomLeft
        anchors{
            bottom: parent.bottom
            left: parent.left
        }
        height: size
        width: size
        hoverEnabled: true
        onHoveredChanged: cursorShape = ((containsMouse || pressed) ?  Qt.SizeBDiagCursor :  Qt.ArrowCursor)
        onPressed: {
            startMousePos = absoluteMousePos(this)
            startWindowPos = Qt.point(dmj.x, dmj.y)
            startWindowSize = Qt.size(dmj.width, dmj.height)
        }
        onMouseXChanged:{
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newWidth = Math.max(dmj.minimumWidth, startWindowSize.width - (abs.x - startMousePos.x))
                var newX = startWindowPos.x - (newWidth - startWindowSize.width)
                dmj.setGeometry(newX, dmj.y, newWidth, dmj.height)
            }
        }
        onMouseYChanged: {
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newHeigh = Math.max(dmj.minimumHeight, startWindowSize.height + (abs.y - startMousePos.y))
                dmj.setGeometry(dmj.x, dmj.y, dmj.width, newHeigh)
            }
        }
    }

    MouseArea {
        id: resizeBottom
        anchors{
            left: resizeBottomLeft.right
            bottom: parent.bottom
            right: resizeBottomRight.left
        }
        height: size
        hoverEnabled: true
        onHoveredChanged: cursorShape = ((containsMouse || pressed) ?  Qt.SizeVerCursor :  Qt.ArrowCursor)
        onPressed: {
            startMousePos = absoluteMousePos(this)
            startWindowSize = Qt.size(dmj.width, dmj.height)
        }
        onMouseYChanged: {
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newHeigh = Math.max(dmj.minimumHeight, startWindowSize.height + (abs.y - startMousePos.y))
                dmj.setGeometry(dmj.x, dmj.y, dmj.width, newHeigh)
            }
        }
    }

    MouseArea {
        id: resizeBottomRight
        anchors{
            bottom: parent.bottom
            right: parent.right
        }
        height: size
        width: size
        hoverEnabled: true
        onHoveredChanged: cursorShape = ((containsMouse || pressed) ?  Qt.SizeFDiagCursor :  Qt.ArrowCursor)
        onPressed: {
            startMousePos = absoluteMousePos(this)
            startWindowSize = Qt.size(dmj.width, dmj.height)
        }
        onMouseXChanged:{
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newWidth = Math.max(dmj.minimumWidth, startWindowSize.width + (abs.x - startMousePos.x))
                dmj.setGeometry(dmj.x, dmj.y, newWidth, dmj.height)
            }
        }
        onMouseYChanged: {
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newHeigh = Math.max(dmj.minimumHeight, startWindowSize.height + (abs.y - startMousePos.y))
                dmj.setGeometry(dmj.x, dmj.y, dmj.width, newHeigh)
            }
        }
    }

    MouseArea {
        id: resizeRight
        anchors{
            top: resizeTopRight.bottom
            right: parent.right
            bottom: resizeBottomRight.top
        }
        width: size
        hoverEnabled: true
        onHoveredChanged: cursorShape = ((containsMouse || pressed) ?  Qt.SizeHorCursor :  Qt.ArrowCursor)
        onPressed: {
            startMousePos = absoluteMousePos(this)
            startWindowSize = Qt.size(dmj.width, dmj.height)
        }
        onMouseXChanged:{
            if(pressed) {
                var abs = absoluteMousePos(this)
                var newWidth = Math.max(dmj.minimumWidth, startWindowSize.width + (abs.x - startMousePos.x))
                dmj.setGeometry(dmj.x, dmj.y, newWidth, dmj.height)
            }
        }
    }
}
