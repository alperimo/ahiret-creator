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

    property alias rectText: text_name.text
    property alias textR: text_name
    property alias font: text_name.font

    property color textNormalColor: "white"
    property color textHoverColor: "white"

    property real hoveredOpacity: -1.0 // rectangle icin (-1.0 ise hoveredOpacity yoktur)

    property alias mouseAreas: mouseArea

    state: ""
    color: normalColor

    //rotation: button_rect.rotation

    Text{
        id: text_name
        anchors.centerIn: parent
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
                color: clickedColor
                //rotation: button_rect.rotation + 90
            }
        },

        State {
            name: "HOVERED"
            PropertyChanges {
                target: button_rect
                //rotation: button_rect.rotation
                color: hoveredColor
                //opacity: (hoveredOpacity !== -1.0) ? hoveredOpacity : button_rect.opacity
            }
            PropertyChanges {
                target: text_name
                color: button_rect.textHoverColor

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

            onRunningChanged: if(!running && !checkable && button_rect.state != "") button_rect.state = ""
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

            onRunningChanged: if(!running && !checkable && button_rect.state != "HOVERED") button_rect.state = "HOVERED"
        }

    ]


    MouseArea{
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        propagateComposedEvents: true

        hoverEnabled: true

        onClicked: {

            if (button_rect.state != "CLICKED")
                button_rect.state = "CLICKED"
            else{
               button_rect.state = ""
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
