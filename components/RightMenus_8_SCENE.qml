import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import MyTreeModel 1.0

import OpenGLCamera 1.0
import OpenGLUnderQML 1.0

//import QtQuick.Dialogs 1.3
import Qt.labs.platform 1.1

import "colorpicker"

import QtQuick.Dialogs 1.3
import QtQuick.Window 2.1

//SCENE-page
Item{
    id: scene_page
    anchors.fill: parent
    anchors.topMargin: 9.5
    anchors.leftMargin: 12
    anchors.rightMargin: 12
    property int scene_width: width
    property int scene_height: height

    property alias main_page_ref: scene_page

    Component.onCompleted: {
        console.log("scene_width in main for scene8: " + scene_width)
        //console.log("scene_height: " + height)
    }

    MouseArea{
        id: mouseArea
        property bool hover: false
        hoverEnabled: true
        anchors.fill: parent
        onEntered: {
            console.log("onEntered yes")
            //colorDialog.open()
            hover = true
        }
        onExited: {
            console.log("onExited yes")
            hover = false
        }


    }

    Component {
        id: basicLightSettings

        /*Rectangle {
            width: scene_page.scene_width
            height: 31 + 198 + 26
            color: "yellow"
        }*/

        RightMenus_1_SCENE_Item{
            id: basicLightSettingsItem

            width: scene_page.scene_width
            height: 31 + 10 + 23 + 51*2

            property alias settings_layout: basic_lighting_settings_layout //es muss verändert werden.

            page_title.text: "BASIC LIGHTING SETTINGS"

            /*Rectangle{
                anchors.fill: parent
                color: "green"
            }*/

            GridLayout{
                id: basic_lighting_settings_layout
                anchors.top: parent.page_title_bg.bottom
                anchors.topMargin: 9
                anchors.left: parent.page_title_bg.left
                anchors.leftMargin: 4
                rows: 4
                columns: 3

                rowSpacing: 11

                visible: true

                property int items_width_: 130//parent.page_title_bg.width - 1
                property int items_height_: 26

                property int items_width_slider: parent.page_title_bg.width - 1
                property int items_height_slider: 26

                property int items_width_checkbox: 103
                property int items_height_checkbox: 16

                /*Rectangle{
                    width: parent.items_width_ - 5
                    height: 25
                    color:"yellow"
                }*/

                states: [
                    State {
                        name: "hide"
                        PropertyChanges {
                            target: basicLightSettingsItem
                            height: 31
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: ""
                        to: "hide"
                        reversible: true
                        PropertyAnimation {
                            properties: "height,anchors"
                            duration: 300
                        }
                    }
                ]

                Item{
                    //Layout.row: 0; Layout.column: 0;

                    width: parent.items_width_
                    height: 17

                    /*slider.value: main_rightmenu.currentScene.light.specular

                    slider.onValueChanged: {
                        main_rightmenu.currentScene.light.specular = slider.value
                    } */

                    Text{
                        id: text_ambient
                        anchors.left: parent.left; anchors.top: parent.top
                        text: "Ambient: "; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
                        color: "#767676"
                    }

                    CustomButtonRectangle{
                        id: ambient_color_button
                        anchors.left: text_ambient.right;
                        width: 73; height: 16; radius: 2;
                        hoveredOpacity: 0.5; clickedOpacity: 0.3; wirdPopup: true

                        property color initColor
                        property color colorValue//Qt.rgba(1.0, 0.0, 0.0, 1.0);
                        normalColor: colorValue;

                        property var c

                        Component.onCompleted: {
                            c = Qt.createQmlObject("import QtQuick 2.0; QtObject { function f() { return ambient_color_button } }", this, "none")
                            colorValue = main_rightmenu.currentScene.light.ambient
                            initColor = colorValue
                            colorValueChanged()
                        }

                        /*Component.onCompleted: {
                            c = Qt.createQmlObject("import QtQuick 2.0; QtObject { function f() { return ambient_color_button } }", this, "none")
                            var value = main_rightmenu.currentScene.light.ambient
                            //console.log("cpp'den initialize edilen value: " + value + " r: " + (value.r*255) + " g: " + (value.g*255) + " b: " + (value.b*255) + " a: " + (value.a*255))
                            //colorValue = Qt.rgba(value.r, value.g, value.b, value.a)

                            console.log("cpp'den initialize edilen value: " + value)
                            colorValue = value
                            colorValueChanged()
                            console.log("colorChanged from onCompleted")
                        }*/

                        Component.onDestruction: {
                            c.destroy()
                        }

                        mouseAreas.onClicked: {
                            /*my_color_popup.visible = true
                            my_color_popup.requestActivate()*/
                            scene_page.color_popup_open(c)
                        }

                        onColorValueChanged: {
                            main_rightmenu.currentScene.light.ambient = normalColor
                            console.log("colorChanged ambient looooooooooo normalColor: " + normalColor)
                        }

                    }


                }

                Item{
                    //Layout.row: 0; Layout.column: 1;


                    width: parent.items_width_
                    height: 17

                    Text{
                        id: text_diffuse
                        anchors.left: parent.left; anchors.top: parent.top
                        text: "Diffuse: "; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
                        color: "#767676"
                    }

                    CustomButtonRectangle{
                        id: diffuse_color_button
                        anchors.left: text_diffuse.right
                        width: 73; height: 16; radius: 2;
                        hoveredOpacity: 0.5; clickedOpacity: 0.3; wirdPopup: true;

                        property color initColor
                        property color colorValue//Qt.rgba(1.0, 0.0, 0.0, 1.0);
                        normalColor: colorValue;

                        property var c

                        Component.onCompleted: {
                            c = Qt.createQmlObject("import QtQuick 2.0; QtObject { function f() { return diffuse_color_button } }", this, "none")
                            var value = main_rightmenu.currentScene.light.diffuse
                            colorValue = value
                            initColor = colorValue
                            colorValueChanged()

                        }

                        Component.onDestruction: {
                            c.destroy()
                        }

                        mouseAreas.onClicked: {

                            scene_page.color_popup_open(c)
                        }


                        onColorValueChanged: {
                            main_rightmenu.currentScene.light.diffuse = normalColor
                            console.log("colorChanged looooooooooo normalColor: " + normalColor)
                        }
                    }
                }

                Item{

                    //Layout.row: 0; Layout.column: 2;

                    width: parent.items_width_
                    height: 17

                    Text{
                        id: text_specular
                        anchors.left: parent.left; anchors.top: parent.top
                        text: "Specular: "; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
                        color: "#767676"
                    }

                    CustomButtonRectangle{
                        id: specular_color_button
                        anchors.left: text_specular.right
                        width: 73; height: 16; radius: 2;
                        hoveredOpacity: 0.5; clickedOpacity: 0.3; wirdPopup: true

                        property color initColor
                        property color colorValue//Qt.rgba(1.0, 0.0, 0.0, 1.0);
                        normalColor: colorValue;

                        property var c

                        Component.onCompleted: {
                            c = Qt.createQmlObject("import QtQuick 2.0; QtObject { function f() { return specular_color_button } }", this, "none")
                            var value = main_rightmenu.currentScene.light.specular
                            colorValue = value
                            initColor = colorValue
                            colorValueChanged()

                        }

                        Component.onDestruction: {
                            c.destroy()
                        }

                        mouseAreas.onClicked: {

                            scene_page.color_popup_open(c)
                        }


                        onColorValueChanged: {
                            main_rightmenu.currentScene.light.specular = normalColor
                            console.log("colorChanged looooooooooo normalColor: " + normalColor)
                        }
                    }
                }

                RightMenus_CheckBoxItem{
                    id: pointLight
                    Layout.row: 1; Layout.column: 0;
                    text_r.text: "Point Light: "

                    checkboxButtonRightMargin: 16

                    items_width: parent.items_width_checkbox
                    items_height: parent.items_height_checkbox

                    checked: main_rightmenu.currentScene.light.pointLight

                    onCheckedChanged: {
                        main_rightmenu.currentScene.light.pointLight = checked
                    }
                }

                RightMenus_SliderItem{
                    Layout.row: 2; Layout.rowSpan: 1
                    Layout.column: 0; Layout.columnSpan: 3

                    text_property_name.text: "Linear:"

                    unit: ""

                    disabled: !pointLight.checked

                    items_width: parent.items_width_slider
                    items_height: parent.items_height_slider

                    slider.from: 0.0; slider.to: 1.0
                    slider.value: main_rightmenu.currentScene.light.linear

                    Component.onCompleted: {
                        console.log("items_width_slider for linear: " + parent.items_width_slider)
                    }


                    slider.onValueChanged: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value
                        main_rightmenu.currentScene.light.linear = slider.value
                    }

                }


                RightMenus_SliderItem{
                    Layout.row: 3; Layout.rowSpan: 1
                    Layout.column: 0; Layout.columnSpan: 3;

                    text_property_name.text: "Quadratic:"

                    unit: ""

                    disabled: !pointLight.checked

                    items_width: parent.items_width_slider
                    items_height: parent.items_height_slider

                    slider.from: 0.0; slider.to: 1.0
                    slider.value: main_rightmenu.currentScene.light.quadratic

                    Component.onCompleted: {
                        console.log("items_width_slider for quadratic: " + parent.items_width_slider)
                    }


                    slider.onValueChanged: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value
                        console.log("now items_width quadratic " + items_width)
                        main_rightmenu.currentScene.light.quadratic = slider.value
                    }

                }

            }
        }
    }

    Component {
        id: spotLightSettings
        /*Rectangle {
            width: main_page_ref.scene_width
            height: 31 + 88
            color: "green"
        }*/

        RightMenus_1_SCENE_Item{
            id: spotLightSettingsItem
            width: main_page_ref.scene_width
            height: 31 + 110

            property alias settings_layout: spotLight_settings_layout //es muss verändert werden.

            page_title.text: "FLASHLIGHT SETTINGS"

            GridLayout{
                id: spotLight_settings_layout
                anchors.top: page_title_bg.bottom
                anchors.topMargin: 9
                anchors.left: page_title_bg.left
                anchors.leftMargin: 4
                rows: 3
                columns: 1

                rowSpacing: 10
                columnSpacing: 22

                visible: true

                property int items_width_slider: parent.page_title_bg.width - 1
                property int items_height_slider: 26

                property int items_width_checkbox: 103
                property int items_height_checkbox: 16

                states: [
                    State {
                        name: "hide"
                        PropertyChanges {
                            target: spotLightSettingsItem
                            height: 31
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: ""
                        to: "hide"
                        reversible: true
                        PropertyAnimation {
                            properties: "height,anchors"
                            duration: 300
                        }
                    }
                ]

                RightMenus_CheckBoxItem{
                    id: spotLight
                    Layout.row: 0; Layout.column: 0;
                    text_r.text: "Spot Light: "

                    checkboxButtonRightMargin: 16

                    items_width: parent.items_width_checkbox
                    items_height: parent.items_height_checkbox

                    checked: main_rightmenu.currentScene.light.spotLight

                    onCheckedChanged: {
                        console.log("checked degisti: " + checked)
                        main_rightmenu.currentScene.light.spotLight = checked
                    }
                }

                RightMenus_SliderItem{
                    id: cutOff
                    Layout.row: 1;
                    Layout.column: 0;

                    text_property_name.text: "Beam Angle:"

                    unit: "d"

                    disabled: !spotLight.checked

                    items_width: parent.items_width_slider
                    items_height: parent.items_height_slider

                    slider.from: 0.0; slider.to: 120.0
                    slider.value: main_rightmenu.currentScene.light.cutOff

                    Component.onCompleted: {
                        console.log("items_width_slider for quadratic: " + parent.items_width_slider)
                    }


                    slider.onValueChanged: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value

                        if (slider.value > outCutOff.slider.value)
                            outCutOff.slider.value = slider.value

                        console.log("now items_width quadratic " + items_width)
                        main_rightmenu.currentScene.light.cutOff = slider.value
                    }

                }

                RightMenus_SliderItem{
                    id: outCutOff
                    Layout.row: 2;
                    Layout.column: 0;

                    text_property_name.text: "Field Angle:"

                    unit: "d"

                    disabled: !spotLight.checked

                    items_width: parent.items_width_slider
                    items_height: parent.items_height_slider

                    slider.from: 0.0; slider.to: 120.0
                    slider.value: main_rightmenu.currentScene.light.outCutOff


                    Component.onCompleted: {
                        console.log("items_width_slider for quadratic: " + parent.items_width_slider)
                    }


                    slider.onValueChanged: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value

                        if (slider.value < cutOff.slider.value)
                            slider.value = cutOff.slider.value

                        console.log("now items_width quadratic " + items_width)
                        main_rightmenu.currentScene.light.outCutOff = slider.value
                    }

                }


            }


        }
    }

    Component {
        id: graphicSettings

        Rectangle {
            width: main_page_ref.scene_width
            height: 31 + 198 + 26
            color: "green"

            /*MouseArea{
                anchors.fill: parent
                onClicked: {
                    colorDialog.open()
                }
            }*/
        }


    }



    ColorDialog {
        id: colorDialog

        currentColor: "red"
    }

    ListView {
        id: listView

        property bool hovered: false

        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        anchors.fill: parent

        spacing: 5

        model: ListModel {
            ListElement {
                title: "basic_lighting_settings"
            }
            ListElement{
                title: "spotLightSettings"
            }
            ListElement {
                title: "graphic_settings"
            }
        }

        clip: true

        delegate: Loader{
            //property string title: title
            Component.onCompleted: {console.log("title: " + title)}
            sourceComponent: switch(title){
                case "basic_lighting_settings": return basicLightSettings
                case "spotLightSettings": return spotLightSettings
                case "graphic_settings": return graphicSettings
                default: console.log("hicbiri degil title: " + title)
            }
        }

        Layout.fillWidth: true
        Layout.fillHeight: true

        /*HoverHandler{
            id: hoverHandler

        }*/

        ScrollBar.vertical: ScrollBar {
            id: scroll
            parent: listView.parent

            anchors.top: listView.top
            anchors.left: listView.right
            anchors.bottom: listView.bottom
            anchors.bottomMargin: 10
            //hoverEnabled: true

            active: mouseArea.hover || hovered || pressed
            policy: ScrollBar.AsNeeded

            palette.dark: "#8b8d90"
            palette.mid: "#8b8d90"
        }

    }

    function color_popup_open(property_){
        if (test_popup.currentProperty.length == 1)
            test_popup.currentProperty.shift()
        test_popup.currentProperty.push(property_.f())
        var colorx = test_popup.currentProperty[0].normalColor

        test_popup.open()

        //test_popup.currentProperty[0].colorValue = "red"//test_popup.currentProperty[0].initColor

        console.log("colorx: h: " + colorx.r + " s: " + colorx.g  + " b: " + colorx.b + " a: " + colorx.a)

        color_change(colorx)

        test_popup.currentProperty[0].colorValue = test_popup.currentProperty[0].initColor


    }

    function color_change(colorx){
        return test_popup.background.changeColorFromRGBA(colorx.r*255, colorx.g*255, colorx.b*255, colorx.a)
    }

    function get_color_init_withhex(colort){ //#AARRGGBB seklinde.
        return get_color_init(colort)
    }

    function get_color_init(colorx){ // mit ARGB
        return test_popup.background.getColorFromRGBA(colorx.r*255, colorx.g*255, colorx.b*255, colorx.a)
    }

    Popup{
        id: test_popup

        //anchors.centerIn: parent
        x:my_picker.x
        y:my_picker.y

        width: 400
        height: 200

        leftPadding: 0
        topPadding: 0
        rightPadding: 0
        bottomPadding: 0

        visible: false

        property var currentProperty: []

        MouseArea{
            anchors.fill: parent

            propagateComposedEvents: true
            onClicked: {mouse.accepted=false}
            onPressed: {mouse.accepted=false}
        }

        //closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        background: ColorPicker{
            id: my_picker
            /*anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom*/

            onColorChanged: {
                // test signal handler
                console.debug("handle signal:"+changedColor)
                if (test_popup.currentProperty.length > 0){

                    /*test_popup.currentProperty[0].colorValue = test_popup.background.input_hex.get_text()
                    console.log("onColorChanged: before: " + test_popup.background.input_hex.text +  " after: " + test_popup.background.input_hex.get_text())
                    */

                    test_popup.currentProperty[0].colorValue = changedColor
                    //test_popup.currentProperty[0].colorValue.colorValueChanged()
                }



            }

            Component.onCompleted: {
                //changeHSBfromHEX("AA345432")
                //hueSlider.pickerCursor.y = 40
                console.log("colorPicker onCompleted: " + hueSlider.pickerCursor.y)
            }
        }
    }


    /*
    MyTreeModel{
        id: theModel
    }

    TreeView {
        id: tree
        anchors.top: parent.top
        anchors.topMargin: 9.5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 9.5


        style : TreeViewStyle {
            frame:  Item{}

            backgroundColor: "transparent"

        }

        frameVisible: false

        Component.onCompleted: {
            console.log("treeview'in parent height: " + parent.height)
        }



        // START_OF_TEST

        model: theModel
        itemDelegate: Rectangle {
           color: ( styleData.row % 2 == 0 ) ? "white" : "lightblue"
           height: 20

           Text {
               anchors.verticalCenter: parent.verticalCenter
               anchors.left: parent.left // by default x is set to 0 so this had no effect
               text: styleData.value === undefined ? "" : styleData.value // The branches don't have a description_role so styleData.value will be undefined
           }
        }

        TableViewColumn {
            role: "name_role"
            title: ""

        }


        // END_OF_TEST



    }

    */



}
