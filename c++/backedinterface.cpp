#include "backedinterface.h"

BackendInterface::BackendInterface(QObject *parent) : QObject(parent)
{
    m_doctorSyncTimer = new QTimer(this);
    m_doctorSyncTimer->setInterval(5000);
    connect(m_doctorSyncTimer, &QTimer::timeout, this, &BackendInterface::onDoctorSynctTimerTimeout);

    m_plotValTimer = new QTimer(this);
    m_plotValTimer->setInterval(5000);
    connect(m_plotValTimer, &QTimer::timeout, this, &BackendInterface::onPlotValTimerTimerTimeout);

    m_shuffle = new QTimer(this);
    m_shuffle->setInterval(5000);
    m_shuffle->start();
    connect(m_shuffle, &QTimer::timeout, this, [=](){
        if(m_isLoggedIn && !m_doctorMode)
            std::random_shuffle(m_plotData.begin(), m_plotData.end());
    });

    applicationDir=qApp->applicationDirPath();

    qApp->setApplicationName("ECG Health App");
    qApp->setApplicationVersion("1.0.0");
    qApp->setApplicationDisplayName("ECG Health App");
    qApp->setOrganizationName("lalanke");
    qApp->setWindowIcon(QIcon(":/assets/images/icon.png"));
    qApp->setOrganizationDomain("lalanke.com");
    settings = new QSettings(qApp->organizationName(),qApp->applicationDisplayName());

    m_ThreadPool.setMaxThreadCount(5);

    // Connect the signals and slots
    connect(this, &BackendInterface::sendToCloudChanged, this, &BackendInterface::connect2Web);
    connect(this, &BackendInterface::chatStrReceived, this, &BackendInterface::onChatStrReceived);
    connect(this, &BackendInterface::bpmStrReceived, this, &BackendInterface::onBpmStrReceived);

    // addEcgRecord(67);
    m_doctorSyncTimer->start();
    m_plotValTimer->start();
    onDoctorSynctTimerTimeout();

    // socket = new SocketClientInterface(this);
}

BackendInterface::~BackendInterface()
{
    delete settings;
    delete m_doctorSyncTimer;
    delete m_plotValTimer;
    delete m_shuffle;
}

void BackendInterface::connect2Web(const QString &state, const QJsonObject &data)
{
    bool m_isOnline = true;

    if(!m_isOnline)
    {
        // m_isOnline = true;
        emit isOnlineChanged(true);
    }

    WebInterfaceRunnable * web = new WebInterfaceRunnable(this);
    connect(web, &WebInterfaceRunnable::finished, this, &BackendInterface::onWebRunnableFinished);

    web->setValues( state, data);

    m_ThreadPool.start(web);
}

void BackendInterface::loginUser(const QString &uname, const QString &pswd)
{
    m_loggedUserPass = pswd;

    QJsonObject userObj, contentObj;
    contentObj.insert("email", uname);
    userObj.insert("state", "GetUser");
    userObj.insert("content", contentObj);

    emit sendToCloudChanged("GetUser", userObj);
}

int BackendInterface::getTimerIntervalBetweenSync()
{
    return QDateTime::currentSecsSinceEpoch() - m_previousSyncDateTime.toSecsSinceEpoch();
}


void BackendInterface::sendReply(const QString &str)
{
    QJsonObject getRecordObj, getContentObj;
    getContentObj.insert("date", QDateTime::currentSecsSinceEpoch());
    getContentObj.insert("body", str);
    getContentObj.insert("fromDoctor", m_doctorMode);
    getRecordObj.insert("state", "AddEcgDoctorsReply");
    getRecordObj.insert("content", getContentObj);
    m_GetHealthRecordJson = getRecordObj;

    emit sendToCloudChanged("AddEcgDoctorsReply", getRecordObj);
}


QString BackendInterface::hashPassword(const QString &pswd)
{
    QString salt = QString::number(QDateTime::currentSecsSinceEpoch());
    QCryptographicHash hash(QCryptographicHash::Sha3_256);
    hash.addData(pswd.toUtf8() + salt.toUtf8());
    QString hashedP = hash.result().toHex()+":"+salt;
    // qDebug() << "Hashed! = " << hashedP;
    // lalan = bda84ebcb0d5cdf3cc2b14cfbf02a3d7d67eb8df8e3d9e62e478ada3effd313a:1609077498
    return hashedP;
}

bool BackendInterface::checkHashedPassword(const QString &pswd, const QString &hashedPswd)
{
    QString _pswd = hashedPswd.split(":").at(0);
    QString _salt = hashedPswd.split(":").at(1);

    QCryptographicHash hash(QCryptographicHash::Sha3_256);
    hash.addData(pswd.toUtf8() + _salt.toUtf8());

    if(hash.result().toHex() == _pswd)
        return true;

    else
        return false;
}

int BackendInterface::minBPM() const
{
    return m_minBPM;
}

int BackendInterface::maxBPM() const
{
    return m_maxBPM;
}

int BackendInterface::avgBPM() const
{
    return m_avgBPM;
}

QList<int> BackendInterface::plotData() const
{
    return m_plotData;
}

void BackendInterface::onWebRunnableFinished(const QString &str)
{
    QJsonDocument doc = QJsonDocument::fromJson(str.toUtf8());
    QJsonObject replyObj = doc.object();

    QString state = replyObj["state"].toString();
    qDebug() << "State: " << state;

    if(state=="GetUser")
    {
        if( replyObj["Status"].toString() == "Success" )
        {
            if( replyObj["user"].toString()=="null" )
            {
                emit loginStatusChanged(false, "Couldn't fetch user details!", false);
            }

            else
            {
                QJsonDocument doc = QJsonDocument::fromJson(replyObj["user"].toString().toUtf8());
                QJsonObject userJson = doc.object();
                QString _pswd = userJson["password"].toString();
                auto loginStatus = checkHashedPassword(m_loggedUserPass, _pswd);

                if( loginStatus )
                {
                    emit loginStatusChanged(true, "", userJson["role"]=="doctor");
                    // Capture loggged in user details here
                    userJson["uname"]=userJson["email"];
                    emit loggedInUser(userJson);

                    if(userJson["role"]=="doctor")
                    {
                        // Doctor logging in
                        // socket->initClient();
                    }

                    else
                    {
                        // User logged in
                        // socket->initServer();
                    }
                }
                else
                    emit loginStatusChanged(false, "Invalid Login Details", false);
            }
        }

        else
        {
            emit loginStatusChanged(false, "No internet connection", false);
        }
    }

    else if(state=="AddEcgRecord")
    {
        qDebug() << "Add ECG Record Feedback";

        if( replyObj["Status"].toString() == "Success" )
        {

        }

        else
        {
            qDebug() << "Erroe!";
        }
    }

    else if(state=="SyncRecords")
    {
        qDebug() << "Sync Records Feedback";

        if( replyObj["Status"].toString() == "Success" )
        {
            auto contentStr = replyObj["content"].toString().split("\n");
            QString chats_str = contentStr.at(0);
            QString bpm_str = contentStr.at(1);

            lastSyncTime = _lastSyncTime;

            emit chatStrReceived(chats_str);
            emit bpmStrReceived(bpm_str);
        }
    }

    else if(state=="AddEcgDoctorsReply")
    {
        qDebug() << "Adding Doctor's Reply -> " << replyObj["Status"].toString();

        if( replyObj["Status"].toString() == "Success" )
            emit doctorsReplyStateChanged(true, "Added Successfully");

        else
            emit doctorsReplyStateChanged(false, "Empty Reply Received");
    }

    else
    {
        qDebug() << "Unknown Feedback";
    }
}


void BackendInterface::onEcgDataReceived(const QString &str)
{
    // Guard from empy string splitting which crashes the app
    if( str != "" )
    {
        QStringList v = str.split(":");

        qDebug() << "Vitals: " << str;
    }
}

void BackendInterface::onDoctorSynctTimerTimeout()
{
    qDebug() << "Starting Sync ...";
    // Remove the exclamation
    if(m_isLoggedIn)
    {
        _lastSyncTime = QDateTime::currentSecsSinceEpoch();
        QJsonObject getRecordObj, getContentObj;
        getContentObj.insert("start", lastSyncTime);
        getContentObj.insert("end", _lastSyncTime);
        getRecordObj.insert("state", "SyncRecords");
        getRecordObj.insert("content", getContentObj);
        m_GetHealthRecordJson = getRecordObj;

        emit sendToCloudChanged("SyncRecords", getRecordObj);
    }
    qDebug() << "--> sync End ...";
}

void BackendInterface::addEcgRecord(int bpm)
{
    QJsonObject getRecordObj, getContentObj;
    getContentObj.insert("bpm", bpm);
    getContentObj.insert("date", QDateTime::currentSecsSinceEpoch());
    getRecordObj.insert("state", "AddEcgRecord");
    getRecordObj.insert("content", getContentObj);

    emit sendToCloudChanged("AddEcgRecord", getRecordObj);
}

void BackendInterface::signOut()
{
    lastSyncTime=_lastSyncTime=0;
}

void BackendInterface::setMinBPM(int minBPM)
{
    if (m_minBPM == minBPM)
        return;

    m_minBPM = minBPM;
    emit minBPMChanged(m_minBPM);
}

void BackendInterface::setMaxBPM(int maxBPM)
{
    if (m_maxBPM == maxBPM)
        return;

    m_maxBPM = maxBPM;
    emit maxBPMChanged(m_maxBPM);
}

void BackendInterface::setAvgBPM(int avgBPM)
{
    if (m_avgBPM == avgBPM)
        return;

    m_avgBPM = avgBPM;
    emit avgBPMChanged(m_avgBPM);
}

void BackendInterface::onChatStrReceived(QString chats_str)
{
    qDebug() << "Chat data received ...";

    try{
        // make a json object from the reply string
        chats_str = "{\"data\":" + chats_str+"}";

        QJsonDocument jsonResponse = QJsonDocument::fromJson(chats_str.toUtf8());
        QJsonObject jsonObject = jsonResponse.object();
        QJsonValue value = jsonObject.value("data");
        QJsonArray array = value.toArray();

        qDebug() << "New Chats: " << array.count();

        foreach (const QJsonValue & value, array)
        {
            QJsonObject jobj = value.toObject();
            // qDebug() << jobj.value(QString("fromDoctor")).toBool();
            bool state = m_doctorMode? !jobj.value(QString("fromDoctor")).toBool():jobj.value(QString("fromDoctor")).toBool();
            QString dt = QDateTime::fromSecsSinceEpoch(jobj.value(QString("fromDoctor")).toDouble()).toString("ddd, hh:mm AP");
            emit chatMessageReceived(state, jobj.value(QString("body")).toString(), dt);
        }
    }

    catch (std::exception &e)
    {
        qDebug() << "Error 1: " << e.what();
    }

    qDebug() << "Chat data end ...";
}

void BackendInterface::onBpmStrReceived(QString bpm_str)
{
    qDebug() << "Starting BPM Sync ...";

    try{
        bpm_str = "{\"data\":" + bpm_str+"}";

        QJsonDocument jsonResponse = QJsonDocument::fromJson(bpm_str.toUtf8());
        QJsonObject jsonObject = jsonResponse.object();
        QJsonValue value = jsonObject.value("data");
        QJsonArray array = value.toArray();

        qDebug() << "New Data points: " << array.count();

        foreach (const QJsonValue & value, array)
        {
            QJsonObject jobj = value.toObject();
            auto val = jobj.value(QString("bpm")).toInt();
            emit chartDataReceived(jobj.value(QString("bpm")).toInt());

            if(m_data.size() >= 30)
                m_data.removeFirst();

            m_data.append(val);

            auto mm = std::minmax_element(m_data.begin(), m_data.end());
            setMaxBPM(*mm.second);
            setMinBPM(*mm.first);

            setAvgBPM((maxBPM()+minBPM())/2);
        }
    }

    catch (std::exception &e)
    {
        qDebug() << "Error 1: " << e.what();
    }

    qDebug() << "Ending BPM Sync ...";
}

void BackendInterface::onPlotValTimerTimerTimeout()
{
    qDebug() << "Getting new data point ...";

    if(m_isLoggedIn && !m_doctorMode)
    {
        try {
            qDebug() << "Index: " << plot_index << "\tData" << m_plotData.size();

            if(plot_index<0)
                plot_index=0;


            if(plot_index>=m_plotData.size())
            {
                plot_index=0;
            }

            qDebug() << "== " << plot_index;

            addEcgRecord(m_plotData.at(plot_index));
            plot_index++;
        }

        catch (std::exception &e)
        {
            qDebug() << "Error: " << e.what();
        }
    }

    qDebug() << "Ending new data point ...";
}
void BackendInterface::setPlotData(QList<int> plotDaa)
{
    if (m_plotData == plotDaa)
        return;

    m_plotData = plotDaa;
    emit plotDataChanged(m_plotData);
}

