import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item {
    id: root
    visible: {
        return listview.model.count > 0
    }
    required property var previewCotent

    property var aniDuration: 500
    property alias model: listview.model
    property alias spacing: listview.spacing
    property alias orientation: listview.orientation
    property var maxSize: Qt.size(listview.implicitWidth, listview.implicitHeight)

    implicitWidth: {
        let width = 0
        var reseverWidth = listview.orientation === ListView.Horizontal ? -listview.spacing : 0
        for (let child of listview.contentItem.visibleChildren) {
            if (child.objectName === "highlight") continue
            if (listview.orientation === ListView.Horizontal) {
                let tmp = width + (child.implicitWidth + listview.spacing)
                if (tmp > maxSize.width) {
                    return width + reseverWidth
                } else {
                    width = tmp
                }
            } else {
                width = Math.max(width, child.implicitWidth)
            }
        }

        width += reseverWidth
        return width
    }

    implicitHeight: {
        let height = 0
        let reseverHeight = headLayout.implicitHeight + (listview.orientation === ListView.Vertical ? 0 : listview.spacing)
        for (let child of listview.contentItem.visibleChildren) {
            if (child.objectName === "highlight") continue
            if (listview.orientation === ListView.Vertical) {
                let tmp = height + (child.implicitHeight + listview.spacing)
                 if (tmp > maxSize.height) {
                     return height + reseverHeight
                 } else {
                     height = tmp
                 }
            } else {
                height = Math.max(height, child.implicitHeight)
            }
        }
        return height + reseverHeight
    }

    Control {
        id: content

        Item {
            implicitWidth: headLayout.implicitWidth
            implicitHeight: headLayout.implicitHeight
        }

        ListView {
            id: listview

            property var lastSize: Qt.size(0, 0)

            clip: true
            anchors.topMargin: headLayout.implicitHeight + listview.spacing
            anchors.top: content.top
            layoutDirection: Qt.LeftToRight
            verticalLayoutDirection: Qt.LeftToRight
            boundsBehavior: Flickable.StopAtBounds
            interactive: true
            highlightFollowsCurrentItem: true
            implicitHeight: root.implicitHeight
            implicitWidth: root.implicitWidth
            highlightMoveDuration: 200
            spacing: 5
            highlight: Rectangle {
                objectName: "highlight"
                id: hoverBorder
                visible: false
                z: listview.z + 2
                color: "transparent";
                radius: 5
                border.color: "lightsteelblue"
                border.width: 4

                anchors {
                    verticalCenterOffset: -(headLayout.implicitHeight) / 2 - 3
                    verticalCenter: listview.orientation === ListView.Horizontal && parent ? parent.verticalCenter : undefined
                    horizontalCenter: listview.orientation === ListView.Vertical && parent ? parent.horizontalCenter : undefined
                }

                Rectangle {
                    anchors {
                        top: parent.top
                        right: parent.right
                        topMargin: 10
                        rightMargin: 10
                    }

                    implicitWidth: 24
                    implicitHeight: 24
                }
            }
            focus: true
            delegate: Rectangle {
                id: rect
                objectName: "delegate"
                visible: true
                implicitWidth: delegateContent.implicitWidth
                implicitHeight: delegateContent.implicitHeight

                property bool isRemoving: false

                property var preItem: {
                    let a = index
                    if (listview.itemAtIndex(--a) && a > 0) {
                        return listview.itemAtIndex(a)
                    }

                    return rect
                }

                anchors {
                    verticalCenterOffset: -(headLayout.implicitHeight) / 2 - 3
                    verticalCenter: listview.orientation === ListView.Horizontal && parent ? parent.verticalCenter : undefined
                    horizontalCenter: listview.orientation === ListView.Vertical && parent ? parent.horizontalCenter : undefined
                }

                ListView.onRemove: {
                    isRemoving = true
                }

                ListView.onIsCurrentItemChanged: {
                    // if (ListView.isCurrentItem) {
                    //     tiitle.text = model.windowTitle
                    //     icon.source = "image://windowIcon/" + model.windowId
                    // }
                }

                HoverHandler {
                    onHoveredChanged: {
                        if (hovered) {
                            listview.highlightItem.visible = true
                            listview.currentIndex = index
                        }
                    }
                }

                Loader {
                    id: delegateContent
                    property var previewData: modelData
                    property var indexData: index
                    anchors {
                        centerIn: parent
                        fill: parent
                        topMargin: 4
                        bottomMargin: 4
                        leftMargin: 4
                        rightMargin: 4
                    }

                    active: true
                    sourceComponent: root.previewCotent
                }
            }

            HoverHandler {
                onHoveredChanged: {
                    if (!hovered) {
                        listview.highlightItem.visible = false
                    }
                }
            }
        }

        Rectangle {
            id: background
            color: "red"
            z: -1
            implicitWidth: {
                let width = 0
                var reseverWidth = listview.orientation === ListView.Horizontal ? -listview.spacing : 0
                for (let child of listview.contentItem.visibleChildren) {
                    if (child.objectName === "highlight" || child.isRemoving) continue
                    if (listview.orientation === ListView.Horizontal) {
                        let tmp = width + (child.implicitWidth + listview.spacing)
                        if (tmp > maxSize.width) {
                            return width + reseverWidth
                        } else {
                            width = tmp
                        }
                    } else {
                        width = Math.max(width, child.implicitWidth)
                    }
                }

                width += reseverWidth
                return width
            }
            implicitHeight: {
                let height = 0
                let reseverHeight = headLayout.implicitHeight + (listview.orientation === ListView.Vertical ? 0 : listview.spacing)
                for (let child of listview.contentItem.visibleChildren) {
                    if (child.objectName === "highlight" || child.isRemoving) continue
                    if (listview.orientation === ListView.Vertical) {
                        let tmp = height + (child.implicitHeight + listview.spacing)
                         if (tmp > maxSize.height) {
                             return height + reseverHeight
                         } else {
                             height = tmp
                         }
                    } else {
                        height = Math.max(height, child.implicitHeight)
                    }
                }
                return height + reseverHeight
            }

            HoverHandler {
                id: titleHover
            }

            RowLayout {
                id: headLayout
                spacing: 4

                anchors {
                    left: background.left
                    right: background.right
                    leftMargin: 4
                    rightMargin: 4
                }

                Image {
                    id: icon
                    sourceSize: Qt.size(24, 24)
                    Layout.alignment: Qt.AlignVCenter
                    asynchronous: true
                }

                Text {
                    id: tiitle
                    text: qsTr("I'm prettttttttttttttttttttttttttttttttttttty looooooooooooooooooooooooooooooong title")
                    elide: Text.ElideRight
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                Item {
                    implicitWidth: 24
                    implicitHeight: 24
                    visible: titleHover.hovered
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    Layout.rightMargin: 6

                    Rectangle {
                        anchors.fill: parent
                        color: "blue"
                    }
                }
            }

            Behavior on implicitHeight {
                NumberAnimation { duration: root.aniDuration }
            }

            Behavior on implicitWidth {
                NumberAnimation { duration: root.aniDuration }
            }
        }
    }
}
