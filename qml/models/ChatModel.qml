import QtQuick 2.12

ListModel {
    ListElement
    {
        _receivedMsg: true
        body: "Take regular sleep"
        received_on: "2020-01-01T10:05:000"
    }

    ListElement
    {
        _receivedMsg: true
        body: "Buy some depressant drugs"
        received_on: "2020-01-01T10:15:000"
    }

    ListElement
    {
        _receivedMsg: false
        body: "Okay doc, will do so ASAP!"
        received_on: "2020-01-01T10:20:000"
    }

    ListElement
    {
        _receivedMsg: false
        body: "What about the drugs you had prescribed before, am not yet through with the dosage?"
        received_on: "2020-01-01T10:25:000"
    }

    ListElement
    {
        _receivedMsg: true
        body: "You still have to take that, keep that in mind!"
        received_on: "2020-01-01T10:45:000"
    }

    ListElement
    {
        _receivedMsg: true
        body: "And take plenty of water as well!"
        received_on: "2020-01-01T10:45:100"
    }

    ListElement
    {
        _receivedMsg: false
        body: "Okay"
        received_on: "2020-01-01T10:05:000"
    }

    ListElement
    {
        _receivedMsg: false
        body: "Have a good day!"
        received_on: "2020-01-01T11:05:000"
    }
}
