import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../controls"

Item {
    id: root
    height: bodyTxt.paintedHeight+dt_txt.paintedHeight+25

    property bool receivedMsg: false
    property alias content: bodyTxt.text
    property string date: new Date()

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 5

        Rectangle
        {
            id: p_rect
            Layout.minimumHeight: 50
            Layout.minimumWidth: 50
            color: receivedMsg? "#008b60":"#e9e9e9"
            radius: 5


            Layout.alignment: receivedMsg? Qt.AlignLeft:Qt.AlignRight

            ColumnLayout
            {
                anchors.fill: parent
                anchors.margins: 3
                spacing: 5

                Text {
                    id: bodyTxt
                    font.pixelSize: 12
                    color: receivedMsg? "white":"#2e2e2e"
                    wrapMode: Text.WordWrap

                    horizontalAlignment: Text.AlignLeft

                    Component.onCompleted: {
                        if(bodyTxt.paintedWidth>root.width*0.7)
                        {
                            Layout.preferredWidth = root.width*0.7-6
                            p_rect.Layout.preferredWidth = root.width*0.7
                            p_rect.Layout.minimumHeight = bodyTxt.paintedHeight+dt_txt.paintedHeight+15
                        }

                        else
                        {
                            if(dt_txt.paintedWidth > bodyTxt.paintedWidth)
                            {
                                Layout.preferredWidth = dt_txt.paintedWidth+6
                                p_rect.Layout.preferredWidth = dt_txt.paintedWidth+18
                            }

                            else
                            {
                                Layout.preferredWidth = bodyTxt.paintedWidth+6
                                p_rect.Layout.preferredWidth = bodyTxt.width+18
                                p_rect.Layout.preferredHeight = bodyTxt.paintedHeight+dt_txt.paintedHeight+15
                            }
                        }

                        // p_rect.Layout.preferredHeight = bodyTxt.paintedHeight+dt_txt.paintedHeight+15
                        root.height = bodyTxt.height+dt_txt.height+25
                    }
                }

                Text {
                    id: dt_txt
                    text: date // Qt.formatDateTime(new Date(), "ddd, hh:mm AP")
                    font.pixelSize: 10
                    font.italic: true
                    color: receivedMsg? "white":"black"

                    Layout.alignment: receivedMsg? Qt.AlignLeft:Qt.AlignRight
                }
            }
        }
    }
}
