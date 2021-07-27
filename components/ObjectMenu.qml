import QtQuick 2.15
import QtQml.Models 2.15

Rectangle {
    id: main

    color: Style.themeBgColor
    height: 314

    Rectangle{id: left_line; width: 1; height: parent.height; anchors.left: parent.left; color: Style.themeLineColor}
    Rectangle{id: right_line; width: 1; height: parent.height; anchors.right: parent.right; color: Style.themeLineColor}

    Item{
        id: top_bar
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50

        Rectangle{id: top_line; width: parent.width; height: 2; anchors.top: parent.top; color: Style.themeLineColor }
        Rectangle{id: bottom_line; width: parent.width; height: 1; anchors.bottom: parent.bottom; color: Style.themeLineColor }


    }

    ObjectMenuTreeView{
        id: customview
        anchors.left: parent.left
        anchors.top: top_bar.bottom
        anchors.bottom: parent.bottom
        width: 264
        model: currentScene.fileSystemNew
        //rootIndex: scene3D.fileSystem.rootPathIndex

        ItemSelectionModel {
            id: sel
            model: currentScene.fileSystemNew
        }
    }

}
