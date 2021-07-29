import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick.Controls.Styles 1.4
import QtQml 2.15

ComboBox{
    id: control
    model: ["First", "Second", "Third"]

    property bool textHorizontalAlign:false

    property real setPopupMaxHeight: 0

    delegate: ItemDelegate{
        id: itemDlg
        width: control.width
        height: 20

        contentItem: Text {
            anchors.fill: parent

            anchors.left: (!control.textHorizontalAlign) ? rect.left : undefined
            anchors.leftMargin: (!control.textHorizontalAlign) ? 3 : 0

            anchors.topMargin: itemDlg.height / 2 - (font.pixelSize / 2)
            text: modelData
            color: "#8b8d90"
            font: control.font

            elide: Text.ElideRight

            rightPadding: (control.textHorizontalAlign) ? 11 : 0

            Binding on horizontalAlignment {when: control.textHorizontalAlign; value: Text.AlignHCenter; restoreMode: Binding.RestoreBinding}
        }

        highlighted: control.highlightedIndex === index

        background: CustomButtonRectangle{
            id: rect
            anchors.fill: itemDlg

            normalColor: "#151616"
            hoveredColor: "#232424"
            clickedColor: "#8b8d90"

            mouseAreas.propagateComposedEvents: true

            mouseAreas.onClicked: {
                mouse.accepted = false
            }

            mouseAreas.onPressed: {
                mouse.accepted = false
            }

        }
    }

    indicator: CustomButtonImage{
        id: canvas
        anchors.right: parent.right
        anchors.rightMargin: 4
        y: control.topPadding + (control.availableHeight - height) / 2

        width: 10
        height: 10

        defaultImage: "../images/combobox_popup_button.png"
        hoveredImage: "../images/combobox_popup_button.png"
        clickedImage: "../images/combobox_popup_button.png"

        colorizedImage: true

        mouseAreas.onClicked: mouse.accepted = false
        mouseAreas.onPressed: mouse.accepted = false

        Component.onCompleted: {
            colorize.hue_ = 225
            colorize.saturation_ = 2
            colorize.lightness_ = 55
        }
    }

    contentItem: Text {
        leftPadding: 0
        rightPadding: (!control.textHorizontalAlign) ? (control.indicator.width + control.spacing) : 0

        text: control.displayText
        font: control.font
        color: control.pressed ? "#a0a0a0" : "#8b8d90"
        verticalAlignment: Text.AlignVCenter
        //elide: Text.ElideRight

        Binding on horizontalAlignment {when: control.textHorizontalAlign; value: Text.AlignHCenter; restoreMode: Binding.RestoreBinding}
    }

    background: Rectangle {
        //implicitWidth: control.width
        //implicitHeight: control.height

        //border.color: control.pressed ? "#17a81a" : "#21be2b"
        //border.width: control.visualFocus ? 2 : 1
        radius: 2

        color: "#151616"
    }

    CustomBorder
    {
        //commonBorderWidth: 1
        commonBorder: false
        lBorderwidth: 0
        rBorderwidth: 0
        tBorderwidth: 0
        bBorderwidth: 1
        borderColor: "#232323"
    }

    popup: Popup {
            id: popupx
            y: control.height - 1
            width: control.width
            implicitHeight: (control.setPopupMaxHeight > 0) ? control.setPopupMaxHeight : contentItem.implicitHeight
            padding: 1

            //HoverHandler{id: hoverHandler; target: popupx; acceptedPointerTypes: PointerDevice.AllPointerTypes}

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: control.popup.visible ? control.delegateModel : null

                currentIndex: control.highlightedIndex

                /*delegate: Item{
                    Rectangle{
                        width: parent.width
                        height: 15
                    }
                }*/

                ScrollBar.vertical: ScrollBar {
                    //active: hoverHandler.hovered || hovered || pressed
                    policy: ScrollBar.AlwaysOn
                }
            }

            background: Rectangle {
                border.color: "#8b8d90"
                color: "#151616"
                radius: 2
            }
        }
    }
