import QtQuick 2.12
import QtQuick.Controls 2.12

Menu {
    id: menu
    title: qsTr("File")

    property color menuColor: "#232424" //file, edit, help gibi butonlara tıkladıktan sonra açılan popup bg
    property color menuBorderColor: "#232424"

    property int menuItemWidth: 200
    property int menuItemHeight: 26

    property color menuItemHoveredColor: "#353536"
    property color menuItemTextColor: "#b3b3b3"
    property color menuItemTextHoveredColor: "#a0a0a0"

    property color menuItemSeperatorColor: "#2d2e2e"

    property color menuItemArrowColor: "#b3b3b3"
    property color menuItemArrowHoveredColor: "#b3b3b3"

    topPadding: 2
    bottomPadding: 2

    delegate: MenuItem {
        id: menuItem
        implicitWidth: menu.menuItemWidth
        implicitHeight: menu.menuItemHeight

        hoverEnabled: true

        arrow: CustomButtonImage{
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: menuItem.verticalCenter

            width: 10
            height: 10

            rotation: -90

            visible: menuItem.subMenu

            defaultImage: "../images/combobox_popup_button.png"
            hoveredImage: "../images/combobox_popup_button.png"
            clickedImage: "../images/combobox_popup_button.png"

        }/*Canvas {
            x: parent.width - width
            implicitWidth: 40
            implicitHeight: menu.menuItemHeight
            visible: menuItem.subMenu
            onPaint: {
                var ctx = getContext("2d")
                ctx.fillStyle = menuItem.hovered ? menu.menuItemArrowColor : menu.menuItemArrowHoveredColor
                ctx.moveTo(15, 15)
                ctx.lineTo(width - 15, height / 2)
                ctx.lineTo(15, height - 15)
                ctx.closePath()
                ctx.fill()
            }
        }*/

        indicator: Item {
            implicitWidth: 40
            implicitHeight: menu.menuItemHeight
            /*Rectangle {
                width: 26
                height: 26
                anchors.centerIn: parent
                visible: menuItem.checkable
                border.color: "#21be2b"
                radius: 3
                Rectangle {
                    width: 14
                    height: 14
                    anchors.centerIn: parent
                    visible: menuItem.checked
                    color: "#21be2b"
                    radius: 2
                }
            }*/
        }

        contentItem: Item{
            Text {
                leftPadding: 16//menuItem.indicator.width
                rightPadding: menuItem.arrow.width
                text: menuItem.text
                font: menuItem.font
                opacity: enabled ? 1.0 : 0.3
                color: menuItem.hovered ? menu.menuItemTextHoveredColor : menu.menuItemTextColor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            Text {
                leftPadding: menu.menuItemWidth - 70
                rightPadding: menuItem.arrow.width + 8
                //leftPadding: 16//menuItem.indicator.width
                //rightPadding: menuItem.arrow.width
                text: (action) ? ((action.shortcut != undefined) ? action.shortcut : "") : ""
                //font: menuItem.font
                font.pixelSize: 10
                opacity: enabled ? 1.0 : 0.3
                color: menuItem.hovered ? menu.menuItemTextHoveredColor : menu.menuItemTextColor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }

        background: Rectangle {
            implicitWidth: menu.menuItemWidth
            implicitHeight: menu.menuItemHeight
            //enabled: contentItem.enabled
            opacity: contentItem.enabled ? 1 : 0.3
            color: menuItem.hovered ? menu.menuItemHoveredColor : "transparent"
        }

    }

    background: Rectangle {
        implicitWidth: menu.menuItemWidth
        implicitHeight: menu.menuItemHeight
        color: menu.menuColor
        border.color: menu.menuBorderColor
        radius: 2
    }
}
