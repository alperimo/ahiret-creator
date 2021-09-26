//  A toy QML colorpicker control, by Ruslan Shestopalyuk
import QtQuick 2.11
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import "content"
import QtQuick 2.15

Rectangle {
    id: colorPicker
    property color colorValue: paletteMode ?
                                   _rgb(paletts.paletts_color, alphaSlider.value) :
                                   _hsla(hueSlider.value, sbPicker.saturation,
                                    sbPicker.brightness, alphaSlider.value)
    //property color colorValue: _rgb(paletts.paletts_color, alphaSlider.value)
    property bool enableAlphaChannel: true
    property bool enableDetails: true
    property int colorHandleRadius : 8
    property bool paletteMode : false
    property bool enablePaletteMode : false
    property string switchToColorPickerString: "Palette..."
    property string switchToPalleteString: "Color Picker..."

    property alias draggableArea: draggableArea

    signal colorChanged(color changedColor)

    property alias hueSlider: hueSlider
    property alias input_hex: input_hex

    radius: 5

    width: 400; height: 200
    color: "#1c1c1c"//"#3C3C3C"


    MouseArea{
        anchors.fill: parent
        onClicked: forceActiveFocus()
    }

    Text {
        id: palette_switch
        textFormat: Text.StyledText
        text: paletteMode ?
                  "<a href=\".\">" + switchToColorPickerString + "</a>" :
                  "<a href=\".\">" + switchToPalleteString + "</a>"
        visible: enablePaletteMode
        onLinkActivated: {
            paletteMode = !paletteMode
        }
        anchors.right: parent.right
        anchors.rightMargin: colorHandleRadius
        linkColor: "white"
    }

    clip: true

    RowLayout {
        id: picker
        anchors.top: (parent.enablePaletteMode　? palette_switch.bottom : parent.top)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: colorHandleRadius
        anchors.bottom: parent.bottom
        spacing: 0



        SwipeView {
            id: swipe
            clip: true
            interactive: false
            currentIndex: paletteMode ? 1 : 0

            Layout.fillWidth: true
            Layout.fillHeight: true


            SBPicker {
                id: sbPicker

                height: parent.implicitHeight
                width: parent.implicitWidth

                mouseAreas.onPressed: {forceActiveFocus()}

                hueColor: {
                    var v = 1.0-hueSlider.value

                    if(0.0 <= v && v < 0.16) {
                        return Qt.rgba(1.0, 0.0, v/0.16, 1.0)
                    } else if(0.16 <= v && v < 0.33) {
                        return Qt.rgba(1.0 - (v-0.16)/0.17, 0.0, 1.0, 1.0)
                    } else if(0.33 <= v && v < 0.5) {
                        return Qt.rgba(0.0, ((v-0.33)/0.17), 1.0, 1.0)
                    } else if(0.5 <= v && v < 0.76) {
                        return Qt.rgba(0.0, 1.0, 1.0 - (v-0.5)/0.26, 1.0)
                    } else if(0.76 <= v && v < 0.85) {
                        return Qt.rgba((v-0.76)/0.09, 1.0, 0.0, 1.0)
                    } else if(0.85 <= v && v <= 1.0) {
                        return Qt.rgba(1.0, 1.0 - (v-0.85)/0.15, 0.0, 1.0)
                    } else {
                        console.log("hue value is outside of expected boundaries of [0, 1]")
                        return "red"
                    }
                }
            }

            Palettes {
                id: paletts
            }
        }

        // hue picking slider
        Item {
            id: huePicker
            visible: !paletteMode
            width: 12
            Layout.fillHeight: true
            Layout.topMargin: colorHandleRadius
            Layout.bottomMargin: colorHandleRadius

            Rectangle {
                anchors.fill: parent
                id: colorBar
                gradient: Gradient {
                    GradientStop { position: 1.0;  color: "#FF0000" }
                    GradientStop { position: 0.85; color: "#FFFF00" }
                    GradientStop { position: 0.76; color: "#00FF00" }
                    GradientStop { position: 0.5;  color: "#00FFFF" }
                    GradientStop { position: 0.33; color: "#0000FF" }
                    GradientStop { position: 0.16; color: "#FF00FF" }
                    GradientStop { position: 0.0;  color: "#FF0000" }
                }
            }
            ColorSlider {
                id: hueSlider; anchors.fill: parent
                mouseAreas.onPressed: {forceActiveFocus()}
            }
        }

        // alpha (transparency) picking slider
        Item {
            id: alphaPicker
            visible: enableAlphaChannel
            width: 12
            Layout.leftMargin: 4
            Layout.fillHeight: true
            Layout.topMargin: colorHandleRadius
            Layout.bottomMargin: colorHandleRadius
            Checkerboard { cellSide: 4 }
            //  alpha intensity gradient background
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#FF000000" }
                    GradientStop { position: 1.0; color: "#00000000" }
                }
            }
            ColorSlider {
                id: alphaSlider; anchors.fill: parent
                mouseAreas.onPressed: {forceActiveFocus()}
            }
        }

        // details column
        Column {
            id: detailColumn
            Layout.leftMargin: 4
            Layout.fillHeight: true
            Layout.topMargin: colorHandleRadius
            Layout.bottomMargin: colorHandleRadius
            Layout.alignment: Qt.AlignRight
            visible: enableDetails

            // current color/alpha display rectangle
            PanelBorder {
                width: parent.width
                height: 30
                visible: enableAlphaChannel
                Checkerboard { cellSide: 5 }
                Rectangle {
                    width: parent.width; height: 30
                    border.width: 1; border.color: "black"
                    color: colorPicker.colorValue
                }
            }

            // "#XXXXXXXX" color value box
            PanelBorder {
                id: colorEditBox
                height: 15; width: parent.width

                TextInput {
                    id: input_hex
                    anchors.fill: parent
                    color: "#AAAAAA"
                    selectionColor: "#FF7777AA"
                    font.pixelSize: 11
                    maximumLength: 9
                    //focus: false
                    //selectByMouse: true
                    text: _fullColorString(colorPicker.colorValue, alphaSlider.value)
                    focus: false

                    onTextEdited: {
                        state = "onEdited"
                        changeHSBfromHEX(text)

                    }

                    onActiveFocusChanged: {
                        state = ""
                    }

                    states: [
                        State {
                            name: "onEdited"
                            PropertyChanges {
                                target: input_hex
                                text: text
                            }
                        }
                    ]

                    function get_text(){
                        var test = input_hex.text
                        if (test.length == 0)
                            test = "#FF000000"
                        else
                            test += "000000000"
                        return test.substring(0, 9)
                    }

                }
            }

            // H, S, B color values boxes
            Column {
                visible: !paletteMode
                width: parent.width
                NumberBox { caption: "H:"; value: hueSlider.value.toFixed(2) }
                NumberBox { caption: "S:"; value: sbPicker.saturation.toFixed(2) }
                NumberBox { caption: "B:"; value: sbPicker.brightness.toFixed(2) }
            }

            // filler rectangle
            Rectangle {
                width: parent.width; height: 5
                color: "transparent"
            }

            // R, G, B color values boxes
            Column {
                width: parent.width
                NumberBox {
                    caption: "R:"
                    value: _getChannelStr(colorPicker.colorValue, 0)
                    min: 0; max: 255
                }
                NumberBox {
                    caption: "G:"
                    value: _getChannelStr(colorPicker.colorValue, 1)
                    min: 0; max: 255
                }
                NumberBox {
                    caption: "B:"
                    value: _getChannelStr(colorPicker.colorValue, 2)
                    min: 0; max: 255
                }
            }

            // alpha value box
            NumberBox {
                visible: enableAlphaChannel
                caption: "A:"; value: Math.ceil(alphaSlider.value*255)
                min: 0; max: 255
            }
        }

    }

    Rectangle{
        id: test

        width: 40
        height: 30

        x: 300
        y: 170

        property string lo: "#FF96657E"

        MouseArea{
            anchors.fill: parent
            onClicked: {
            }
        }
    }

    function changeHSBfromHEX(hex){
        var hsb = hexToRGBA(hex)
        changeColorWithHSB(hsb)
    }

    function changeColorFromRGBA(r, g, b, a){
        var hsb = rgbToHSB(r, g, b, a)
        changeColorWithHSB(hsb)
    }

    function getColorFromRGBA(r, g, b, a){
        var hsb = rgbToHSB(r, g, b, a)
        return _hsla(hsb[0], hsb[1], hsb[2], hsb[3])

    }

    function changeColorWithHSB(hsb){
        hueSlider.pickerCursor.y = -hueSlider.height*hsb[0] + hueSlider.height

        sbPicker.pickerCursor.x = sbPicker.divided_w * hsb[1]
        sbPicker.pickerCursor.y = -sbPicker.divided_h * hsb[2] + sbPicker.divided_h

        alphaSlider.pickerCursor.y = -alphaSlider.height*hsb[3] + alphaSlider.height
    }

    Rectangle{
        id: draggableArea
        x: 250 + 60
        y: 150 + 17
        width: 80
        height: 30
        color: "transparent"

        Drag.active: true
        MouseArea{
            anchors.fill: parent
            drag.target: colorPicker
        }

    }

    //  creates color value from hue, saturation, brightness, alpha
    function _hsla(h, s, b, a) {
        var lightness = (2 - s)*b
        var satHSL = s*b/((lightness <= 1) ? lightness : 2 - lightness)
        lightness /= 2

        var c = Qt.hsla(h, satHSL, lightness, a)

        colorChanged(c)

        return c
    }

    // create rgb value
    function _rgb(rgb, a) {
        var c = Qt.rgba(rgb.r, rgb.g, rgb.b, a)

        colorChanged(c)

        return c
    }

    //  creates a full color string from color value and alpha[0..1], e.g. "#FF00FF00"
    function _fullColorString(clr, a) {
        return "#" + ((Math.ceil(a*255) + 256).toString(16).substr(1, 2) + clr.toString().substr(1, 6)).toUpperCase()
    }

    //  extracts integer color channel value [0..255] from color value
    function _getChannelStr(clr, channelIdx) {
        return parseInt(clr.toString().substr(channelIdx*2 + 1, 2), 16)
    }

    function hexToRGBA(H){
        let r=0, g=0, b=0, a=1

        if (H.length == 1 + 2){
            a = "0x" + H[1] + H[2]
        }else if (H.length == 1 + 4){
            a = "0x" + H[1] + H[2]
            r = "0x" + H[3] + H[4]
        }else if(H.length == 1 + 6){
            a = "0x" + H[1] + H[2]
            r = "0x" + H[3] + H[4]
            g = "0x" + H[5] + H[6]
        }else if(H.length == 1 + 8){
            a = "0x" + H[1] + H[2]
            r = "0x" + H[3] + H[4]
            g = "0x" + H[5] + H[6]
            b = "0x" + H[7] + H[8]
        }

        a = +(a / 255).toFixed(3);

        return rgbToHSB(+r, +g, +b, a)
    }

    function rgbToHSB(r,g,b,a) {
      // Make r, g, and b fractions of 1
      r /= 255;
      g /= 255;
      b /= 255;

      // Find greatest and smallest channel values
      let cmin = Math.min(r,g,b),
          cmax = Math.max(r,g,b),
          delta = cmax - cmin,
          h = 0,
          s = 0,
          l = 0;

      let b_ = 0, s_ = 0;

      // Calculate hue
      // No difference
      if (delta == 0)
        h = 0;
      // Red is max
      else if (cmax == r)
        h = ((g - b) / delta) % 6;
      // Green is max
      else if (cmax == g)
        h = (b - r) / delta + 2;
      // Blue is max
      else
        h = (r - g) / delta + 4;

      h = Math.round(h * 60);

      b_ = cmax.toFixed(2); // hepsi yukarida 255'e bölündüğü icin. tekrardan max / 255 gerek yok.
      s_ = ((cmax - cmin)/cmax).toFixed(2);

      // Make negative hues positive behind 360°
      if (h < 0)
          h += 360;

      h /= 360;
      h = h.toFixed(2);

      return [h,s_,b_,a];

    }
}
