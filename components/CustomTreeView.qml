import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.15

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



    /*Binding {
        target: tree.flickableItem
        property: "contentY"
        value: (tree.flickableItem.contentHeight + 16) * vbar.position - (16 * (1 - vbar.position))
    }

    ScrollBar {
        id: vbar
        z: 100
        orientation: Qt.Vertical
        anchors.top: tree.top
        anchors.left: tree.right
        anchors.bottom: tree.bottom
        active: true
        contentItem: Rectangle {
            id:contentItem_rect2
            radius: implicitHeight/2
            color: "Red"
            width: 10 // This will be overridden by the width of the scrollbar
            height: 10 // This will be overridden based on the size of the scrollbar
        }
        size: (tree.height) / (tree.flickableItem.contentItem.height)
        width: 10
    }*/

    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    //__listView.flickableDirection: Flickable.VerticalFlick

    property real treeViewStyleIndentation: 20
    property real branchWidth: 15; property real branchHeight: 15
    property real rowHeight: 33;
    property real branchIsNotOnLeft: 1 // 1: true, 0: false
    property bool customBranch: true // set width of real branch to 0

    property real scrollBarWidth: 5



    itemDelegate: Item{
        id:treeItem
        Rectangle{
            id:itemRect
            anchors.fill:parent
                             // Implement the interval effect by setting the upper and lower margins of the item with respect to the upper and lower margins of the item
                             // If only the single margin can cause the rounded rectangle to offset up or down, and the text is not vertical, it needs to be positioned, it is very troublesome
                             // The upper and lower edges are set to the desired range of 1/2, the item is high as the height of the original high + up and down margins.
            anchors.topMargin: 1.5
            anchors.bottomMargin: 1.5
            anchors.leftMargin: -(tree.branchIsNotOnLeft * tree.treeViewStyleIndentation)
            anchors.rightMargin: tree.scrollBarWidth + 2
            radius:5
            color:styleData.selected?"#8abcdb":getColor(styleData.index)

            Component.onCompleted: {
                console.log("name: " + styleData.value + " width: " + width)
            }
        }
        Text{
            id:itemText
            anchors.fill: parent
            anchors.leftMargin: -(tree.branchIsNotOnLeft * tree.treeViewStyleIndentation)
            anchors.rightMargin: tree.scrollBarWidth + 2

            //text:styleData.selected?styleData.value:"red"//styleData.value
            //text: styleData.isExpanded ? "\u25bc" : "\u25b6"
            text: styleData.value

            Component.onCompleted: {
                console.log("styleData.value: ")
            }

            font.family: "Microsoft Yaishi"
            color: "red" // styledata.selected? "# 3742db": "# ffffff" // Select time text color switch
            font.pointSize: 11 // StyleData.selected? 12: 11 // Select the time text Switch
            verticalAlignment: Text.AlignVCenter
            //horizontalAlignment: Text.AlignRight
            MouseArea{
                id:itemMouse
                hoverEnabled: true
                anchors.fill:parent
                drag.target: itemText // This sentence is not clear what mean, but after coming out, if the mouse is pressed and released, it will trigger the option.
                onPressed: {

                }
                onReleased: {

                }
                onClicked: {
                    sel.setCurrentIndex(styleData.index,0x0010)// Click on the text, select this node
                    console.log("test lannn: " + tree.model.datax(styleData.index));
                    console.log("test lannn2dd: " + styleData.value);
                    //console.log("styleData.value: " + tree.model.datax(styleData.index).value)
                }
                onDoubleClicked: {
                    if (styleData.isexpanded) // Switching Node Expand Status
                    {
                        tree.collapse(styleData.index)
                    }
                    else
                    {
                        tree.expand(styleData.index)
                    }
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
            rowDelegate:Rectangle{
                id:rowRec
                height:tree.rowHeight // high
                color:"green"// Background transparency
            }

            handle: Rectangle
            {
                implicitWidth: tree.scrollBarWidth
                implicitHeight: 2
                radius: 10
                anchors.leftMargin: 1
                anchors.left: parent.left
                color: "yellow"
            }

            scrollBarBackground: Rectangle
            {
                implicitWidth: tree.scrollBarWidth
                anchors.right: parent.right
                color: "transparent"
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
