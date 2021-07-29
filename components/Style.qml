pragma Singleton

import QtQuick 2.15

QtObject {
    property color themeBgColor: "#151616"
    property color themeLineColor: "#2d2e2e"

    property color seamFoamGreen: "#43b581"

    property string defaultFontFamily: "Segoe UI"
    property string defaultTextColor: "#767676"

    //objectMenu
    property color itemBgNormalColor: "transparent"
    property color itemBgHoveredColor: "#121212"
    property color itemBgSelectedColor: "#1c1c1c"

    property color itemTextNormalColor: "#8b8d90"
    property color itemTextHoveredColor: "#9fa1a4"
    property color itemTextClickedColor: "#ffffff"

    property color scrollBgColor: themeLineColor
    property color scrollHandleColor: "#5e5f5f"
}
