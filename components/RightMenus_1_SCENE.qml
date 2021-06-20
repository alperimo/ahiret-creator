import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import MyTreeModel 1.0

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

    MouseArea{
        id: mouseArea
        property bool hover: false
        hoverEnabled: true
        anchors.fill: parent
        onEntered: {
            console.log("onEntered yes")
            hover = true
        }
        onExited: {
            console.log("onExited yes")
            hover = false
        }
    }

    Component{
        id: sceneSettings

        RightMenus_1_SCENE_Item{
            id: sceneSettingsItem
            width: main_page_ref.scene_width
            height: 31 + 88 + 26

            property alias settings_layout: scene_settings_layout //es muss verändert werden.

            page_title.text: "SCENE SETTINGS"

            GridLayout{
                id: scene_settings_layout
                anchors.top: page_title_bg.bottom
                anchors.topMargin: 9
                anchors.left: page_title_bg.left
                anchors.leftMargin: 4
                rows: 3
                columns: 1

                rowSpacing: 11

                visible: true

                states: [
                    State {
                        name: "hide"
                        PropertyChanges {
                            target: sceneSettingsItem
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
                    Layout.row: 0; Layout.column: 0;
                    text_r.text: "Ambient Occlusion:"

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

                RightMenus_CheckBoxItem{
                    Layout.row: 1; Layout.column: 0;
                    text_r.text: "White Balance:"

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

                RightMenus_CheckBoxItem{
                    Layout.row: 2; Layout.column: 0;
                    text_r.text: "Atmospere:"

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

            }

            CustomButtonRectangle{
                anchors.top: scene_settings_layout.bottom
                anchors.topMargin: 10
                id: reload_shaders_button; width: page_title_bg.width; height: 26;
                normalColor: "#4d4d4d"; hoveredColor: "#646464";
                textR.text: "Reload Shaders"; textNormalColor:"#bebebe"; font.pixelSize: 12; font.family: "Gilroy"; font.weight: Font.Normal
            }
        }
    }

    Component {
        id: toggleSettings
        /*Rectangle {
            width: scene_page.scene_width
            height: 31 + 88
            color: "blue"
            opacity: 0.1
        }*/

        RightMenus_1_SCENE_Item{
            id: toggleSettingsItem
            width: main_page_ref.scene_width
            height: 31 + 88

            property alias settings_layout: toggle_settings_layout //es muss verändert werden.



            page_title.text: "TOGGLE"

            GridLayout{
                id: toggle_settings_layout
                anchors.top: page_title_bg.bottom
                anchors.topMargin: 9
                anchors.left: page_title_bg.left
                anchors.leftMargin: 4
                rows: 3
                columns: 3

                rowSpacing: 11
                columnSpacing: 44

                visible: true

                property int items_width_: 103
                property int items_height_: 16

                states: [
                    State {
                        name: "hide"
                        PropertyChanges {
                            target: toggleSettingsItem
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
                    Layout.row: 0; Layout.column: 0;
                    text_r.text: "Water:"

                    items_width: toggle_settings_layout.items_width_
                    items_height: toggle_settings_layout.items_height_

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

                RightMenus_CheckBoxItem{
                    Layout.row: 1; Layout.column: 0;
                    text_r.text: "Object:"

                    items_width: toggle_settings_layout.items_width_
                    items_height: toggle_settings_layout.items_height_

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

                RightMenus_CheckBoxItem{
                    Layout.row: 2; Layout.column: 0;
                    text_r.text: "Tree:"

                    items_width: toggle_settings_layout.items_width_
                    items_height: toggle_settings_layout.items_height_

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

                RightMenus_CheckBoxItem{
                    Layout.row: 0; Layout.column: 1;
                    text_r.text: "Terrain:"

                    items_width: toggle_settings_layout.items_width_
                    items_height: toggle_settings_layout.items_height_

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

                RightMenus_CheckBoxItem{
                    Layout.row: 1; Layout.column: 1;
                    text_r.text: "Collision:"

                    items_width: toggle_settings_layout.items_width_
                    items_height: toggle_settings_layout.items_height_

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

                RightMenus_CheckBoxItem{
                    Layout.row: 2; Layout.column: 1;
                    text_r.text: "Grass:"

                    items_width: toggle_settings_layout.items_width_
                    items_height: toggle_settings_layout.items_height_

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

                RightMenus_CheckBoxItem{
                    Layout.row: 0; Layout.column: 2;
                    text_r.text: "FX:"

                    items_width: toggle_settings_layout.items_width_
                    items_height: toggle_settings_layout.items_height_

                    checkboxButton.mouseAreas.onClicked: {
                        //tue etwas, wenn button geklickt wird
                    }
                }

            }


        }

    }

    Component {
        id: cameraSettings
        /*Rectangle {
            width: main_page_ref.scene_width
            height: 31 + 226
            color: "yellow"
        }*/

        RightMenus_1_SCENE_Item{
            id: cameraSettingsItem
            width: main_page_ref.scene_width
            height: 31 + 226

            property alias settings_layout: camera_settings_layout //es muss verändert werden.

            page_title.text: "CAMERA SETTINGS"

            GridLayout{
                id: camera_settings_layout
                anchors.top: page_title_bg.bottom
                anchors.topMargin: 9
                anchors.left: page_title_bg.left
                anchors.leftMargin: 4
                rows: 6
                columns: 1

                rowSpacing: 11

                visible: true

                property int items_width_: page_title_bg.width
                property int items_height_: 26

                states: [
                    State {
                        name: "hide"
                        PropertyChanges {
                            target: cameraSettingsItem
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


                RightMenus_SliderItem{
                    Layout.row: 0; Layout.column: 0;
                    text_property_name.text: "Movement Speed:"

                    unit: "m"

                    items_width: camera_settings_layout.items_width_
                    items_height: camera_settings_layout.items_height_

                    slider.value: main_rightmenu.currentScene.cam.movementSpeed

                    /*slider.onValueChanged: {
                        console.log("movement value degisiyor.")
                        console.log("movement value " + main_rightmenu.currentScene.cam.movementSpeed)
                        main_rightmenu.currentScene.cam.movementSpeed = slider.value
                    }*/

                    slider.onMoved: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value
                        main_rightmenu.currentScene.cam.movementSpeed = slider.value
                    }
                }

                RightMenus_SliderItem{
                    Layout.row: 1; Layout.column: 0;
                    text_property_name.text: "Rotate Speed:"

                    unit: ""

                    items_width: camera_settings_layout.items_width_
                    items_height: camera_settings_layout.items_height_

                    slider.value: main_rightmenu.currentScene.cam.rotationSpeed

                    slider.onValueChanged: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value
                        main_rightmenu.currentScene.cam.rotationSpeed = slider.value
                    }
                }

                RightMenus_SliderItem{
                    Layout.row: 2; Layout.column: 0;
                    text_property_name.text: "Field of View"

                    unit: "deg"

                    items_width: camera_settings_layout.items_width_
                    items_height: camera_settings_layout.items_height_

                    slider.value: main_rightmenu.currentScene.cam.fov

                    slider.onValueChanged: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value
                        main_rightmenu.currentScene.cam.fov = slider.value
                    }
                }

                RightMenus_SliderItem{
                    Layout.row: 3; Layout.column: 0;
                    text_property_name.text: "Focal Length:"

                    unit: "mm"

                    disabled: true

                    items_width: camera_settings_layout.items_width_
                    items_height: camera_settings_layout.items_height_


                    slider.onValueChanged: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value
                    }
                }

                RightMenus_SliderItem{
                    Layout.row: 4; Layout.column: 0;
                    text_property_name.text: "Near Distance:"

                    unit: ""

                    items_width: camera_settings_layout.items_width_
                    items_height: camera_settings_layout.items_height_

                    slider.value: main_rightmenu.currentScene.cam.nearDistance

                    slider.onValueChanged: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value
                        main_rightmenu.currentScene.cam.nearDistance = slider.value
                    }
                }

                RightMenus_SliderItem{
                    Layout.row: 5; Layout.column: 0;
                    text_property_name.text: "Far Distance:"

                    unit: ""

                    items_width: camera_settings_layout.items_width_
                    items_height: camera_settings_layout.items_height_

                    slider.value: main_rightmenu.currentScene.cam.farDistance

                    slider.onValueChanged: {
                        //tue etwas, wenn button geklickt wird
                        // deger: slider.value
                        main_rightmenu.currentScene.cam.farDistance = slider.value
                    }
                }

            }


        }
    }

    Component {
        id: pbrSettings
        /*Rectangle {
            width: main_page_ref.scene_width
            height: 31 + 88
            color: "green"
        }*/

        RightMenus_1_SCENE_Item{
            id: pbrSettingsItem
            width: main_page_ref.scene_width
            height: 31 + 88

            property alias settings_layout: pbr_settings_layout //es muss verändert werden.

            page_title.text: "PHYSICALLY BASED RENDERING"

            GridLayout{
                id: pbr_settings_layout
                anchors.top: page_title_bg.bottom
                anchors.topMargin: 9
                anchors.left: page_title_bg.left
                anchors.leftMargin: 4
                rows: 3
                columns: 3

                rowSpacing: 10
                columnSpacing: 22

                visible: true

                property int items_width_: 119
                property int items_height_: 16

                states: [
                    State {
                        name: "hide"
                        PropertyChanges {
                            target: pbrSettingsItem
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

                RightMenus_SwitchItem{
                    Layout.row: 0; Layout.column: 0;
                    text_r.text: "Base Color: "

                    items_width: pbr_settings_layout.items_width_
                    items_height: pbr_settings_layout.items_height_

                }

                RightMenus_SwitchItem{
                    Layout.row: 0; Layout.column: 1;
                    text_r.text: "Normal Map: "

                    items_width: pbr_settings_layout.items_width_
                    items_height: pbr_settings_layout.items_height_

                }

                RightMenus_SwitchItem{
                    Layout.row: 0; Layout.column: 2;
                    text_r.text: "Metalness: "

                    items_width: pbr_settings_layout.items_width_
                    items_height: pbr_settings_layout.items_height_

                }

                RightMenus_SwitchItem{
                    Layout.row: 1; Layout.column: 0;
                    text_r.text: "Rougness: "

                    items_width: pbr_settings_layout.items_width_
                    items_height: pbr_settings_layout.items_height_

                }

                RightMenus_SwitchItem{
                    Layout.row: 1; Layout.column: 1;
                    text_r.text: "Emissive: "

                    items_width: pbr_settings_layout.items_width_
                    items_height: pbr_settings_layout.items_height_

                }

                RightMenus_SwitchItem{
                    Layout.row: 1; Layout.column: 2;
                    text_r.text: "AO: "

                    items_width: pbr_settings_layout.items_width_
                    items_height: pbr_settings_layout.items_height_

                }

                RightMenus_SwitchItem{
                    Layout.row: 2; Layout.column: 0;
                    text_r.text: "Opacity: "

                    items_width: pbr_settings_layout.items_width_
                    items_height: pbr_settings_layout.items_height_

                }

            }


        }
    }

    Component {
        id: graphicSettings
        Rectangle {
            width: main_page_ref.scene_width
            height: 31 + 198 + 26
            color: "pink"
        }
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
                title: "scene_settings"
            }
            ListElement {
                title: "toggle_settings"
            }
            ListElement {
                title: "camera_settings"
            }
            ListElement {
                title: "pbr_settings"
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
                case "scene_settings": return sceneSettings
                case "toggle_settings": return toggleSettings
                case "camera_settings": return cameraSettings
                case "pbr_settings": return pbrSettings
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
