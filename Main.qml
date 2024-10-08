import QtQuick
import QtQuick.Controls 2.15

Window {
    id: root
    x: 100
    y: 100
    width: 1400
    height: 800
    visible: true
    title: qsTr("Hello World")
    property var count: 1

    Row {
        Button {
            id: add
            onClicked: {
                var loopCount = Math.floor(Math.random() * 5) + 1;
                var i = 0

                // while ( i++ < loopCount) {
                    list.append({"preview": (++count).toString()})
                    list.append({"preview": (++count).toString()})
                // }
            }
        }

        Button {
            id: remove
            onClicked: {
                var loopCount = Math.floor(Math.random() * 5) + 1;
                var i = 0
                // while ( i++ < loopCount) {
                    // if (count < 0) break;
                    list.remove(--count, 1)
                    list.remove(--count, 1)
                // }
            }
        }

        Button {
            id: turn
            onClicked: {
                view.orientation = (view.orientation === ListView.Horizontal ? ListView.Vertical : ListView.Horizontal)
            }
        }
    }


    ListModel {
        id: list
        property var lastSize: 1
        ListElement { preview: "1" }

        onCountChanged: {
            Qt.callLater(()=> {
                   lastSize = count
            })
        }
    }

    TaskManagerPreview {
        id: view
        anchors.centerIn: parent
        model: list
        // previewCotent: contentc
        orientation: ListView.Horizontal
    }

    Component{
        id: contentc

        Rectangle {
            property var index: indexData
            visible: true
            color: "blue"
            implicitHeight: 120
            implicitWidth: 240
            Text {
                text: previewData
            }
        }
    }
}
