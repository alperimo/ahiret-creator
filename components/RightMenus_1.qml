import QtQuick 2.15

Rectangle {

    property int realWidth: 430

    id: rect

    width: 0

    states: [
        State {
            name: "open"
            PropertyChanges {
                target: rect

                width: rect.realWidth

            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "open"
            reversible: true

            PropertyAnimation{
                property: "width"
                duration: 400
            }
        }
    ]
}
