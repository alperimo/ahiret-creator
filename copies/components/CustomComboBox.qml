import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick.Controls.Styles 1.4

ComboBox{
    id: control
    model: ["First", "Second", "Third"]

    delegate: ItemDelegate{
        id: itemDlg
        width: control.width
        height: 20

        contentItem: Text {
            //anchors.top: rect.top
            //anchors.topMargin: 2
            anchors.fill: parent
            anchors.left: rect.left
            anchors.leftMargin: 3
            anchors.top: itemDlg.top
            anchors.topMargin: itemDlg.height / 2 - (font.pixelSize / 2)
            text: modelData
            color: "#8b8d90"
            font: control.font


            Component.onCompleted: {
                console.log("font pixelSize: " + font.pixelSize)
            }
            elide: Text.ElideRight

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
                console.log("clicked var ve index: " + index)
                control.highlightedIndex == index
                mouse.accepted = false
            }

            mouseAreas.onPressed: {
                console.log("pressed var ve index: " + index)
                control.highlightedIndex == index
                mouse.accepted = false
            }

        }

        /*background: Rectangle{
            anchors.fill: itemDlg
            color: itemDlg.hovered ? "#232424" : "#151616"

            MouseArea{
                anchors.fill: parent

                propagateComposedEvents: true
                onClicked: mouse.accepted = false;
                onPressed: mouse.accepted = false;
                //onReleased: mouse.accepted = false;
                //onDoubleClicked: mouse.accepted = false;
                //onPositionChanged: mouse.accepted = false;
                //onPressAndHold: mouse.accepted = false;
            }
        }*/
    }

    /*indicator: Canvas {
        id: canvas
        //x: control.width - width - control.rightPadding

        anchors.right: parent.right
        anchors.rightMargin: 4
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            function onPressedChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = control.pressed ? "#a0a0a0" : "#8b8d90";
            context.fill();
        }

    }*/

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
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: control.pressed ? "#a0a0a0" : "#8b8d90"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
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
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

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

            ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            border.color: "#8b8d90"
            color: "#151616"
            radius: 2
        }
    }
}
