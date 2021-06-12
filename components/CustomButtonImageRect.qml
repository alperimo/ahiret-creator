import QtQuick 2.12
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
    property bool checked: (btnImage.state == "CLICKED") ? true : false
    property bool colorizedImage: false
    property bool colorizedOnlyByClicked: false // hovered icin colorized olmaz.

    property real hueValue: 0.0

    property color rectNormalColor: "transparent"
    property color rectHoveredColor: "transparent"
    property color rectClickedColor: "transparent"

    property alias btnImage: image
    property alias mouseAreas: mouseArea

    Rectangle{
        id: background_rect
        color: rectNormalColor
        anchors.fill: parent
    }

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

            console.log("button_rect clicked " + image.state)

        }

        onEntered: {
            if (image.state != "CLICKED"){
                image.state = "HOVERED"
                console.log("onEntered")
            }

        }

        onExited: {
            if (image.state == "HOVERED")
                image.state = ""
        }
    }

    //Components
    Image{
        id: image
        anchors.fill: parent
        source: defaultImage

        PropertyChanges {
            target: background_rect
            color: rectNormalColor
        }

        //opacity: 0.0

        //States
        states: [
            State {
                name: ""
                PropertyChanges {
                    target: colorize
                    opacity: (colorizedImage) ? 0.0 : colorize.opacity

                }
            },

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

                PropertyChanges {
                    target: background_rect
                    color: rectClickedColor
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
                    opacity: (colorizedImage && !colorizedOnlyByClicked) ? 1.0 : 0.0
                }
                PropertyChanges {
                    target: background_rect
                    color: rectHoveredColor
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
                        from: 0
                        to: 1
                        duration: (colorizedImage) ? 500 : 0
                    }

                    OpacityAnimator{
                        from: 1
                        to: 0
                        duration: (colorizedImage) ? 500 : 0
                    }

                    PropertyAnimation {
                        duration: (!colorizedImage) ? 100 : 0
                    }

                    ColorAnimation {
                        target: background_rect
                        duration: 100
                    }
                }

                onRunningChanged: if(!running && (!checkable && !checkable_fixed) && image.state != "") image.state = ""
            },

            Transition {
                from: ""
                to: "HOVERED"
                reversible: true

                ParallelAnimation{

                    OpacityAnimator{
                        duration: (colorizedImage) ? 500 : 0
                    }

                    PropertyAnimation {
                        duration: (!colorizedImage) ? 100 : 0
                    }


                    ColorAnimation {
                        target: background_rect
                        duration: 100
                    }
                }

            },

            Transition {
                from: "HOVERED"
                to: "CLICKED"
                reversible: true

                ParallelAnimation{

                    OpacityAnimator{
                        duration: (colorizedImage) ? 500 : 0
                    }

                    PropertyAnimation {
                        duration: (!colorizedImage) ? 100 : 0
                    }

                    ColorAnimation {
                        target: background_rect
                        duration: 100
                    }

                }

                onRunningChanged: if(!running && (!checkable && !checkable_fixed) && image.state != "HOVERED") image.state = "HOVERED"
            }

        ]

        /*Text{
            id: textN
            anchors.centerIn: parent
            color: "white"
        }*/

    }

    /*ColorOverlay {
        anchors.fill: image
        source: image
        color: "transparent" //"#43b581"
    }*/



    Colorize{
        id: colorize
        property variant colors: getColorized(153, 46, 48.6)

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
