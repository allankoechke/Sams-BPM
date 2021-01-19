import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "./views"
import "./controls"

Window {
    id: mainApp
    width: 320
    height: 568
    visible: true
    title: qsTr("App")

    property alias stackCurrentIndex: stackView.currentIndex
    property alias fontAwesomeFontLoader: fontAwesome
    property int currentMenuIndex: 0
    property alias messagePopup: messagePopup
    property bool userLoggedIn: false
    property string loggedUserEmail: ""
    property string loggedUserName: ""
    property string loggedUsername: ""
    property int loggedUserAge: 0
    property alias chatClientModel: chatClientModel

    // Load 1st screen when the component has been completed
    // Component.onCompleted: switchScreens()

    // Invoke switching screens when the stack index changes
    // onStackCurrentIndexChanged: switchScreens();

    StackLayout {
        id: stackView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: menu.top
        currentIndex: 0

        SplashScreen{}

        LoginScreen{}

        HomeScreen{}

        DoctorPatientScreen{}

        SettingsScreen{}

        UserScreen{}
    }

    Rectangle
    {
        id: menu
        color: "steelBlue"
        radius: 3
        width: parent.width
        height: stackCurrentIndex===3? 0:60
        visible: stackCurrentIndex >= 2 && stackCurrentIndex!==3

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: stackCurrentIndex===3? 3:-3

        RowLayout
        {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            MenuButton
            {
                Layout.fillHeight: true
                Layout.fillWidth: true

                icon: "\uf21e"
                isSelected: stackCurrentIndex===2
                onClicked: stackCurrentIndex=2
            }

            MenuButton
            {
                Layout.fillHeight: true
                Layout.fillWidth: true

                icon: "\uf82e"
                isSelected: stackCurrentIndex===3
                onClicked: stackCurrentIndex=3
            }

            MenuButton
            {
                Layout.fillHeight: true
                Layout.fillWidth: true

                icon: "\uf085"
                isSelected: stackCurrentIndex===4
                onClicked: stackCurrentIndex=4
            }

            MenuButton
            {
                Layout.fillHeight: true
                Layout.fillWidth: true

                icon: "\uf2bd"
                isSelected: stackCurrentIndex===5
                onClicked: stackCurrentIndex=5
            }
        }
    }

    FontLoader
    {
        id: fontAwesome
        source: "qrc:/assets/fonts/fontawesome.otf"
    }

    InfoPopup
    {
        id: messagePopup

        function exec(l, message)
        {
            text = message;
            level = level;
            open();
        }
    }

    ListModel
    {
        id: chatClientModel
    }

    Connections
    {
        target: Backend

        function onChatMessageReceived(fromDoc, msg, dt)
        {
            chatClientModel.append(JSON.parse('{"_receivedMsg": '+(!fromDoc&&Backend.doctorMode)+', "body":"'+msg+'", "received_on": "'+dt+'"}'));
        }

        function onIsLoggedInChanged(state)
        {
            if(!state)
            {
                chatClientModel.clear();
            }
        }
    }
}
