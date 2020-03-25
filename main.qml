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
    SystemTrayIcon {
        id: systemTrayIcon
        visible: true
        iconSource: isCapsLock ? "qrc:/assets/lockOn.png" : "qrc:/assets/lockOff.png"
        menu: Menu {
            MenuItem {
                text: qsTr("Show")
                onTriggered: myWindow.show()
            }
            MenuItem {
                text: qsTr("Hide")
                onTriggered: myWindow.hide()
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
        iconSource: isNumLock ? "qrc:/assets/numLockOn.png" : "qrc:/assets/numLockOff.png"
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
            isCapsLock = kl.returnCapsLockStatus()
            isNumLock = kl.returnNumLockStatus()
        }

    }

    Timer {
        id: timer
        interval: 500
        repeat:true

        onTriggered: {
            isCapsLock=kl.returnCapsLockStatus()
            isNumLock = kl.returnNumLockStatus()

        }
    }

    //    Shortcut {
    //        sequence: "CapsLock"
    //        context: Qt.ApplicationShortcut
    //        onActivated:{
    //            isCapsLock=!isCapsLock
    //        }

    //    }

    //    Shortcut {
    //        sequence: "NumLock"
    //        context: Qt.ApplicationShortcut
    //        onActivated:{
    //            isNumLock=!isNumLock
    //        }

    //    }

    Component.onCompleted:{
        //myWindow.hide()
        timer.running=true;
    }

}
