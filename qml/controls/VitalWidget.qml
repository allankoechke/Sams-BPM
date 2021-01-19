import QtQuick 2.0
import QtQuick.Layouts 1.3

Rectangle
{
    color: "blue"
    radius: 10

    Layout.fillWidth: true
    Layout.preferredHeight: 60

    property alias text: txt.text

    Icon
    {
        color: "white"
        size: 25
        icon: "\uf21e"

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

    Text {
        id: txt
        font.pixelSize: 15
        font.bold: true
        color: "white"

        anchors.centerIn: parent
    }
}
