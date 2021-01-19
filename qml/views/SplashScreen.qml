import QtQuick 2.12
import QtQuick.Layouts 1.3

import "../controls"

Item {

    id: root

    Timer
    {
        id: loginTimer
        interval: 3000
        running: true
        repeat: false

        onTriggered: {
            loginBox.visible = true
            spinRotationAnimation.stop()
            spinner.visible = false
            illustrationSplash.width= 200
        }

    }

    RotationAnimation
    {
        id: spinRotationAnimation
        target: spin
        from: 0; to: 360
        running: true
        duration: 1000
        loops: RotationAnimation.Infinite
    }

    Item
    {
        id: loginBox
        width: root.width*0.8
        height: 80
        visible: false

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: illustrationSplash.bottom
        anchors.topMargin: 5

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 10

            Text {
                text: "Hello, " + (Qt.formatTime(new Date(), "hh")<12? "Goodmorning":Qt.formatTime(new Date(), "hh")<15? "Goodafternoon":"Goodevening")
                font.pixelSize: 22
                font.bold: true

                Layout.alignment: Qt.AlignLeft
            }

            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 60

                Rectangle
                {
                    color: "#0084f9"
                    radius: 5
                    width: (parent.width/2)-10
                    height: 30

                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: t1
                        text: qsTr("I am a doctor")
                        font.pixelSize: 12
                        color: "white"

                        anchors.centerIn: parent
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {
                            Backend.doctorMode=true
                            stackCurrentIndex=1
                        }
                    }
                }

                Rectangle
                {
                    color: "#0084f9"
                    radius: 5
                    width: (parent.width/2)-10
                    height: 30

                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: t2
                        text: qsTr("I am not a doctor")
                        font.pixelSize: 12
                        color: "white"

                        anchors.centerIn: parent
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {
                            Backend.doctorMode=false
                            stackCurrentIndex=1
                        }
                    }
                }
            }
        }

    }

    Image {
        id: illustrationSplash
        source: "qrc:/assets/images/Health _Flatline.png"
        width: root.width
        height: width

        anchors.bottom: spinner.top
        anchors.bottomMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle
    {
        id: spinner
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 100

        width: 60; height: 60
        radius: height/2
        color: "steelBlue"

        Icon
        {
            id: spin
            color: "white"
            size: 50
            icon: "\uf3f4"

            anchors.centerIn: parent
        }
    }
}
