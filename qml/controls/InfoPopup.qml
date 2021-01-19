import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../controls"

Popup {
    id: root
    height: 70
    width: 200
    modal: true

    // closePolicy: "NoAutoClose"
    x: (mainApp.width-width)/2
    y: (mainApp.height-height)/2

    property alias text: body.text
    property string level: "info"

    background: Rectangle{

    }

    contentItem: ColumnLayout
    {
        anchors.fill: parent
        spacing: 1

        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            Icon{
                icon: level==="info"? "\uf0eb":"\uf671"
                color: level==="info"? "green":"red"
                size: 20

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
            }

            Text {
                text: level==="info"? qsTr("Info"):qsTr("Warning")
                color: "#2e2e2e"
                font.pixelSize: 12
                textFormat: Text.StyledText

                anchors.centerIn: parent
            }
        }

        Rectangle
        {
            color: "grey"

            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }

        Text {
            id: body
            text: qsTr("Info Content")
            color: "#2e2e2e"
            font.pixelSize: 12
            textFormat: Text.StyledText
            wrapMode: Text.WordWrap

            Layout.margins: 10
            Layout.fillWidth: true
            Layout.minimumHeight: 20

            Component.onCompleted: {
                height= paintedHeight+5
                Layout.minimumHeight = paintedHeight+5
                root.height = body.paintedHeight+70
            }
        }

        /*Rectangle
        {
            radius: 5
            color: "#2e3337"
            Layout.preferredHeight: 35
            Layout.preferredWidth: 100
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 10

            Text {
                text: qsTr("Close")
                color: "white"
                font.bold: true
                font.pixelSize: 10

                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: root.close()
            }
        }
    */
    }
}
