// Text, Slider ve değerini içerir.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item{
    id: main
    property alias text_property_name: text_property_name
    property alias text_property_value: text_property_value

    property int items_width: 350
    property int items_height: 25

    property alias slider: slider

    property bool disabled: false

    property string unit: "" // m, cm, deg, mm

    Layout.row: 0; Layout.column: 0;
    width: items_width;
    height: items_height;

    Component.onCompleted: {
        console.log("width for " + text_property_name.text + ": " + width)
        console.log("height for " + text_property_name.text + ": " + height)
    }

    Text{
        id: text_property_name
        anchors.left: parent.left; anchors.top: parent.top
        text: ""; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
        color: "#767676"
    }

    Text{
        id: text_property_unit // m, cm, deg, mm
        anchors.right: text_property_value.left; anchors.rightMargin: 6; anchors.top: parent.top; anchors.topMargin: 1.5
        text: parent.unit; font.family: "Gilroy"; font.pixelSize: 10; font.weight: Font.Normal; font.styleName: Font.Normal
        color: "#8b8d90"
    }

    /*Text{
        id: text_property_value
        anchors.right: parent.right; anchors.rightMargin: 14; anchors.top: parent.top
        text: parseFloat(slider.value).toFixed(2); font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
        color: "#ffffff"
    }*/

    TextInput{id: text_property_value
        anchors.right: parent.right; anchors.rightMargin: 14; anchors.top: parent.top
        text:parseFloat(slider.value).toFixed(2); font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
        color: "#ffffff"; activeFocusOnPress: true

        Keys.onPressed: {
            if(event.key == Qt.Key_Enter || event.key == Qt.Key_Return){
                console.log("input enter basildiiiiiiiiiiiiiii.")
                slider.value = parseFloat(text)
            }

        }

        onActiveFocusChanged: {
            if (!activeFocus)
            {
                console.log("focus input ------------------------------------------------------")
                slider.value = parseFloat(text)
            }else{
                console.log("focus input +++++++++++++++++++++++++++++++++++++++++++++++++++++++")
            }

        }

    }

    /*Rectangle{
        x:0
        y:0
        width: main.width - 50
        height: 10
        color: "green"
    }*/

    Slider {
        id: slider

        value: 25

        from: 0
        to: 100

        anchors.left: parent.left
        anchors.leftMargin: -leftPadding
        anchors.right: parent.right
        anchors.top: text_property_name.bottom
        anchors.topMargin: 8

        implicitWidth: parent.items_width

        enabled: !main.disabled



        background: Rectangle {
            x: slider.leftPadding
            //y: slider.topPadding + slider.availableHeight / 2 - height / 2
            //x: 0
            y: 0
            implicitWidth: parent.parent.width
            implicitHeight: 4
            width: slider.availableWidth
            //width: implicitWidth
            height: implicitHeight
            radius: 2
            color: "#212121"

            Rectangle {
                id: full
                anchors.left: parent.left
                anchors.top: parent.top
                //width: (slider.position) * (slider.availableWidth)//(slider.visualPosition) * parent.width
                width: slider.position * slider.availableWidth
                height: parent.height
                color: "#8b8d90"

                opacity: !main.disabled ? 1.0 : 0.3

                radius: 2
            }
        }

        handle: Rectangle {

            x: slider.leftPadding + (slider.position) * (slider.availableWidth - width)
            //x: slider.position * slider.availableWidth
            //x: (slider.visualPosition) * slider.background.width

            y: -3 //slider.availableHeight / 2 - height / 2
            implicitWidth: 10
            implicitHeight: 10

            MouseArea{
                id: mouseAreax
                property bool hover: false
                hoverEnabled: true

                anchors.fill: parent

                onEntered: {
                    console.log("mouseAreax on Entered")
                    hover = true
                }

                onExited: {
                    console.log("mouseArex on Exited")
                    hover = false
                }

                propagateComposedEvents: true
                onClicked: mouse.accepted = false;
                onPressed: mouse.accepted = false;

            }

            radius: 13
            color: slider.pressed ? "#a3a3a3" : (mouseAreax.hover) ? "#b7b7b7" : "#a3a3a3"

            opacity: !main.disabled ? 1.0 : 0.3

            //border.color: "#bdbebf"
        }
    }
}

