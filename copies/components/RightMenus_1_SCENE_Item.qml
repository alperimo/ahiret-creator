//sayfadaki Scene Settings, Toggle, Camera Settings gibi alanların base'ini oluşturur.

import QtQuick 2.0

Item {
    //id: sceneSettingsItem

    //width: scene_page.scene_width
    height: 31 + 88 + 26

    property alias page_title: page_title
    property alias page_title_bg: page_title_bg

    clip: true

    Component.onCompleted: {
        console.log("page_title_bg " + page_title.text + " width " + scene_page.scene_width)
    }

    Rectangle{id: page_title_bg; width: scene_page.scene_width; height: 31; color: "#1c1c1c"
        Text{
            id: page_title; anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 6
            text: "SCENE SETTING"; font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Bold; font.styleName: Font.Normal
            color: "#d3d3d3"
        }

        CustomButtonImage{id: hideshow_sceneSettings_button; rotation: -90;
            anchors.right: parent.right; anchors.rightMargin: 8; anchors.top: parent.top; anchors.topMargin: 9;
            width: 16; height: 16; defaultImage: "../images/left_arrow.png"; hoveredImage: "../images/left_arrow.png"; clickedImage: "../images/left_arrow.png";
            colorizedImage: true;

            states: [
                State {
                    name: "hide"
                    PropertyChanges{
                        target: hideshow_sceneSettings_button
                        rotation: - 90 - 90
                    }
                }
            ]

            transitions: [
                Transition {
                    from: ""
                    to: "hide"
                    reversible: true

                    RotationAnimation{
                        duration: 200
                    }
                }
            ]

            Component.onCompleted: {
                colorize.hue_ = 216
                colorize.saturation_ = 3
                colorize.lightness_ = 67
            }

            mouseAreas.onClicked: {
                if (settings_layout.state == ""){
                    settings_layout.state = "hide"
                    //hideshow_sceneSettings_button.rotation = 180
                }
                else
                {
                    settings_layout.state = ""
                    //hideshow_sceneSettings_button.rotation = -90
                }

                hideshow_sceneSettings_button.state = settings_layout.state

            }

        }
    }
}
