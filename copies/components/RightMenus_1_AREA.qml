import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15

//AREA-page
Item{
    id: area_page
    anchors.fill: parent
    anchors.topMargin: 9.5
    anchors.leftMargin: 12
    anchors.rightMargin: 12
    property int scene_width: width
    property int scene_height: height

    property alias main_page_ref: area_page

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
        id: basicLightSettings

        Rectangle {
            width: area_page.scene_width
            height: 31 + 198 + 26
            color: "yellow"
        }

        /*RightMenus_1_SCENE_Item{
            id: basicLightSettingsItem

            width: main_page_ref.scene_width
            height: 31 + 226

            page_title.text: "MAP DETAILS"

            Rectangle{
                anchors.fill: parent
                anchors.top: parent.page_title_bg.bottom
                color: "green"
            }
        }*/
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
                title: "basic_lighting_settings"
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

}
