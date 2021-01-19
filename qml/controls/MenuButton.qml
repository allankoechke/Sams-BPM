import QtQuick 2.0

Item
{
    id: root
    property bool isSelected: false
    property alias icon: ico.icon

    signal clicked()

    Rectangle
    {
        width: root.width
        height: 3
        color: isSelected? "orange":"transparent"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    Icon
    {
        id: ico
        anchors.centerIn: parent

        color: isSelected? "orange":"white"
        size: isSelected? 30:25
        icon: "\uf085"
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
