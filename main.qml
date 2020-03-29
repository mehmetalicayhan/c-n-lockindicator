import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import org.lockstatus.keylistener 1.0
import Qt.labs.platform 1.0

Window {
    property bool isCapsLock
    property bool isNumLock
    property int previousX
    property int previousY
    id:myWindow
    visible: true
    width: 200
    height: 150
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"

    function parseStatus(stdOutStatus){
        const arrStatus = stdOutStatus.split(',');
        arrStatus[0] = arrStatus[0]==="true"?true:false;
        arrStatus[1] = arrStatus[1]==="true"?true:false;
        return arrStatus;
    }

    function setStatus(){
        const status = parseStatus(kl.returnStatus());
        isCapsLock = status[0]
        isNumLock = status[1]
    }

    SystemTrayIcon {
        id: systemTrayIcon
        visible: true
        iconSource: isCapsLock ? "qrc:/assets/cLockOn.png" : "qrc:/assets/cLockOff.png"
        menu: Menu {
            MenuItem {
                text: qsTr("Show/Hide")
                onTriggered:{
                    if(myWindow.visible){
                        myWindow.hide()
                    } else {
                        myWindow.show()
                    }
                }
            }

            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }

        }
    }
    SystemTrayIcon {
        id: systemTrayIcon2
        visible: true
        iconSource: isNumLock ? "qrc:/assets/nLockOn.png" : "qrc:/assets/nLockOff.png"
        menu: Menu {
        }

    }
    Rectangle {

        focus: true
        color: "lightgray"
        anchors.fill: parent
        anchors.margins: 10
        radius: 15



        Switch{
            y:30
            anchors.horizontalCenter: parent.horizontalCenter
            id:capsStatus
            checked: isCapsLock
            text: "CapsLock"
            checkable: false
        }


        Switch{
            y:70

            anchors.horizontalCenter: parent.horizontalCenter
            text: "NumLock"
            id:numStatus
            checked: isNumLock
            checkable: false
        }


        MouseArea {
            anchors.fill: parent

            onPressed: {
                previousX = mouseX
                previousY = mouseY
            }

            onMouseXChanged: {
                var dx = mouseX - previousX
                myWindow.setX(myWindow.x + dx)
            }

            onMouseYChanged: {
                var dy = mouseY - previousY
                myWindow.setY(myWindow.y + dy)
            }

        }
    }
    KeyListener{
        id:kl
        Component.onCompleted:
        {
            setStatus()

        }

    }

    Timer {
        id: timer
        interval: 500
        repeat:true

        onTriggered: {
            setStatus()
            // isCapsLock=kl.returnCapsLockStatus()
            // isNumLock = kl.returnNumLockStatus()

        }
    }



    Component.onCompleted:{
        //myWindow.hide()
        timer.running=true;
    }

}
