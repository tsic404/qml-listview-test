import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Control {
    id: root

    property var duration: 1000
    property alias model: listview.model
    // property alias spacing: listview.spacing
    property alias orientation: listview.orientation

    implicitWidth: 1000
    implicitHeight: 600

    ListView {
        id: listview
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight - 20
        // anchors.left: background.left
        // anchors.top: background.top
        // anchors.topMargin: 20

        layoutDirection: Qt.LeftToRight
        verticalLayoutDirection: Qt.LeftToRight
        boundsBehavior: Flickable.StopAtBounds
        interactive: true
        highlightFollowsCurrentItem: true


        highlight: Control {
            objectName: "highlight"
        }

        delegate: Rectangle {
            property bool isRemoving: false
            color: "blue"
            opacity: 0.2
            objectName: "delegate"
            implicitWidth: 140
            implicitHeight: 60

            ListView.onRemove: {
                isRemoving = true
            }

            Behavior on x {
                enabled: root.orientation === ListView.Horizontal
                SmoothedAnimation { duration: root.duration }
            }
        }

        add: Transition {
            PropertyAction { property: "transformOrigin"; value: Item.Left }
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: root.duration }
            NumberAnimation { property: "scale"; from: 0.5; to: 1.0; duration: root.duration }
            XAnimator { from: 0; duration: root.duration }
        }

        remove: Transition {
            PropertyAction { property: "transformOrigin"; value: Item.Left }
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: root.duration }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.5; duration: root.duration }
            XAnimator { to: 0; duration: root.duration }
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
