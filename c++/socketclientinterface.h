#ifndef SOCKETCLIENTINTERFACE_H
#define SOCKETCLIENTINTERFACE_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QAbstractSocket>
#include <QJsonObject>

class SocketClientInterface : public QObject
{
    Q_OBJECT
public:
    explicit SocketClientInterface(QObject *parent = nullptr);
    void initServer();
    void initClient();

signals:
    void vitalsStringReceived(const QString &vitalString);
    void socketDisconnected();

private slots:
    void onNewConnection();
    void onSocketStateChanged(QAbstractSocket::SocketState socketState);
    void onReadyRead();
    void onReadyWrite(const QJsonObject &obj);

public slots:
    void onSocketStatusChanged(QString state);

private:
    QTcpServer * m_server;
    QTcpSocket * m_socket;
    QList<QTcpSocket*>  m_sockets;
};

#endif // SOCKETCLIENTINTERFACE_H
