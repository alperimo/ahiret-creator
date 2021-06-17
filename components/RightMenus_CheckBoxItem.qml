// listView icerisinde Layout'lu itemdir. Layout.row ve Layout.column belirtilmesi gerekebilir.

import QtQuick 2.15
import QtQuick.Layouts 1.15

Item{
    property alias text_r: text_r

    property int items_width: 150
    property int items_height: 16

    property int checkbox_width: 16
    property int checkbox_height: 16
    property color checkbox_normalColor: "#222222"
    property color checkbox_hoveredColor: "#4d4d4d"
    property color checkbox_clickedColor: checkbox_normalColor

    property url checkbox_defaultImage: ""
    property url checkbox_hoveredImage: ""
    property url checkbox_clickedImage: "../images/checked_button.png"

    property alias checkboxButton: checkboxButton

    Layout.row: 0; Layout.column: 0; width: items_width; height: items_height
    Text{
        id: text_r
        text: "Ambient Occlusion"; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
        color: "#767676"
    }
    CustomButtonImageRect{
        anchors.right: parent.right
        id: checkboxButton; width: parent.checkbox_width; height: parent.checkbox_height;
        btnImage.scale: 0.75; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined;
        rectNormalColor: parent.checkbox_normalColor; rectHoveredColor: parent.checkbox_hoveredColor; rectClickedColor: parent.checkbox_clickedColor;
        defaultImage: parent.checkbox_defaultImage; hoveredImage: parent.checkbox_hoveredImage; clickedImage: parent.checkbox_clickedImage;
        checkable: true;

        mouseAreas.onClicked: {
            //
        }
    }
}
