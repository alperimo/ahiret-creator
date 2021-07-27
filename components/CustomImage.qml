import QtQuick 2.15
import QtGraphicalEffects 1.12

Image {
    id: image
    property url defaultImage: ""

    property alias colorize: colorize
    property alias opacityAnimToFull: opacityAnimToFull
    property alias opacityAnimToNull: opacityAnimToNull

    source: defaultImage

    Colorize{

        id: colorize

        property real hue_: 153
        property real saturation_: 46
        property real lightness_: 48.6
        property variant colors: getColorized(hue_, saturation_, lightness_)

        anchors.fill: image
        source: image
        opacity: 0.0
        hue: colors[0] //153 / 360
        saturation: colors[1] //0.46
        lightness: colors[2] //48.6/50 - 1

        OpacityAnimator on opacity{ id: opacityAnimToFull; to: 1.0; duration: 100; running: false
            onRunningChanged: {

            }
        }

        OpacityAnimator on opacity{ id: opacityAnimToNull; to: 0.0; duration: 100; running: false
            onRunningChanged: {

            }
        }
    }

    function getColorized(hue, saturation, lightness){
        return [hue/360, saturation/100, (lightness/50)-1];
    }
}
