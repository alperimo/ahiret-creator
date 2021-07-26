import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import MyTreeModel 1.0

Rectangle {

    property int realWidth: 430
    property int windowWidth: 0

    property bool borderVisible: false

    property alias main_rightmenu: rect

    property string transition_props: "x,opacity,visible"

    id: rect

    x: windowWidth
    visible: false

    //opacity: 0

    states: [

        State {
            name: "hide"
            PropertyChanges{
                id: hideChanges
                target: rect

                opacity: 0
                visible: true
                //borderVisible: false
            }

            PropertyChanges{
                target: rectangle.rightMenusArray[right_menu.rightMenuStatus-1]
                borderVisible: false
            }
        },

        State {
            name: "open"
            PropertyChanges {
                target: rect

                x: windowWidth - realWidth

                //opacity: 1
                visible: true
                borderVisible : false
            }

            /*PropertyChanges{
                target: rectangle.rightMenusArray[right_menu.rightMenuStatus-1]
                borderVisible: false
            }*/

        }

    ]

    transitions: [
        Transition {
            from: ""
            to: "open"

            PropertyAnimation{
                properties: "x"

                easing.type: Easing.OutQuad
                easing.amplitude: 2.0
                easing.period: 1.5

                duration: 120
            }

            onRunningChanged: if (!running) borderVisible = true

        },

        Transition {
            from: "hide"
            to: "open"

            PropertyAnimation{
                properties: "x"

                easing.type: Easing.OutQuad
                easing.amplitude: 2.0
                easing.period: 1.5

                duration: 120

            }

            onRunningChanged: if (!running) borderVisible = true

        },

        Transition {
            from: "open"
            to: "hide"

            PropertyAnimation{
                properties: "x,opacity"

                easing.type: Easing.OutQuad
                easing.amplitude: 2.0
                easing.period: 1.5

                duration: 100
            }

            onRunningChanged: {
                if(!running){
                    rect.visible = false


                    console.log("rect.borderVisible on hiding: " + rect.borderVisible)
                }
            }

        }
    ]

}
