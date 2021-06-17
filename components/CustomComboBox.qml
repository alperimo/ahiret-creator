import QtQuick 2.12
import QtQuick.Controls 2.12

ComboBox {
    id: control
    model: ["First", "Second", "Third"]


    delegate: ItemDelegate{

        width: control.width
        height: 25

        //
        //contentItem:

        Rectangle{
            anchors.fill: parent
            color: "red"
        }

        Text {
            text: modelData
            color: "#8b8d90"
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        //highlighted: control.highlightedIndex === index
    }

    indicator: Canvas {
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

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: "#8b8d90"
            color: "#151616"
            radius: 2
        }
    }
}
