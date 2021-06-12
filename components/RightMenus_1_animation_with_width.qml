import QtQuick 2.15

Rectangle {

    property int realWidth: 430

    id: rect

    visible: false

    states: [

        State {
            name: "hide"
            PropertyChanges {
                target: rect

                width: 0
                visible: true
            }
        },

        State {
            name: "open"
            PropertyChanges {
                target: rect

                width: rect.realWidth
                visible: true

            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "open"

            PropertyAnimation{
                property: "width"
                duration: 400
            }
        },

        Transition {
            from: "hide"
            to: "open"

            PropertyAnimation{
                property: "width"
                duration: 400
            }
        },

        Transition {
            from: "open"
            to: "hide"

            PropertyAnimation{
                property: "width"
                duration: 400

            }

            onRunningChanged: {
                if(!running){
                    rect.visible = false
                }
            }

        }
    ]

    Rectangle{
        width: 404
        height: 31
        anchors.top: parent.top
        anchors.topMargin: 49
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 12
        color: "#1c1c1c"
        Text{
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 6
            text: "MAP DETAILS"
            font.family: "Gilroy"
            font.pixelSize: 12
            font.weight: Font.Bold
            font.styleName: Font.Normal
            color: "#d3d3d3"
        }
    }

    Text{
        //anchors.centerIn: parent
        anchors.right: parent.right
        text: "TESTBULAN"
        font.pixelSize: 18
        color: "white"
    }
}
