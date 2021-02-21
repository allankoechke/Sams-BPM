#include "socketclientinterface.h"

SocketClientInterface::SocketClientInterface(QObject *parent) : QObject(parent)
{
    m_server = new QTcpServer(this);
    m_socket = new QTcpSocket(this);
}

void SocketClientInterface::initServer()
{
    // In doctor mode, close the server
    if(m_server->isListening())
    {
        m_server->close();
    }

    if(m_socket->isOpen())
        qDebug() << "Client socket open";

    connect(m_socket, &QTcpSocket::readyRead, this, &SocketClientInterface::onReadyRead);
    // connect(m_socket, &QTcpSocket::disconnected, this, &SocketClientInterface::onReadyWrite);
    m_socket->connectToHost(QHostAddress::LocalHost,9999);
}

void SocketClientInterface::initClient()
{
    if(m_server->listen(QHostAddress::Any, 9999))
    {
        if(m_server->isListening())
            qDebug() << "Server started";

        connect(m_server, &QTcpServer::newConnection, this, &SocketClientInterface::onNewConnection);
    }
}

void SocketClientInterface::onNewConnection()
{
    while (m_server->hasPendingConnections())
    {
        QTcpSocket *clientSocket = m_server->nextPendingConnection();
        connect(clientSocket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
        // connect(clientSocket, SIGNAL(readyWrite()), this, SLOT(onReadyWrite()));
        connect(clientSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)), this, SLOT(onSocketStateChanged(QAbstractSocket::SocketState)));

        m_sockets.push_back(clientSocket);
    }
}

void SocketClientInterface::onSocketStateChanged(QAbstractSocket::SocketState socketState)
{
    if (socketState == QAbstractSocket::UnconnectedState)
    {
        QTcpSocket* sender = static_cast<QTcpSocket*>(QObject::sender());
        m_sockets.removeOne(sender);
        sender->deleteLater();
        emit socketDisconnected();
    }
}

void SocketClientInterface::onReadyRead()
{
    QTcpSocket* sender = static_cast<QTcpSocket*>(QObject::sender());
    QByteArray _d = sender->readAll();
    QString datas = _d.data();
    qDebug() << "Received: " << datas;

    emit vitalsStringReceived(datas);
}

void SocketClientInterface::onReadyWrite(const QJsonObject &obj)
{

}

void SocketClientInterface::onSocketStatusChanged(QString state)
{
    Q_UNUSED(state)
}
