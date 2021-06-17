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


    Component {
        id: sceneSettings

        Item {
            id: sceneSettingsItem
            width: scene_page.scene_width
            height: 31 + 88 + 26

            clip: true

            Rectangle{id: page_title_bg; width: scene_page.scene_width; height: 31; color: "#1c1c1c"
                Text{id: page_title_scene; anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 6
                    text: "SCENE SETTING"; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Bold; font.styleName: Font.Normal
                    color: "#d3d3d3"
                }

                CustomButtonImage{id: hideshow_sceneSettings_button; rotation: 90;
                    anchors.right: parent.right; anchors.rightMargin: 8; anchors.top: parent.top; anchors.topMargin: 9;
                    width: 16; height: 16; defaultImage: "../images/left_arrow.png"; hoveredImage: "../images/left_arrow.png"; clickedImage: "../images/left_arrow.png";
                    colorizedImage: true;

                    Component.onCompleted: {
                        colorize.hue_ = 216
                        colorize.saturation_ = 3
                        colorize.lightness_ = 67
                    }

                    mouseAreas.onClicked: {
                        if (scene_settings_layout.state == ""){
                            scene_settings_layout.state = "hide"
                            hideshow_sceneSettings_button.rotation = -90
                        }
                        else
                        {
                            scene_settings_layout.state = ""
                            hideshow_sceneSettings_button.rotation = 90
                        }
                    }
                }
            }

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

                states: [
                    State {
                        name: "hide"
                        PropertyChanges {
                            target: sceneSettingsItem
                            height: 31
                        }
                        /*PropertyChanges{
                            target: scene_settings_layout
                            anchors.bottomMargin: scene_settings_layout.height
                        }*/
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

                Item{Layout.row: 0; Layout.column: 0; width: parent.items_width; height: parent.items_height
                    Text{
                        text: "Ambient Occlusion"; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
                        color: "#767676"
                    }
                    CustomButtonImageRect{
                        anchors.right: parent.right
                        id: ambient_occlusion_button; width: scene_settings_layout.checkbox_width; height: scene_settings_layout.checkbox_height;
                        btnImage.scale: 0.75; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined;
                        rectNormalColor: scene_settings_layout.checkbox_normalColor; rectHoveredColor: scene_settings_layout.checkbox_hoveredColor; rectClickedColor: scene_settings_layout.checkbox_clickedColor;
                        defaultImage: scene_settings_layout.checkbox_defaultImage; hoveredImage: scene_settings_layout.checkbox_hoveredImage; clickedImage: scene_settings_layout.checkbox_clickedImage;
                        checkable: true;

                        mouseAreas.onClicked: {
                            //
                        }
                    }
                }

                Item{Layout.row: 1; Layout.column: 0; width: parent.items_width; height: parent.items_height
                    Text{
                        text: "White Balance"; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
                        color: "#767676"
                    }

                    CustomButtonImageRect{
                        anchors.right: parent.right
                        id: white_balance_button; width: scene_settings_layout.checkbox_width; height: scene_settings_layout.checkbox_height;
                        btnImage.scale: 0.75; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined;
                        rectNormalColor: scene_settings_layout.checkbox_normalColor; rectHoveredColor: scene_settings_layout.checkbox_hoveredColor; rectClickedColor: scene_settings_layout.checkbox_clickedColor;
                        defaultImage: scene_settings_layout.checkbox_defaultImage; hoveredImage: scene_settings_layout.checkbox_hoveredImage; clickedImage: scene_settings_layout.checkbox_clickedImage;
                        checkable: true

                        mouseAreas.onClicked: {
                            //
                        }
                    }
                }

                Item{Layout.row: 2; Layout.column: 0; width: parent.items_width; height: parent.items_height
                    Text{
                        text: "Atmospere"; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Normal; font.styleName: Font.Normal
                        color: "#767676"
                    }

                    CustomButtonImageRect{
                        anchors.right: parent.right
                        id: atmospere_button; width: scene_settings_layout.checkbox_width; height: scene_settings_layout.checkbox_height;
                        btnImage.scale: 0.75; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined;
                        rectNormalColor: scene_settings_layout.checkbox_normalColor; rectHoveredColor: scene_settings_layout.checkbox_hoveredColor; rectClickedColor: scene_settings_layout.checkbox_clickedColor;
                        defaultImage: scene_settings_layout.checkbox_defaultImage; hoveredImage: scene_settings_layout.checkbox_hoveredImage; clickedImage: scene_settings_layout.checkbox_clickedImage;
                        checkable: true

                        mouseAreas.onClicked: {
                            //
                        }
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
        Rectangle {
            width: scene_page.scene_width
            height: 31 + 88
            color: "blue"
            opacity: 0.1
        }
    }

    Component {
        id: cameraSettings
        Rectangle {
            width: scene_page.scene_width
            height: 31 + 226
            color: "yellow"
        }
    }

    Component {
        id: pbrSettings
        Rectangle {
            width: scene_page.scene_width
            height: 31 + 88
            color: "green"
        }
    }

    Component {
        id: graphicSettings
        Rectangle {
            width: scene_page.scene_width
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
