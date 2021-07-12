import QtQuick 2.12
import QtQuick.Controls 2.12

CheckBox {
    id: control
    text: qsTr("CheckBox")
    checked: false

    property int buttonLeftMargin: 50

    hoverEnabled: true

    indicator: Rectangle {
        property color normalColor: "#222222"
        property color hoveredColor: "blue"
        property color checkedColor: "green"
        width: 14
        height: 14
        anchors.left: contentItem.right
        anchors.leftMargin: control.spacing + control.buttonLeftMargin
        radius: 3

        //border.color: control.down ? "#17a81a" : "#21be2b"

        color: (control.checked) ? indicator.checkedColor : (control.hovered) ? indicator.hoveredColor : indicator.normalColor

        //visible: control.checked

    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        //color: control.down ? "#17a81a" : "#21be2b"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.spacing
    }
}
