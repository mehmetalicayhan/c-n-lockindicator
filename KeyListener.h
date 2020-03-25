#ifndef KEYLISTENER_H
#define KEYLISTENER_H

#include<QObject>
#include<QProcess>
#include<QString>
#include<QDebug>
#include<QStringList>
#include<QAction>
class KeyListener : public QObject
{
    Q_OBJECT
private:
    QString stdOut;
    bool isCapsLockOpen;
    bool isNumLockOpen;

    void findCapsLockStatus(){
        auto foundString = stdOut.indexOf("Caps Lock:");
        QString status = ""+stdOut[foundString+13]+stdOut[foundString+14];
        status=="of"?isCapsLockOpen=false:isCapsLockOpen=true;
    }

    void findNumLockStatus(){
        auto foundString = stdOut.indexOf("Num Lock:");
        QString status = ""+stdOut[foundString+13]+stdOut[foundString+14];
        status=="of"?isNumLockOpen=false:isNumLockOpen=true;
    }
    void runProcess(){
        QProcess* process = new QProcess();
        // process->start("sh",QStringList()<<"-c"<<"xset q | grep Caps");
        process->start("xset q");
        process->waitForFinished();
        stdOut = process->readAllStandardOutput();
        findCapsLockStatus();
        findNumLockStatus();
        delete process;
    }

public:
    void setCapsLockStatus(){
        isCapsLockOpen=!isCapsLockOpen;
        qDebug()<<isCapsLockOpen;
    }

    KeyListener():QObject() {
        runProcess();
    }

public slots:
    bool returnCapsLockStatus(){
        runProcess();
        return isCapsLockOpen;
    }
    bool returnNumLockStatus(){
        runProcess();
        return isNumLockOpen;
    }
};
#endif // KEYLISTENER_H
