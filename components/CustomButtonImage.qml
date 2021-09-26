import QtQuick 2.12
import QtQuick 2.2
import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {
    id: button
    width: 30
    height: 30

    property url defaultImage: ""
    property url hoveredImage: ""
    property url clickedImage: ""

    property bool checkable: false
    property bool checkable_fixed: false // bir kez tıklanır, clicked olarak kalır. (tekrar tıklanınca default moda gecmez!)
    property bool colorizedImage: false

    property real hueValue: 0.0

    property alias btnImage: image
    property alias mouseAreas: mouseArea
    property alias colorize: colorize

    PropertyChanges {
        target: colorize
        opacity: 0.0
    }

    //Components
    Image{
        id: image
        anchors.fill: parent
        source: defaultImage

        //opacity: 0.0

        //States
        states: [

            State {
                name: "CLICKED"
                PropertyChanges {
                    target: image
                    explicit: true
                    source: clickedImage
                }

                PropertyChanges {
                    target: colorize
                    opacity: (colorizedImage) ? 1.0 : 0.0
                }
            },

            State {
                name: "HOVERED"
                PropertyChanges {
                    target: image
                    source: hoveredImage
                }
                PropertyChanges {
                    target: colorize
                    opacity: (colorizedImage) ? 1.0 : 0.0
                }
            },

            State {
                name: "dragchange"
                AnchorChanges {
                    target: button
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

                    OpacityAnimator{
                        duration: (colorizedImage) ? 100 : 0
                    }

                    PropertyAnimation {
                        duration: (!colorizedImage) ? 100 : 0
                    }
                }

                onRunningChanged: if(!running && (!checkable && !checkable_fixed) && image.state != "") image.state = ""
            },

            Transition {
                from: ""
                to: "HOVERED"
                reversible: true


                OpacityAnimator{
                    duration: (colorizedImage) ? 100 : 0
                }

                PropertyAnimation {
                    duration: (!colorizedImage) ? 100 : 0
                }
            },

            Transition {
                from: "HOVERED"
                to: "CLICKED"
                reversible: true


                PropertyAnimation {
                    duration: 100
                }

                onRunningChanged: if(!running && (!checkable && !checkable_fixed) && image.state != "HOVERED") image.state = "HOVERED"
            }

        ]


        MouseArea{
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            propagateComposedEvents: true

            hoverEnabled: true

            onClicked: {
                if (image.state != "CLICKED")
                    image.state = "CLICKED"
                else
                    image.state = (!parent.checkable_fixed) ? "" : image.state
            }

            onEntered: {
                if (image.state != "CLICKED"){
                    image.state = "HOVERED"
                }

            }

            onExited: {
                if (image.state == "HOVERED")
                    image.state = ""
            }
        }

    }

    Colorize{

        property real hue_: 153
        property real saturation_: 46
        property real lightness_: 48.6
        property variant colors: getColorized(hue_, saturation_, lightness_)

        id: colorize

        anchors.fill: image
        source: image
        opacity: 0.0
        hue: colors[0] //153 / 360
        saturation: colors[1] //0.46
        lightness: colors[2] //48.6/50 - 1
    }

    function getColorized(hue, saturation, lightness){
        return [hue/360, saturation/100, (lightness/50)-1];
    }

}


