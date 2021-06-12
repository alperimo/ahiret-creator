import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import MyTreeModel 1.0

Rectangle {

    property int realWidth: 430
    property int windowWidth: 0

    property bool borderVisible: false

    id: rect

    x: windowWidth
    visible: false

    opacity: 0

    states: [

        State {
            name: "hide"
            PropertyChanges {
                id: hideChanges
                target: rect

                opacity: 0
                visible: true
                borderVisible: false
            }
        },

        State {
            name: "open"
            PropertyChanges {
                target: rect

                x: windowWidth - realWidth
                opacity: 1
                visible: true
                borderVisible : false
            }
            /*PropertyChanges {
                target: areaButton.borders
                visible: false
            }*/
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "open"

            PropertyAnimation{
                properties: "x,opacity"
                duration: 120


            }

            onRunningChanged: if (!running) rect.borderVisible = true

        },

        Transition {
            from: "hide"
            to: "open"

            PropertyAnimation{
                properties: "x,opacity"
                duration: 120


            }

            onRunningChanged: if (!running) rect.borderVisible = true


        },

        Transition {
            from: "open"
            to: "hide"

            PropertyAnimation{
                properties: "x,opacity"
                duration: 100
            }

            onRunningChanged: {
                if(!running){
                    rect.visible = false


                    console.log("rect.borderVisible on hiding: " + rect.borderVisible)
                }
            }

        }
    ]

    Rectangle{
        anchors.left: pageButtons.left; anchors.right: rect.right; anchors.rightMargin: 12; anchors.top: pageButtons.bottom;
        height: pageButtons.pgB_bBorderwidth; color: "#2d2e2e"
    }

    RowLayout{
        id: pageButtons
        spacing: 22
        anchors.left: parent.left
        anchors.leftMargin: 9.3
        anchors.top: parent.top
        anchors.topMargin: 1

        //button height: 38.5
        property int pbBWidth: 56 //pageButton
        property real pbBHeight: 35.5

        property color pgB_normalColor: parent.color
        property color pgB_hoveredColor: parent.color
        property color pgB_clickedColor: parent.color

        property color pgB_textNormalColor: "#8b8d90"
        property color pgB_textHoveredColor: "#43b581"

        property color pgB_borderNormalColor: "#2d2e2e"
        property color pgB_borderHoveredColor: "#43b581"

        property int pgB_bBorderwidth: 2

        CustomButtonRectangle{id: areaButton; width: parent.pbBWidth; height: parent.pbBHeight; mouseAreaForText: true
            normalColor: parent.pgB_normalColor; hoveredColor: parent.pgB_hoveredColor; clickedColor: parent.pgB_clickedColor;
            textR.text: "AREA"; textNormalColor: parent.pgB_textNormalColor; textHoverColor: parent.pgB_textHoveredColor;
            borders.visible: rect.borderVisible; borders.bBorderwidth: parent.pgB_bBorderwidth; borderNormalColor: parent.pgB_borderNormalColor; borderHoveredColor: parent.pgB_borderHoveredColor;
            font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Bold; font.styleName: Font.Normal;
            checkable_fixed: true; mouseAreas.onClicked: changePage("AREA")
        }

        CustomButtonRectangle{id: sceneButton; width: parent.pbBWidth; height: parent.pbBHeight; mouseAreaForText: true
            normalColor: parent.pgB_normalColor; hoveredColor: parent.pgB_hoveredColor; clickedColor: parent.pgB_clickedColor;
            textR.text: "SCENE"; textNormalColor: parent.pgB_textNormalColor; textHoverColor: parent.pgB_textHoveredColor;
            borders.visible: rect.borderVisible; borders.bBorderwidth: parent.pgB_bBorderwidth; borderNormalColor: parent.pgB_borderNormalColor; borderHoveredColor: parent.pgB_borderHoveredColor;
            font.family: "Gilroy"; font.pixelSize: 12; font.weight: Font.Bold; font.styleName: Font.Normal;
            checkable_fixed: true; mouseAreas.onClicked: changePage("SCENE")
        }
    }

    Item{
        id: mainPage
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: pageButtons.bottom
        anchors.topMargin: 4
        anchors.bottom: parent.bottom
        property string currentPage: ""

        Component.onCompleted: {
            changePage("AREA")
            console.log("Item completed")
        }

        states: [
            State {
                name: "AREA"
                PropertyChanges {
                    target: area_page
                    visible: true
                    opacity: 1
                }
                PropertyChanges {
                    target: scene_page
                    visible: false
                    opacity: 0
                }
            },

            State {
                name: "SCENE"
                PropertyChanges {
                    target: area_page
                    visible: false
                    opacity: 0
                }
                PropertyChanges {
                    target: scene_page
                    visible: true
                    opacity: 1
                }

            }
        ]

        transitions: [
            Transition {
                from: "AREA"
                to: "SCENE"
                reversible: true

                PropertyAnimation{
                    properties: "visible,opacity"
                    duration: 300
                }
            }
        ]

        //AREA-page
        Item{
            id: area_page
            anchors.fill: parent
            Rectangle{
                width: 404
                height: 31
                anchors.top: parent.top
                anchors.topMargin: 9.5
                anchors.left: parent.left
                anchors.leftMargin: 14
                anchors.right: parent.right
                anchors.rightMargin: 12
                color: "#1c1c1c"
                Text{
                    id: page_title_area
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    text: "MAP DETAILS"
                    font.family: "Gilroy"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    font.styleName: Font.Normal
                    color: "#d3d3d3"
                }
            }
        }

        //SCENE-page
        Item{
            id: scene_page
            anchors.fill: parent
            anchors.topMargin: 9.5
            anchors.leftMargin: 14
            anchors.rightMargin: 12
            property int scene_width: parent.width
            property int scene_height: parent.height

            Component {
                id: sceneSettings
                Rectangle {
                    width: scene_page.scene_width
                    height: 31 + 88 + 26
                    color: "red"

                    CustomButtonRectangle{id: closeButton; x: 10; y:55; width: 27; height: 25; normalColor: "#151616"; hoveredColor: "#E81123"; textR.text: "X"; textNormalColor:"#b3b3b3"; font.pointSize: 11; font.family: "Verdana"}

                }
            }

            Component {
                id: toggleSettings
                Rectangle {
                    width: scene_page.scene_width
                    height: 31 + 88
                    color: "blue"
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

                MouseArea{
                    anchors.fill: parent

                    hoverEnabled: true
                    onEntered: {
                        console.log("listView onEntered loooo")
                        listView.hovered = true
                    }

                    onExited: {
                        listView.hovered = false
                        console.log("listView onExited looo")
                    }
                }

                clip: true
                focus: true

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

                ScrollBar.vertical: ScrollBar {
                    parent: listView.parent
                    anchors.top: listView.top
                    anchors.left: listView.right
                    anchors.bottom: listView.bottom
                    hoverEnabled: true
                    active: listView.hovered || hovered || pressed
                    policy: ScrollBar.AsNeeded

                }

                //ScrollBar.vertical: ScrollBar {}
            }

            /*Rectangle{
                width: 404
                height: 31
                anchors.top: parent.top
                anchors.topMargin: 9.5
                anchors.left: parent.left
                anchors.leftMargin: 14
                anchors.right: parent.right
                anchors.rightMargin: 12
                color: "#1c1c1c"
                Text{
                    id: page_title_scene
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    text: "SCENE SETTING"
                    font.family: "Gilroy"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    font.styleName: Font.Normal
                    color: "#d3d3d3"
                }
            }*/

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


    }

    function changePage(newPage){

        if (newPage != mainPage.currentPage)
            mainPage.currentPage = newPage
        else
            return

        areaButton.state = ""
        sceneButton.state = ""

        if (newPage == "AREA")
        {
            areaButton.state = "CLICKED"
            mainPage.state = "AREA"
        }
        else if (newPage == "SCENE"){
            sceneButton.state = "CLICKED"
            mainPage.state = "SCENE"
        }
    }


}
