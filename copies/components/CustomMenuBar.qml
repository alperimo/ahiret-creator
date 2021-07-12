import QtQuick 2.12
import QtQuick.Controls 2.12

MenuBar {
    id: menuBar

    property alias bg: bg
    property color hoveredBgColor: "transparent"
    property color textColor: "#b3b3b3"
    property color textHoverC: "#a0a0a0"

    property int itemWidth: 40
    property int itemHeight: 40


    property int fontPixelSize: 10

    delegate: MenuBarItem {
        id: menuBarItem

        font.pixelSize: menuBar.fontPixelSize
        //font.weight: Font.Normal

        contentItem: Text {
            text: menuBarItem.text//menuBarItem.text
            font: menuBarItem.font

            opacity: enabled ? 1.0 : 0.3
            color: menuBarItem.highlighted ? menuBar.textHoverC : menuBar.textColor
            horizontalAlignment: Text.AlignHCenter//Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: menuBar.itemWidth
            implicitHeight: menuBar.itemHeight
            opacity: enabled ? 1 : 0.3
            color: menuBarItem.highlighted ? menuBar.hoveredBgColor : "transparent"
        }
    }

    background: Rectangle {
        id: bg
        implicitWidth: menuBar.itemWidth
        implicitHeight: menuBar.itemHeight
        color: "#ffffff"

        Rectangle {
            color: "#21be2b"
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            visible: false
        }
    }
}
