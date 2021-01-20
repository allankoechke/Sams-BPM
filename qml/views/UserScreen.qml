import QtQuick 2.12
import QtQuick.Layouts 1.3

import "../controls"

Item {
    id: root

    ColumnLayout
    {
        anchors.fill: parent
        anchors.bottomMargin: 20
        anchors.topMargin: 20
        spacing: 5

        Icon
        {
            width: 100
            height: 100
            size: 100
            color: "steelBlue"
            icon: "\uf508"

            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            id: name
            text: loggedUserName
            font.pixelSize: 12
            font.bold: true
            color: "black"

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
        }

        Text {
            id: age
            text: "Age: "+ loggedUserAge + " yrs"
            font.pixelSize: 12
            font.bold: true
            color: "black"

            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            id: deviceId
            text: Backend.doctorMode? "Role: Doctor":"Role: User"
            font.pixelSize: 12
            font.bold: true
            color: "black"

            horizontalAlignment: Text.AlignLeft
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: (deviceId.width>deviceStatus.width)? deviceId.width:deviceStatus.width
            Layout.topMargin: 10
        }

        Text {
            id: deviceStatus
            text: Backend.doctorMode? "Email: "+loggedUserEmail:"Device Status: Online"
            font.pixelSize: 12
            font.bold: true
            color: "black"

            horizontalAlignment: Text.AlignLeft
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: (deviceId.width>deviceStatus.width)? deviceId.width:deviceStatus.width
        }

        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Rectangle
        {
            color: "#0084f9"
            radius: height/2

            Layout.preferredWidth: 150
            Layout.preferredHeight: 35
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 20

            Text {
                text: qsTr("Sign Out")
                font.pixelSize: 12
                font.bold: true
                color: "white"

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15
            }

            Icon
            {
                id: ico
                color: "white"
                size: 15
                icon: "\uf061"

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 15

            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    Backend.isLoggedIn = false;
                    Backend.signOut();
                    stackCurrentIndex=1
                }
            }
        }
    }

}
