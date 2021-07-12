import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12

Item {
    id: item
    property alias text_r: text_r

    property int items_width: 119
    property int items_height: 16

    property color switchBg_normalColor: "#222222"
    property color switchBg_hoverColor: "#222222"
    property color switchBg_checkedColor: "#222222"

    property color switchBg_normalBorderColor: "#222222"
    property color switchBg_hoverBorderColor: "#222222"
    property color switchBg_checkedBorderColor: "#222222"

    property color switch_normalColor: "#8b8d90"
    property color switch_hoveredColor: "#a3a3a3"
    property color switch_hoveredColor_forChecked: "#57c995"
    property color switch_checkedColor: "#43b581"

    property alias switchButton: control

    Layout.row: 0; Layout.column: 0; width: items_width; height: items_height
    Text{
        id: text_r
        text: "Ambient Occlusion"; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
        color: "#767676"
    }

    Switch {
        id: control
        text: qsTr("Switch")

        anchors.right: parent.right

        implicitWidth: 32
        implicitHeight: 16



        indicator: Rectangle {
            id: indiRect
            anchors.fill: parent

            //x: control.leftPadding
            //y: parent.height / 2 - height / 2
            radius: 8
            color: control.checked ? item.switchBg_checkedColor : parent.parent.switchBg_normalColor
            border.color: control.checked ? item.switchBg_checkedBorderColor : parent.parent.switchBg_normalBorderColor

            MouseArea{

                id: mouse_
                anchors.fill: parent

                onClicked: {
                    console.log("lann sikik")
                    parent.clickedFunc()
                }
            }

            CustomButtonRectangle{
                id: switchb
                x: 0//control.checked ? parent.width - width : 0
                y: 2
                width: 12
                height: 12
                radius: 8

                normalColor: control.checked ? item.switch_checkedColor : item.switch_normalColor
                hoveredColor: control.checked ? item.switch_hoveredColor_forChecked : item.switch_hoveredColor
                clickedColor: item.switch_checkedColor

                property bool animRun: false

                mouseAreas.onClicked: {
                    parent.clickedFunc()
                }



            }

            function clickedFunc(){
                console.log("loglama oc")
                control.checked = control.checked ^ 1
                switchb.state = ""
                switchb.animRun = false
                switchb.animRun = true
            }

            PropertyAnimation{
                id: animm
                target: switchb
                property: "x"
                from: control.checked ? 0 : indiRect.width - switchb.width
                to: control.checked ? indiRect.width - switchb.width : 0

                running: switchb.animRun


                duration: 100

            }

        }


        contentItem: Text {
            visible: false
            /*text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? "#17a81a" : "#21be2b"
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.indicator.width + control.spacing*/
        }
    }

}
