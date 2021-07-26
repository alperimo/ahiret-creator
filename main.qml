import QtQuick 2.12
import QtQuick.Window 2.12
import "components"
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4
import QtQml.Models 2.15
import QtQuick.Layouts 1.15
import QtQml 2.15
import OpenGLUnderQML 1.0
import QtGraphicalEffects 1.15

import OpenGLCamera 1.0

ApplicationWindow {
    id: window
    width: 1440
    height: 880
    minimumWidth: 960
    minimumHeight: 710
    visible: true
    //title: qsTr("Ahiret Creator")

    color: "#151616"

    property int bw: 5

    flags: Qt.Window | Qt.FramelessWindowHint//| Qt.CustomizeWindowHint

    //flags: Qt.Window | Qt.CustomizeWindowHint

    property point startMousePos
    property point startWindowPos
    property size startWindowSize

    // The mouse area is just for setting the right cursor shape
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            const p = Qt.point(mouseX, mouseY);
            const b = bw + 1; // Increase the corner size slightly
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y < b || p.y >= height - b) return Qt.SizeVerCursor;
        }
        acceptedButtons: Qt.NoButton // don't handle actual events

        Keys.onPressed: {
            if (event.key === Qt.Key_Space){
                console.log("space basildi lo")
                left_menu_button1.state = "CLICKED"
            }
        }

        onClicked: {
            focus: true
        }


    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
            const p = resizeHandler.centroid.scenePressPosition;//resizeHandler.centroid.position;
            const b = bw + 1; // Increase the corner size slightly
            let e = 0;
            if (p.x < b) { e |= Qt.LeftEdge }
            if (p.x >= width - b) { e |= Qt.RightEdge }
            if (p.y < b) { e |= Qt.TopEdge }
            if (p.y >= height - b) { e |= Qt.BottomEdge }
            window.startSystemResize(e);
        }

     }

    Rectangle{
        id: rectangle
        color: "#151616"
        anchors.fill: parent
        anchors.bottomMargin: 0

        Rectangle{
            id: top_menu
            anchors.top: parent.top
            width: parent.width

            height: 29//40
            color: "#151616"

            /*Text{
                id: title_program
                text: "Ahiret Creator"
                color: "#a2a29f"
                font.family: "Verdana"
                font.pointSize: 10
                anchors.centerIn: parent
            }*/



            Item{
                width: parent.width
                height: parent.height

                anchors.top: parent.top
                anchors.right: systemButtons.left

                DragHandler{
                    id: dragHandler
                    target: null

                    onActiveChanged: if (active){
                                        window.startSystemMove()
                                     }
                }
            }

            CustomMenuBar{
                id: top_menu_bar
                x:0
                anchors.top: parent.top

                property color normalBG: "#151616" // rectangle icin.

                height: top_menu.height

                itemWidth: left_menu.width
                itemHeight: top_menu.height

                fontPixelSize: 13

                bg.color: normalBG
                hoveredBgColor: "#232424"

                textColor: "#b3b3b3"
                textHoverC: "#a0a0a0"

                property color general_menuItemHoveredColor: "#353536"
                property color general_menuItemTextColor: "#b3b3b3"
                property color general_menuItemTextHoveredColor: "#a0a0a0"

                CustomMenu{
                    title: qsTr("File")

                    /*menuItemHoveredColor: top_menu_bar.general_menuItemHoveredColor//"#5E5F60"
                    menuItemTextColor: top_menu_bar.general_menuItemTextColor
                    menuItemTextHoveredColor: top_menu_bar.general_menuItemTextHoveredColor*/

                    Action {
                        text: qsTr("Tool Bar"); checkable: true; shortcut: "CTRL+K"; onTriggered: console.log("Tool Bar Trigged!")
                    }

                    Action { text: qsTr("Side Bar"); checkable: true; enabled: false; checked: true }

                    Action { text: qsTr("Status Bar"); checkable: true; checked: true }

                    /*MenuSeparator {
                        contentItem: Rectangle {
                            implicitWidth: menuBar.menuItemWidth
                            implicitHeight: 1
                            color: menuBar.menuItemSeperatorColor
                        }
                    }*/

                    CustomMenu{
                        title: qsTr("Advanced")
                        Action { text: "Find Next"; shortcut: "CTRL+E"}
                        Action { text: "Find Previous"; shortcut: "CTRL+D" }
                        Action { text: "Replace"; shortcut: "CTRL+İ" }
                        Action { text: "Load"; shortcut: "CTRL+P" }
                    }
                }

                CustomMenu{
                    title: qsTr("Edit")
                }

                CustomMenu{
                    title: qsTr("Object")
                }

                CustomMenu{
                    title: qsTr("Plugins")
                }

                CustomMenu{
                    title: qsTr("View")
                }

                CustomMenu{
                    title: qsTr("Window")
                }

                CustomMenu{
                    title: qsTr("Library")
                }

                CustomMenu{
                    title: qsTr("Help")
                }

            }

            /*GridLayout{
                rows: 1
                columns: 8

                x: 0
                anchors.top: parent.top

                property color textColor: "#b3b3b3"
                property color textHoverC: "#a0a0a0"
                property string fontFamily: "Verdana"
                property real fontPointSize: 9

                columnSpacing: 0

                property color normalBG: "#151616" // rectangle icin.

                CustomButtonRectangle{id: top_menu_fileButton; width: left_menu.width; height: top_menu.height; textR.text: "File"; textNormalColor: parent.textColor; textHoverColor: parent.textHoverC; font.family: parent.fontFamily; font.pointSize: parent.fontPointSize; normalColor: parent.normalBG;}
                CustomButtonRectangle{id: top_menu_editButton; width: left_menu.width; height: top_menu.height; textR.text: "Edit"; textNormalColor: parent.textColor; textHoverColor: parent.textHoverC; font.family: parent.fontFamily; font.pointSize: parent.fontPointSize; normalColor: parent.normalBG;}
                CustomButtonRectangle{id: top_menu_objectButton; width: left_menu.width; height: top_menu.height; textR.text: "Object"; textNormalColor: parent.textColor; textHoverColor: parent.textHoverC; font.family: parent.fontFamily; font.pointSize: parent.fontPointSize; normalColor: parent.normalBG; }
                CustomButtonRectangle{id: top_menu_pluginsButton; width: left_menu.width; height: top_menu.height; Layout.leftMargin: 13; textR.text: "Plugins"; textNormalColor: parent.textColor; textHoverColor: parent.textHoverC; font.family: parent.fontFamily; font.pointSize: parent.fontPointSize; normalColor: parent.normalBG; }
                CustomButtonRectangle{id: top_menu_viewButton; width: left_menu.width; height: top_menu.height; textR.text: "View"; Layout.leftMargin: 5; textNormalColor: parent.textColor; textHoverColor: parent.textHoverC; font.family: parent.fontFamily; font.pointSize: parent.fontPointSize; normalColor: parent.normalBG; }
                CustomButtonRectangle{id: top_menu_windowButton; width: left_menu.width; height: top_menu.height; textR.text: "Window"; Layout.leftMargin: 10; textNormalColor: parent.textColor; textHoverColor: parent.textHoverC; font.family: parent.fontFamily; font.pointSize: parent.fontPointSize; normalColor: parent.normalBG;}
                CustomButtonRectangle{id: top_menu_libraryButton; width: left_menu.width; height: top_menu.height; textR.text: "Library"; Layout.leftMargin: 10; textNormalColor: parent.textColor; textHoverColor: parent.textHoverC; font.family: parent.fontFamily; font.pointSize: parent.fontPointSize; normalColor: parent.normalBG; }
                CustomButtonRectangle{id: top_menu_helpButton; width: left_menu.width; height: top_menu.height; textR.text: "Help"; textNormalColor: parent.textColor; textHoverColor: parent.textHoverC; font.family: parent.fontFamily; font.pointSize: parent.fontPointSize; normalColor: parent.normalBG; }

             }*/

            //CustomButtonRectangle{id: minimizeButton1; anchors.right: parent.right; anchors.top: parent.top; width: 18; height: parent.height; normalColor: "red"; textR.text: "—"; textNormalColor:"#b3b3b3"; font.pointSize: 13}

             RowLayout{
                id: systemButtons
                spacing: 5
                anchors.top: parent.top

                anchors.right: parent.right
                CustomButtonRectangle{id: minimizeButton; width: 27; height: top_menu.height; normalColor: "#151616"; textR.text: "—"; textNormalColor:"#b3b3b3"; font.pointSize: 13; mouseAreas.onClicked: {minimizeButton.state = ""; window.showMinimized()}}
                CustomButtonRectangle{id: maximizeButton; width: 27; height: top_menu.height; normalColor: "#151616"; textR.text: "+"; textNormalColor:"#b3b3b3"; font.pointSize: 13; mouseAreas.onClicked: {maximizeButton.state = ""; window.showMaximized()}}
                CustomButtonRectangle{id: closeButton; width: 27; height: top_menu.height; normalColor: "#151616"; hoveredColor: "#E81123"; textR.text: "X"; textNormalColor:"#b3b3b3"; font.pointSize: 11; font.family: "Verdana"; mouseAreas.onClicked: window.close()}
             }

             CustomComboBox{
                 width: 91
                 height: 25

                 font.pixelSize: 11

                 anchors.right: systemButtons.left
                 anchors.rightMargin: 30
                 anchors.verticalCenter: top_menu.verticalCenter
             }
        }

        Rectangle{
            id: top_menu_bottom_line
            width: top_menu.width
            anchors.top: top_menu.bottom
            height: 2
            color: "#2d2e2e"
        }


        Rectangle{
            id: left_menu
            width: 54
            height: parent.height - top_menu.height
            anchors.top: top_menu_bottom_line.bottom
            anchors.left: parent.left

            color: "#151516"

            CustomBorder
            {
                //commonBorderWidth: 1
                commonBorder: false
                lBorderwidth: 0
                rBorderwidth: 1
                tBorderwidth: 0
                bBorderwidth: 0
                borderColor: "#2d2e2e"
            }

            //Top Buttons
            GridLayout{
                rows: 11
                columns: 1
                rowSpacing: 34

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 11
                CustomButtonImage{id: left_menu_button1; width: 21; height: 21; checkable: true; rotation: 90; defaultImage: "images/left_menu_button1.png"; hoveredImage: "images/left_menu_button1.png"; clickedImage: "images/left_menu_button1.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button2; width: 18; height: 18; checkable: true; Layout.topMargin: -3; defaultImage: "images/left_menu_button2.png"; hoveredImage: "images/left_menu_button2.png"; clickedImage: "images/left_menu_button2.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button3; width: 18; height: 18; checkable: true; defaultImage: "images/left_menu_button3.png"; hoveredImage: "images/left_menu_button3.png"; clickedImage: "images/left_menu_button3.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button4; width: 18; height: 18; checkable: true; defaultImage: "images/left_menu_button4.png"; hoveredImage: "images/left_menu_button4.png"; clickedImage: "images/left_menu_button4.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button5; width: 18; height: 18; checkable: true; defaultImage: "images/left_menu_button5.png"; hoveredImage: "images/left_menu_button5.png"; clickedImage: "images/left_menu_button5.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button6; width: 18; height: 18; checkable: true; defaultImage: "images/left_menu_button6.png"; hoveredImage: "images/left_menu_button6.png"; clickedImage: "images/left_menu_button6.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button7; width: 18; height: 18; checkable: true; defaultImage: "images/left_menu_button7.png"; hoveredImage: "images/left_menu_button7.png"; clickedImage: "images/left_menu_button7.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button8; width: 18; height: 18; checkable: true; defaultImage: "images/left_menu_button8.png"; hoveredImage: "images/left_menu_button8.png"; clickedImage: "images/left_menu_button8.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button9; width: 18; height: 18; checkable: true; defaultImage: "images/left_menu_button9.png"; hoveredImage: "images/left_menu_button9.png"; clickedImage: "images/left_menu_button9.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button10; width: 18; height: 18; checkable: true; defaultImage: "images/left_menu_button10.png"; hoveredImage: "images/left_menu_button10.png"; clickedImage: "images/left_menu_button10.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button11; width: 18; height: 18; checkable: true; defaultImage: "images/left_menu_button11.png"; hoveredImage: "images/left_menu_button11.png"; clickedImage: "images/left_menu_button11.png"; colorizedImage: true}
            }

            //Bottom Buttons
            GridLayout{

                property real rowCount: 2
                property real rowSpacingValue: 34
                property real buttonsWidth: 20
                property real buttonsHeight: 20

                rows: rowCount
                columns: 1
                rowSpacing: rowSpacingValue
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom;//parent.bottom - ((rowCount*buttonsHeight) + (rowCount*rowSpacingValue) + 15)
                anchors.bottomMargin: 15
                CustomButtonImage{id: left_menu_button_bottom1; width: parent.buttonsWidth; height: parent.buttonsHeight; checkable: true; defaultImage: "images/left_menu_button_bottom1.png"; hoveredImage: "images/left_menu_button_bottom1.png"; clickedImage: "images/left_menu_button_bottom1.png"; colorizedImage: true}
                CustomButtonImage{id: left_menu_button_bottom2; width: parent.buttonsWidth; height: parent.buttonsHeight; checkable: true; defaultImage: "images/left_menu_button_bottom2.png"; hoveredImage: "images/left_menu_button_bottom2.png"; clickedImage: "images/left_menu_button_bottom2.png"; colorizedImage: true}
            }
        }

        property var rightMenusArray: []
        Rectangle{

            // RIGHT_MENU PROPERTIES
            property int rightMenuStatus : 1 // 11 menuden hangisinin secili oldugunu belirtir.
            property var rightMenuButtonsArray: []

            property real buttonsWidth: right_menu.width;
            property real buttonsHeight: 47

            id: right_menu
            width: 54
            anchors.top: top_menu_bottom_line.bottom
            //anchors.right: (rectangle.rightMenusArray.length == 0) ? right_menu1.left : rectangle.rightMenusArray[rightMenuStatus-1].left
            anchors.right: right_menu_main.left

            anchors.rightMargin: 1
            height: window.height - top_menu.height

            color: "#151516"

            CustomBorder{
                commonBorder: false
                lBorderwidth: 1
                rBorderwidth: 1
                tBorderwidth: 0
                bBorderwidth: 0
                borderColor: "#2d2e2e"
            }

            Component.onCompleted: {
                console.log("length: " + rectangle.rightMenusArray.length)
                console.log("state: " + rectangle.rightMenusArray[rightMenuStatus-1].state)
            }

            ColumnLayout{
                spacing: 10
                anchors.left: parent.left

                property color normalColor: "#151616"
                property color hoveredColor: "#232424"
                property color clickedColor: "#232424" // #212222

                property real imageWidth: 28
                property real imageHeight: 28

                /*Rectangle{
                    id: rightselected
                    width: 1
                    height: right_menu_button1.height
                    color: parent.normalColor
                    opacity: 0.0
                }

                SequentialAnimation{
                    id: rightselected_anim
                    PropertyAnimation{
                        target: rightselected
                        property: "color"
                        to: "#43b581"
                        duration: 300
                    }
                }*/

                CustomButtonRectangle{id: hideshow_button; width: right_menu.width; height: scene_menu.height; normalColor: parent.normalColor;
                    hoveredColor: parent.hoveredColor; clickedColor: parent.clickedColor; textR.text: "<"; textNormalColor:"#8b8d90";
                    textHoverColor: "#8b8d90"; font.pointSize: 18;

                    mouseAreas.onClicked: {

                        rectangle.rightMenuPanelChange(hideshow_button)
                    }
                }

                CustomButtonImageRect{
                    id: right_menu_button1; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button1.png"; hoveredImage: "images/right_menu_button1.png"; clickedImage: "images/right_menu_button1.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(1)
                    }
                }

                CustomButtonImageRect{
                    id: right_menu_button2; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button2.png"; hoveredImage: "images/right_menu_button2.png"; clickedImage: "images/right_menu_button2.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(2)
                    }
                }

                CustomButtonImageRect{
                    id: right_menu_button3; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button3.png"; hoveredImage: "images/right_menu_button3.png"; clickedImage: "images/right_menu_button3.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(3)
                    }
                }

                CustomButtonImageRect{
                    id: right_menu_button4; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button4.png"; hoveredImage: "images/right_menu_button4.png"; clickedImage: "images/right_menu_button4.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(4)
                    }

                }

                CustomButtonImageRect{
                    id: right_menu_button5; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button5.png"; hoveredImage: "images/right_menu_button5.png"; clickedImage: "images/right_menu_button5.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(5)
                    }

                }

                CustomButtonImageRect{
                    id: right_menu_button6; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button6.png"; hoveredImage: "images/right_menu_button6.png"; clickedImage: "images/right_menu_button6.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(6)
                    }
                }

                CustomButtonImageRect{
                    id: right_menu_button7; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button7.png"; hoveredImage: "images/right_menu_button7.png"; clickedImage: "images/right_menu_button7.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(7)
                    }
                }

                CustomButtonImageRect{
                    id: right_menu_button8; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button8.png"; hoveredImage: "images/right_menu_button8.png"; clickedImage: "images/right_menu_button8.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(8)
                    }

                }

                CustomButtonImageRect{
                    id: right_menu_button9; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button9.png"; hoveredImage: "images/right_menu_button9.png"; clickedImage: "images/right_menu_button9.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(9)
                    }
                }

                CustomButtonImageRect{
                    id: right_menu_button10; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button10.png"; hoveredImage: "images/right_menu_button10.png"; clickedImage: "images/right_menu_button10.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(10)
                    }

                }

                CustomButtonImageRect{
                    id: right_menu_button11; width: right_menu.buttonsWidth; height: right_menu.buttonsHeight; btnImage.width: parent.imageWidth; btnImage.height: parent.imageHeight; btnImage.anchors.centerIn: btnImage.parent; btnImage.anchors.fill: undefined; rectNormalColor: parent.normalColor; rectHoveredColor: parent.hoveredColor; rectClickedColor: parent.clickedColor; checkable_fixed: true; defaultImage: "images/right_menu_button11.png"; hoveredImage: "images/right_menu_button11.png"; clickedImage: "images/right_menu_button11.png";
                    colorizedImage: true; colorizedOnlyByClicked: true;

                    mouseAreas.onClicked: {
                        rectangle.menuStateChanged(11)
                    }
                }

                Component.onCompleted: {
                    for (var i = 1; i < 12; i++) {
                        var c = Qt.createQmlObject("import QtQuick 2.0; QtObject { function f() { return right_menu_button" + i + " } }", this, "none")
                        right_menu.rightMenuButtonsArray.push(c.f())
                        c.destroy()

                        console.log("lan: " + right_menu.rightMenuButtonsArray[i-1])
                    }

                    right_menu.rightMenuButtonsArray[(right_menu.rightMenuStatus)-1].btnImage.state = "CLICKED"
                    rectangle.rightMenusArray[(right_menu.rightMenuStatus)-1].state = "open"

                    //rectangle.menuStateChanged(1)

                }
            }
        }

        property variant guncelMenus: [1,8]

        function rightMenuPanelChange(hideshow_button){ //0:hiding, 1:showing

            var status = "";

            //if (right_menu.rightMenuStatus != 1){
            //if (!(right_menu.rightMenuStatus in rectangle.guncelMenus))

            var found = 0;
            for (var i=0; i<rectangle.guncelMenus.length; i++){
                console.log("for loop: menu" + rectangle.guncelMenus[i])
                if (right_menu.rightMenuStatus == rectangle.guncelMenus[i])
                    found = 1;
            }

            if (!found)
            {
                console.log("andere panelle sind gerade leider nicht aktiv.")
                return
            }

            if (hideshow_button.textR.text == "<")
            {
                hideshow_button.textR.text = ">"
                status = "open"
            }else{
                hideshow_button.textR.text = "<"
                status = "hide"
            }

            hideshow_button.state="" // butona basinca hala clicked state'sinde kalmasını engellemek icin...

            console.log("right menu wird " + status)

            var panel = rightMenusArray[right_menu.rightMenuStatus-1]
            console.log("right_menu.rightMenuStatus for array="+(right_menu.rightMenuStatus-1))
            right_menu_main.state = status

        }

        function menuStateChanged(newMenuStatus){
            var panel = rightMenusArray[newMenuStatus-1]

            var found = 0;
            for (var i=0; i<rectangle.guncelMenus.length; i++){
                console.log("for loop: menu" + rectangle.guncelMenus[i])
                if (newMenuStatus == rectangle.guncelMenus[i])
                    found = 1;
            }

            if (right_menu_main.state == "open" && !found)
            {
                console.log("andere panelle sind gerade leider nicht aktiv.")
                var menu = right_menu.rightMenuButtonsArray[(newMenuStatus)-1].btnImage
                menu.state = ""
                return
            }

            if (newMenuStatus != right_menu.rightMenuStatus){
                var menuOld = right_menu.rightMenuButtonsArray[(right_menu.rightMenuStatus)-1].btnImage
                var menuNew = right_menu.rightMenuButtonsArray[(newMenuStatus)-1].btnImage
                menuOld.state = ""
                menuNew.state = "CLICKED"

                // farkli menu'ye gecis icin

                rectangle.rightMenusArray[right_menu.rightMenuStatus-1].state = "hide"
                rectangle.rightMenusArray[newMenuStatus-1].state = "open"

                right_menu.rightMenuStatus = newMenuStatus
                //right_menu.anchors.right = rectangle.rightMenusArray[newMenuStatus-1].left

                console.log("right_menu.rightMenuStatus now = " + right_menu.rightMenuStatus)
            }
        }

        // START_RIGHT_MENUS

        Component.onCompleted: {
            for (var i = 1; i < 12; i++) {
                var k=i
                if (i == 1 || i == 8){

                }else{
                    k=1
                }
                var c = Qt.createQmlObject("import QtQuick 2.0; QtObject { function f() { return right_menu" + k + " } }", this, "none")
                rightMenusArray.push(c.f())
                c.destroy()
            }

            //console.log(rightMenusArray)
            //console.log("right_menu1 width: " + rightMenusArray[0].realWidth)
        }

        RightMenus{
            id: right_menu_main

            windowWidth: rectangle.width
            width: realWidth
            height: rectangle.height - (top_menu_bottom_line.height + top_menu.height)

            anchors.top: right_menu.top
            x: windowWidth
            //anchors.left: rectangle.right

            color: "#151616"

            RightMenus_1{
                id: right_menu1
                property alias currentScene: scene3D
                anchors.fill: parent
                color: "#151616"
                //anchors.top: right_menu.top
                //anchors.right: rectangle.right
            }

            RightMenus_8{
                id: right_menu8
                property alias currentScene: scene3D
                anchors.fill: parent
                color: "#151616"
                //anchors.top: right_menu.top
                //anchors.right: rectangle.right
            }

        }

        // END_RIGHT_MENUS

        Rectangle{
            id: scene_menu
            anchors.top: top_menu_bottom_line.bottom
            anchors.left: left_menu.right
            anchors.leftMargin: 1
            anchors.right: right_menu.left
            anchors.rightMargin: 1

            height: 32

            color: "#151616"

            CustomBorder{
                commonBorder: false
                lBorderwidth: 0
                rBorderwidth: 0
                tBorderwidth: 0
                bBorderwidth: 1
                borderColor: "#2d2e2e"
            }

            ColumnLayout{
                spacing: 3
                CustomButtonRectangle {

                    property alias closeButton : scene_close_1

                    id: scene_tab1_1
                    width: 134
                    height: scene_menu.height

                    normalColor: "#151616"
                    hoveredColor: "#232424"
                    clickedColor: "#232424" //secilmis tab rengi. secilmeyen için #151616

                    textR.text: "edipscene"
                    //textR.anchors.leftMargin: closeButton.width / 2

                    font.pointSize: 12
                    font.family: "Gilroy-Bold"
                    textNormalColor: "#8b8d90"
                    textHoverColor: "#ffffff"

                    checkable: true

                    state: "CLICKED"

                    Rectangle{
                        id: scene_line_1
                        width: parent.width
                        height: 2
                        anchors.top: parent.top

                        color: (parent.state == "CLICKED") ? "#43b581" : "#151616" //secilmeyenler tab icin: #151616

                        property alias clrAnim: color_anim
                        //clrAnim.running: (parent.state == "CLICKED") ? true : false

                        ColorAnimation {
                            id: color_anim
                            from: scene_line_1.color
                            to: "#43b581"
                            duration: 200
                            running: false
                        }

                    }
                    CustomButtonRectangle{id: scene_close_1; textR.text: "X"; width: 26; height: parent.height - scene_line_1.height; bg_color_hide: true; font.pointSize: 12; textNormalColor: "#8b8d90"; anchors.left: parent.left; anchors.top: scene_line_1.bottom;}
                }
            }
        }


        CustomItem {
            id: scene3D
            anchors.left: left_menu.right
            anchors.leftMargin: 1
            anchors.topMargin: 2
            anchors.top: scene_menu.bottom
            anchors.right: right_menu.left
            anchors.rightMargin: 1
            anchors.bottom: object_menu.top
            width: parent.width - 2*(left_menu.width)
            height: parent.height - top_menu.height
            opacity: 1.0

            Component.onCompleted: {
                console.log("laaaaaan: " + cam.movementSpeed)
            }

            focus: true

            onActiveFocusChanged: {
                console.log("qml 3d focus changed _ = " + focus)

                scene3D.focusChangedSignal(focus)
            }

            /*Connections{
                target: bar22
                Component.onCompleted: {
                    console.log("Connection item eklenecek")
                    bar22.addItem(yenibutton.createObject(yenibutton))
                }
            }*/


        }



        ObjectMenu{
            id: object_menu
            property alias currentScene: scene3D
            anchors.left: left_menu.right
            anchors.right: right_menu.left
            anchors.bottom: parent.bottom

        }

        /*Component{
            id: yenibutton
            TabButton {
                text: qsTr("Heyyyy")
            }
        }

        TabBar {
            id: bar22
            width: parent.width
            TabButton {
                text: qsTr("Home")
            }
            TabButton {
                text: qsTr("Discover")
            }
            TabButton {
                text: qsTr("Activity")
            }

        }*/

    }

    onActiveFocusItemChanged: print("activeFocusItem", activeFocusItem)

}
/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
