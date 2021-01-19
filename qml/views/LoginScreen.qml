import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../controls"

Item {
    id: root

    property alias enteredUsername: _uname.text
    property alias enteredPassword: _pswd.text
    property string infoString: ""

    Item
    {
        height: 180
        width: root.width*0.8
        anchors.centerIn: parent

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 10

            Text {
                text: "Login below to proceed"
                font.pixelSize: 15
                font.bold: true
                color: "black"

                Layout.alignment: Qt.AlignLeft
            }

            CircularTextField
            {
                id: _uname
                placeholderText: "Enter Username"

                Layout.fillWidth: true
                Layout.preferredHeight: 40
            }

            CircularTextField
            {
                id: _pswd
                placeholderText: "Enter Password"
                echoMode: TextField.Password

                Layout.fillWidth: true
                Layout.preferredHeight: 40
            }

            Rectangle
            {
                color: "#0084f9"
                radius: height/2

                Layout.preferredWidth: 150
                Layout.preferredHeight: 35
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: Backend.awaitingLoginReply? qsTr("Signing In"):qsTr("Sign In")
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
                    icon: Backend.awaitingLoginReply? "\uf021":"\uf061"

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 15

                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        if( enteredUsername.length<4 && enteredPassword.length<4 )
                        {
                            infoString="Userame and Password are short"
                            messagePopup.exec("warning", infoString)
                        }

                        else if( enteredUsername.length<4 )
                        {
                            infoString="Userame too short!"
                            messagePopup.exec("warning", infoString)
                        }

                        else if( enteredPassword.length<4 )
                        {
                            infoString="Password too short!"
                            messagePopup.exec("warning", infoString)
                        }

                        else{
                            Backend.loginUser(enteredUsername, enteredPassword);
                            Backend.awaitingLoginReply=true;
                        }
                    }
                }
            }

            Text {
                text: Backend.doctorMode? "I'm not a doctor":"I'm a doctor"
                font.pixelSize: 12
                color: "black"

                Layout.alignment: Qt.AlignHCenter

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        if(!Backend.awaitingLoginReply)
                            Backend.doctorMode = !Backend.doctorMode
                    }
                }
            }

            // Handle animations
            Timer
            {
                id: loginTimer
                interval: 2500
                running: false // ro_anim.running
                repeat: false

                onTriggered: {
                    Backend.awaitingLoginReply=false
                    stackCurrentIndex = 2
                }
            }

            RotationAnimation
            {
                id: ro_anim
                target: ico
                from: 0; to: 360
                running: Backend.awaitingLoginReply
                duration: 700
                loops: RotationAnimation.Infinite
                onStopped: ico.rotation=0
            }
        }
    }

    Connections
    {
        target: Backend

        function onLoginStatusChanged(status, info, isDoc)
        {
            Backend.awaitingLoginReply=false

            if(status)
            {
                stackCurrentIndex = 2 ;
                Backend.doctorMode = isDoc;
                Backend.isLoggedIn = true;
            }
             else
            {
                messagePopup.exec("warning", info);
            }
        }

        function onLoggedInUser(userJson)
        {
            loggedUserEmail = userJson["email"]
            loggedUserName = userJson["name"]
            loggedUsername = userJson["uname"]
            loggedUserAge = userJson["age"]
        }
    }
}
