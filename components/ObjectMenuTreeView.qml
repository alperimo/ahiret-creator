import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15
import QtQml 2.15

TreeView{
    id:tree
    //visible: false

    TableViewColumn{
        title:"name"
        role:"name"
        width: tree.width
    }

    style: treeViewStyle
    selection: sel
    //Framevisible: false // hidden border
    frameVisible: false
    backgroundVisible: false
    sortIndicatorVisible: true
    headerVisible: false

    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    //__listView.flickableDirection: Flickable.VerticalFlick

    property real treeViewStyleIndentation: 20
    property real branchWidth: 15; property real branchHeight: 15
    property real rowHeight: 32;
    property real branchIsNotOnLeft: 1 // 1: true, 0: false
    property bool customBranch: true // set width of real branch to 0

    property real scrollBarWidth: 5

    itemDelegate: Item{
        id:treeItem

        CustomButtonRectangle{
            id:itemRect
            anchors.fill:parent

            anchors.topMargin: 1.5
            anchors.bottomMargin: 1.5
            anchors.leftMargin: -(tree.branchIsNotOnLeft * tree.treeViewStyleIndentation) + 7
            anchors.rightMargin: tree.scrollBarWidth + 2 + 5

            textR.text: styleData.value; textNormalColor: Style.itemTextNormalColor; textHoverColor: Style.itemTextHoveredColor; textClickedColor: Style.itemTextClickedColor
            textR.anchors.centerIn: undefined; textR.anchors.verticalCenter: textR.parent.verticalCenter; textR.anchors.left: textR.parent.left; textR.anchors.leftMargin: 38
            font.family: Style.defaultFontFamily; font.pixelSize: 13

            normalColor: Style.itemBgNormalColor
            hoveredColor: Style.itemBgHoveredColor
            clickedColor: Style.itemBgSelectedColor

            property bool expanded: false

            property string type

            checkable_fixed: true

            Rectangle{id: selected; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 2; color: "transparent"
                states: [
                    State {name: "SELECTED"; PropertyChanges { target: selected; color: Style.seamFoamGreen }}
                ]
                transitions: [Transition {ColorAnimation{duration: 100}}]

                Binding on state{when: itemRect.expanded; value: "SELECTED"; restoreMode: Binding.RestoreBinding}
                Binding on state{when: !itemRect.expanded; value: ""; restoreMode: Binding.RestoreBinding}
            }

            CustomImage{id: dirIcon; defaultImage: "qrc:/images/object_menu_folder.png"
                anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 10
                visible: (parent.type == "dir") ? true : false

                Binding { target: dirIcon.colorize; property: "hue_"; value: 0 }
                Binding { target: dirIcon.colorize; property: "saturation_"; value: 100 }
                Binding { target: dirIcon.colorize; property: "lightness_"; value: 100 }
            }

            CustomButtonImage{id: expandCollapseButton; rotation: -90;
                anchors.right: parent.right; anchors.rightMargin: 8; anchors.verticalCenter: parent.verticalCenter
                width: 16; height: 16; defaultImage: "../images/left_arrow.png"; hoveredImage: "../images/left_arrow.png"; clickedImage: "../images/left_arrow.png";
                colorizedImage: true;

                states: [State {name: "collapse"; PropertyChanges{target: expandCollapseButton; rotation: - 90 - 90}}]
                transitions: [Transition {from: ""; to: "collapse"; reversible: true; RotationAnimation{duration: 200}}]

                Component.onCompleted: {colorize.hue_ = 216; colorize.saturation_ = 3; colorize.lightness_ = 67

                }

                mouseAreas.onEntered: {itemRect.mouseAreas.entered()}

                mouseAreas.onClicked: {
                    itemRect.doubleClicked()
                }

                Binding on state{when: itemRect.expanded; value: ""; restoreMode: Binding.RestoreBinding}
                Binding on state{when: !itemRect.expanded; value: "collapse"; restoreMode: Binding.RestoreBinding}

                btnImage.visible: (styleData.hasChildren) ? true : false

            }

            //onVisibleChanged: {if (visible && !styleData.expanded && !styleData.selected) mouseAreas.exited()}

            mouseAreas.onClicked: {
                sel.setCurrentIndex(styleData.index,0x0010)

            }

            mouseAreas.onDoubleClicked: {
                doubleClicked()
            }

            Component.onCompleted: {
                type = tree.model.getIconType(styleData.index)
            }

            Binding on state {when: !styleData.selected && !itemRect.expanded; value: ""; restoreMode: Binding.RestoreBinding}
            Binding on state {when: itemRect.expanded; value: "CLICKED"; restoreMode: Binding.RestoreBinding}

            function doubleClicked(){
                if (!styleData.hasChildren) return

                if (styleData.isExpanded)
                {
                    expanded = false
                    tree.collapse(styleData.index)
                    state = ""
                    dirIcon.opacityAnimToNull.running = true
                }
                else
                {
                    expanded = true
                    tree.expand(styleData.index)
                    dirIcon.opacityAnimToFull.running = true
                }
            }

        }
    }

    Component{
        id:treeViewStyle
        TreeViewStyle // Tree Custom Style
        {
            indentation: tree.treeViewStyleIndentation // node first shrinkage
            backgroundColor: "transparent" // Background transparent

            branchDelegate:
                Rectangle
                {
                    id:image
                    //source: styleData.isExpanded?"./down.png":"./right.png"// triangular icon
                    color: styleData.isExpanded ? "yellow" : "red"
                    width:(tree.customBranch) ? 0 : tree.branchWidth
                    height: tree.branchHeight
                }
            rowDelegate:Item{
                id:rowRec
                height:tree.rowHeight // high
            }

            handle: Rectangle
            {
                implicitWidth: tree.scrollBarWidth
                implicitHeight: 2
                anchors.leftMargin: 1
                anchors.left: parent.left
                color: Style.scrollHandleColor
            }

            scrollBarBackground: Rectangle
            {
                implicitWidth: tree.scrollBarWidth
                anchors.right: parent.right
                color: Style.scrollBgColor
            }

            incrementControl: null
            decrementControl: null

        }
    }

    onClicked: {

    }

    function getColor(index){
        return "white"
        /*var type = tree.model.getType(index)
        if(type == "Country")
        {
            return "#4a8fba"
        }
        else if(type == "Province")
        {
            return "#f0af72"
        }
        else if(type == "Municipality")
        {
            return "#d48484"
        }
        else if(type == "City")
        {
            return "#92d791"
        }
        else if(type == "District")
        {
            return "#de8ad5"
        }
        else
        {
            return "#bbbbbb"
        }*/
    }
}
