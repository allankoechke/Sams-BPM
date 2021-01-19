import QtQuick 2.0
import QtQuick.Controls 2.4

TextField
{
    color: "#0a0a2c"
    placeholderText: "Enter Username"
    font.pixelSize: 12

    background: Rectangle
    {
        id: rec
        radius: height/2
        border.width: 1
        border.color: "grey"
    }

    onActiveFocusChanged: {
        if(activeFocus)
            rec.border.color="#0084f9"
        else
            rec.border.color="grey"
    }
}

