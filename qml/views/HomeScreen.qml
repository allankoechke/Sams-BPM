import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "../controls"

Item {
    id: root

    ScrollView
    {
        id: scroll
        width: root.width
        height: root.height
        clip: true

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5

        // Component.onCompleted: console.log("Width x Height: ", scroll.width,"x",scroll.height)

        ListView
        {
            width: scroll.width
            height: scroll.height
            model: 1
            delegate: Component {

                ColumnLayout
                {
                    width: scroll.width
                    height: 500
                    spacing: 5

                    Item{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 300

                        Item{
                            height: 40
                            width: parent.width

                            anchors.top: parent.top
                            anchors.topMargin: 20

                            Text {
                                text: "Statistics for: "
                                font.pixelSize: 12
                                color: "black"

                                anchors.right: combo.left
                                anchors.rightMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            ComboBox
                            {
                                id: combo
                                height: 40
                                width: 120
                                font.pixelSize: 12
                                model: ["Today","This Week"]

                                anchors.right: parent.right
                                anchors.rightMargin: 20
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        ChartWidget
                        {
                            width: parent.width
                            height: 250
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 5
                        }
                    }

                    Item
                    {
                        Layout.preferredWidth: root.width*0.7
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignHCenter

                        ColumnLayout
                        {
                            anchors.fill: parent
                            spacing: 5

                            VitalWidget
                            {
                                text: "Min BPM: " + Backend.minBPM
                            }

                            VitalWidget
                            {
                                text: "Max BPM: " + Backend.maxBPM
                            }

                            VitalWidget
                            {
                                text: "Avg. BPM: " + Backend.avgBPM
                            }

                        }
                    }
                }
            }
        }
    }
}
