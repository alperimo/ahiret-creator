import QtQuick 2.15

Rectangle{
    id: button_rect

    property bool flag: false
    property color normalColor: "white"
    property color hoveredColor: normalColor
    property color clickedColor: normalColor
    property color pressedColor: normalColor
    property string textName: qsTr("")

    property bool checkable: false
    property bool checkable_fixed: false // bir kez tıklanır, clicked olarak kalır. (tekrar tıklanınca default moda gecmez!)
    property bool bg_color_hide: false

    property alias rectText: text_name.text
    property alias textR: text_name
    property alias font: text_name.font

    property color textNormalColor: "white"
    property color textHoverColor: "white"

    property alias borders: borders
    property color borderNormalColor: "transparent"
    property color borderHoveredColor: "transparent"

    property real hoveredOpacity: -1.0 // rectangle icin (-1.0 ise hoveredOpacity yoktur)

    property alias mouseAreas: mouseArea
    property bool mouseAreaForText: false // mouse area'yı sadece text için gecerli kılar. (arka plansız textButton olusturmak icin)

    state: ""
    color: (!bg_color_hide) ? normalColor : "transparent"

    CustomBorder
    {
        id: borders
        borderColor: borderNormalColor
        //commonBorderWidth: 1
        commonBorder: false
        lBorderwidth: 0
        rBorderwidth: 0
        tBorderwidth: 0
        bBorderwidth: 0
    }

    Text{
        id: text_name
        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        text: textName
        color: textNormalColor
    }

    states: [

        State { 
            name: "CLICKED"
            PropertyChanges {
                target: button_rect
                flag: true
                explicit: true
                color: (!bg_color_hide) ? clickedColor : color
                //rotation: button_rect.rotation + 90
            }
            PropertyChanges {
                target: text_name
                color: button_rect.textHoverColor
            }
            PropertyChanges{
                target: borders
                borderColor: button_rect.borderHoveredColor
            }
        },

        State {
            name: "HOVERED"
            PropertyChanges {
                target: button_rect
                //rotation: button_rect.rotation
                color: (!bg_color_hide) ? hoveredColor : button_rect.color
                //opacity: (hoveredOpacity !== -1.0) ? hoveredOpacity : button_rect.opacity
            }
            PropertyChanges {
                target: text_name
                color: button_rect.textHoverColor
            }
            PropertyChanges{
                target: borders
                borderColor: button_rect.borderHoveredColor
            }
        },

        /*State{
            name: "PRESSED"
            PropertyChanges {
                target: button_rect
                color: pressedColor;
            }
        },*/

        State {
            name: "dragchange"
            AnchorChanges {
                target: button_rect
                anchors.left: undefined
                anchors.right: undefined
                anchors.top: undefined
                anchors.bottom: undefined

            }
        }


    ]

    transitions: [

        Transition {
            from: ""
            to: "CLICKED"
            reversible: true
            ParallelAnimation{

                /*RotationAnimation {
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }*/


                ColorAnimation {
                    property: "color"
                    duration: 100
                }
            }

            onRunningChanged: if(!running && (!checkable && !checkable_fixed) && button_rect.state != "") button_rect.state = ""
        },

        Transition {
            from: ""
            to: "HOVERED"
            reversible: true


            ColorAnimation {
                duration: 100
            }
        },

        Transition {
            from: "HOVERED"
            to: "CLICKED"
            reversible: true


            ColorAnimation {
                duration: 100
            }

            onRunningChanged: if(!running && (!checkable && !checkable_fixed) && button_rect.state != "HOVERED") button_rect.state = "HOVERED"
        }

    ]


    MouseArea{
        id: mouseArea
        anchors.fill: (!mouseAreaForText) ? parent : text_name
        acceptedButtons: Qt.LeftButton
        propagateComposedEvents: true

        hoverEnabled: true

        onClicked: {

            if (button_rect.state != "CLICKED")
                button_rect.state = "CLICKED"
            else{
                button_rect.state = (!parent.checkable_fixed) ? "" : button_rect.state

            }

            console.log("button_rect clicked " + button_rect.state)

        }

        /*onPressed: {

            if (button_rect.state != "PRESSED")
                button_rect.state = "PRESSED"

            console.log("button_rect pressed " + button_rect.state)
        }*/

        onEntered: {
            if (button_rect.state != "CLICKED")
                button_rect.state = "HOVERED"

            /*if (button_rect.state == "CLICKED")
                button_rect.color = clickedColor*/
        }

        onExited: {


            if (button_rect.state == "HOVERED")
                button_rect.state = ""

            /*if (button_rect.state === "CLICKED" && mouseArea.pressed == true)
            {
               button_rect.color = hoveredColor
                console.log("CLICKED ve left mouse aktif")
            }*/

        }

        /*onPressed: { button_rect.state = "dragchange" }
        drag.target: button_rect
        drag.axis: Drag.XAxis | Drag.YAxis
        drag.minimumX: 0
        drag.maximumX: window.width - button_rect.width
        drag.minimumY: 0
        drag.maximumY: window.height - button_rect.height*/
    }

}
