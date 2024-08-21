import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Control {
    id: root

    property var duration: 200
    property alias model: listview.model
    // property alias spacing: listview.spacing
    property alias orientation: listview.orientation

    implicitWidth: 1000
    implicitHeight: 600

    ListView {
        id: listview
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight - 20
        anchors.left: background.left
        anchors.top: background.top
        anchors.leftMargin: listview.spacing
        anchors.topMargin: 20

        layoutDirection: Qt.LeftToRight
        verticalLayoutDirection: Qt.LeftToRight
        boundsBehavior: Flickable.StopAtBounds
        interactive: true
        highlightFollowsCurrentItem: true

        spacing: 5


        highlight: Control {
            objectName: "highlight"
        }

        delegate: Rectangle {
            property bool isRemoving: false
            id: delegate
            objectName: "delegate"
            color: "blue"

            implicitWidth: 140
            implicitHeight: 60

            ListView.onRemove: {
                isRemoving = true
                removeAnimation.start()
            }

            SequentialAnimation {
                id: removeAnimation
                PropertyAction { target: delegate; property: "ListView.delayRemove"; value: true }
                NumberAnimation {
                    target: delegate
                    property: "x"
                    to: {
                        var item = listview.itemAtIndex(listview.model.count - 1)
                        return item?.x + item?.implicitWidth - delegate.implicitWidth
                    }
                    duration: root.duration
                }
                PropertyAction { target: delegate; property: "ListView.delayRemove"; value: false }
            }
        }

        add: Transition {
            id: addTrans
            NumberAnimation {
                property:"x"
                from: {
                    var item = listview.itemAtIndex(listview.model.lastSize - 1)
                    return item?.x + item?.implicitWidth - addTrans.ViewTransition.item?.implicitWidth
                }
                duration: root.duration
            }
        }
    }


    Rectangle {
        id: background
        z: listview.z - 1
        anchors.centerIn: parent

        implicitWidth: getWidth(true)
        implicitHeight: getHeight(true) + 20

        color: "red"

        Behavior on implicitWidth {
            enabled: root.orientation === ListView.Horizontal
            NumberAnimation { duration: root.duration }
        }

        Behavior on implicitHeight {
            enabled: root.orientation === ListView.Vertical
            NumberAnimation { duration: root.duration }
        }
    }

    function getWidth(removing) {
        let width = 0
        for (let child of listview.contentItem.visibleChildren) {
            if (child.objectName === "highlight"|| (removing && child.isRemoving))
                continue
            if (listview.orientation === ListView.Horizontal) {
                width += (child.implicitWidth + listview.spacing)
            } else {
                width = Math.max(width, child.implicitWidth)
            }
        }

        width += 2 * listview.spacing
        return width
    }

    function getHeight(removing) {
        let height = 0
        for (let child of listview.contentItem.visibleChildren) {
            if (child.objectName === "highlight"|| (removing && child.isRemoving))
                continue
            if (listview.orientation === ListView.Vertical) {
                height += (child.implicitHeight + listview.spacing)
            } else {
                height = Math.max(height, child.implicitHeight)
            }
        }
        return height + listview.spacing
    }
}
