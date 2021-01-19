import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "../controls"
import "../delegates"
import "../models"

Item {
    id: root

    Rectangle
    {
        id: topBar
        color: Qt.darker("steelBlue", 1.4)
        radius: 5
        width: parent.width
        height: 45

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: -5

        RowLayout
        {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            spacing: 5

            Item{
                Layout.fillHeight: true
                Layout.preferredWidth: height

                Icon
                {
                    id: ico
                    color: "white"
                    size: 20
                    icon: "\uf060"

                    anchors.centerIn: parent
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: stackCurrentIndex = 2
                }
            }

            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 1
            }

            Item{
                Layout.fillHeight: true
                Layout.preferredWidth: height

                Icon
                {
                    color: "white"
                    size: 20
                    icon: "\uf4fe"

                    anchors.centerIn: parent
                }

                MouseArea
                {
                    anchors.fill: parent
                    // onClicked: stackCurrentIndex = 2
                }
            }
        }
    }

    ColumnLayout
    {
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 5

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true

            ScrollView
            {
                id: scroll
                anchors.fill: parent
                Layout.margins: 10
                clip: true
                spacing: 5

                ListView
                {
                    id: chat_list
                    width: scroll.width
                    height: scroll.height
                    spacing: 10
                    model: chatClientModel // ChatModel{ id: chatModel }
                    delegate: ChatDelegate{
                        width: chat_list.width
                        receivedMsg: _receivedMsg
                        content: body
                        date: received_on
                    }

                    Component.onCompleted: chat_list.positionViewAtEnd(chat_list.count-1, ListView.visible)
                }
            }
        }

        Rectangle{
            id: inputField
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            Layout.leftMargin: 5
            Layout.rightMargin: 5

            border.width: 1
            border.color: "grey"
            radius: height/2

            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                spacing: 5

                TextField
                {
                    id: tfield
                    color: "#0a0a2c"
                    placeholderText: "Enter Message here"
                    font.pixelSize: 12
                    clip: true

                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    Layout.alignment: Qt.AlignVCenter

                    background: Rectangle
                    {
                        color: "transparent"
                    }

                    onActiveFocusChanged: {
                        if(activeFocus)
                            inputField.border.color="#0084f9"
                        else
                            inputField.border.color="grey"
                    }
                }


                Item{
                    Layout.fillHeight: true
                    Layout.preferredWidth: height

                    Icon
                    {
                        color: "green"
                        size: 20
                        icon: "\uf1d8"

                        anchors.centerIn: parent
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {
                            if( tfield.text != "" )
                            {
                                Backend.sendReply(tfield.text)
                            }
                        }
                    }
                }

            }
        }
    }

    Connections
    {
        target: Backend

        function onDoctorsReplyStateChanged(state, info)
        {
            if(state)
            {
                // chatModel.append(JSON.parse('{"_receivedMsg": false, "body": "'+tfield.text+'", "received_on": "'+Qt.formatDateTime(new Date(), "ddd, hh:mm AP")+'"}'))
                tfield.clear();
                chat_list.positionViewAtEnd(chat_list.count-1, ListView.visible)
            }

            else {
                messagePopup.exec("warning", info)
            }
        }
    }
}
