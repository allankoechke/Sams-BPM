import QtQuick 2.12
import QtQuick.Controls 2.4

Label {
    id: root

    property alias icon: root.text
    property alias size: root.font.pixelSize

    color: "black"
    font.pixelSize: 15
    font.family: fontAwesomeFontLoader.name
}
