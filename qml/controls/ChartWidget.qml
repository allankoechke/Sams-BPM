import QtQuick 2.12
import QtCharts 2.3
import QtQuick.Layouts 1.3

ChartView
{
    antialiasing: true
    margins.left: 0
    margins.right: 0
    margins.top: 0
    margins.bottom: 0
    backgroundColor: "white"

    legend.labelColor: "black"
    legend.font: Qt.font({pixelSize: 8})
    legend.markerShape: Legend.MarkerShapeCircle

    ValueAxis
    {
        id: xAxis
        tickCount: 30
        visible: false
    }

    ValueAxis
    {
        id: yAxis
        labelFormat: "%.0f"
        labelsColor: "black"
        min: 30; max: 110
        labelsFont:Qt.font({pointSize: 6})
    }

    AreaSeries
    {
        name: "Heart Beats (bpm)"
        axisX: xAxis
        axisY: yAxis
        upperSeries: LineSeries{
            id: bpmGraph

            XYPoint { x: 0; y: 72 }
            XYPoint { x: 1; y: 67 }
            XYPoint { x: 2; y: 78 }
            XYPoint { x: 3; y: 86 }
            XYPoint { x: 4; y: 77 }
            XYPoint { x: 5; y: 97 }
            XYPoint { x: 6; y: 80 }
            XYPoint { x: 7; y: 78 }
            XYPoint { x: 8; y: 67 }
            XYPoint { x: 9; y: 68 }
            XYPoint { x: 10; y: 72 }
            XYPoint { x: 11; y: 67 }
            XYPoint { x: 12; y: 78 }
            XYPoint { x: 13; y: 86 }
            XYPoint { x: 14; y: 77 }
            XYPoint { x: 15; y: 97 }
            XYPoint { x: 16; y: 80 }
            XYPoint { x: 17; y: 78 }
            XYPoint { x: 18; y: 67 }
            XYPoint { x: 19; y: 68 }
            XYPoint { x: 20; y: 72 }
            XYPoint { x: 21; y: 67 }
            XYPoint { x: 22; y: 78 }
            XYPoint { x: 23; y: 86 }
            XYPoint { x: 24; y: 77 }
            XYPoint { x: 25; y: 97 }
            XYPoint { x: 26; y: 80 }
            XYPoint { x: 27; y: 78 }
            XYPoint { x: 28; y: 67 }
            XYPoint { x: 29; y: 68 }
        }
    }

    Connections
    {
        target: Backend

        function onChartDataReceived(data)
        {
            var xVal = bpmGraph.at(29).x + 1

            xAxis.min = xVal-29
            xAxis.max = xVal

            bpmGraph.remove(0)
            bpmGraph.append(xVal, parseFloat(data))
        }
    }
}

