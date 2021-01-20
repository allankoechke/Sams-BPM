#ifndef BACKEDINTERFACE_H
#define BACKEDINTERFACE_H

#include <QObject>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QCryptographicHash>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QThreadPool>
#include <QIcon>
#include <QTimer>
#include <QSettings>
#include <QGuiApplication>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

#include "WebInterfaceRunnable.h"

class BackendInterface : public QObject
{
    Q_OBJECT

public:
    explicit BackendInterface(QObject *parent = nullptr);
    ~BackendInterface();

    Q_PROPERTY(bool doctorMode MEMBER m_doctorMode NOTIFY doctorModeChanged)
    Q_PROPERTY(bool awaitingLoginReply MEMBER m_awaitingLoginReply NOTIFY awaitingLoginReplyChanged)
    Q_PROPERTY(int minBPM READ minBPM WRITE setMinBPM NOTIFY minBPMChanged)
    Q_PROPERTY(int maxBPM READ maxBPM WRITE setMaxBPM NOTIFY maxBPMChanged)
    Q_PROPERTY(int avgBPM READ avgBPM WRITE setAvgBPM NOTIFY avgBPMChanged)
    Q_PROPERTY(bool isLoggedIn MEMBER m_isLoggedIn NOTIFY isLoggedInChanged)
    Q_PROPERTY(QList<int> plotData READ plotData WRITE setPlotData NOTIFY plotDataChanged)

    Q_INVOKABLE void connect2Web(const QString &state, const QJsonObject &data);
    Q_INVOKABLE void loginUser(const QString &uname, const QString &pswd);
    Q_INVOKABLE int getTimerIntervalBetweenSync();
    Q_INVOKABLE void sendReply(const QString &str);
    Q_INVOKABLE void addEcgRecord(int bpm);
    Q_INVOKABLE void signOut();

    QString hashPassword(const QString &pswd);
    bool checkHashedPassword(const QString &pswd, const QString &hashedPswd);

    int minBPM() const;
    int maxBPM() const;
    int avgBPM() const;
    QList<int> plotData() const;

signals:
    void doctorModeChanged(bool doctorMode);
    void awaitingLoginReplyChanged(bool awaitingLoginReply);
    void healthStatusValueChanged(int healthStatusValue);
    void isUserLoggedInChanged(bool isUserLoggedIn);
    void isOnlineChanged(bool isOnline);
    void sendToCloudChanged(const QString &state, const QJsonObject &data);
    void processingUserLoginChanged(bool processingUserLogin);
    void loginStatusChanged(bool state, QString status, bool is_doctor = false);
    void loggedInUser(QJsonObject user);
    void newDoctorReplyEmitted(QJsonObject data);
    void doctorReplyReceived();
    void chartDataReceived(int y_val);
    void doctorsReplyStateChanged(bool state, QString stateInfo);

    void minBPMChanged(int minBPM);
    void maxBPMChanged(int maxBPM);
    void avgBPMChanged(int avgBPM);
    void chatStrReceived(QString chats_str);
    void bpmStrReceived(QString bpm_str);
    void chatMessageReceived(bool fromDoctor, QString msg, QString date);

    void isLoggedInChanged(bool isLoggedIn);

    void plotDataChanged(QList<int> plotDaa);

public slots:
    void onWebRunnableFinished(const QString &str);
    void onEcgDataReceived(const QString &str);
    void onDoctorSynctTimerTimeout();
    void setMinBPM(int minBPM);
    void setMaxBPM(int maxBPM);
    void setAvgBPM(int avgBPM);
    void onChatStrReceived(QString chats_str);
    void onBpmStrReceived(QString bpm_str);
    void onPlotValTimerTimerTimeout();
    void setPlotData(QList<int> plotDaa);

private:
    QThreadPool m_ThreadPool;
    QSettings * settings;
    QTimer * m_doctorSyncTimer, *m_plotValTimer, *m_shuffle;

    bool m_doctorMode=false, m_awaitingLoginReply=false;
    int m_minBPM=72, m_maxBPM=72, m_avgBPM=72, lastSyncTime = 0, _lastSyncTime = 0, plot_index=0;
    QString applicationDir, m_loggedUserPass, m_processingUserRegistration, m_processingUserLogin;
    bool m_isUserLoggedIn, isRequestSent;
    QJsonObject m_addUserJson, m_addHealthRecordJson, m_GetHealthRecordJson;
    QDateTime m_previousSyncDateTime;
    bool m_isLoggedIn=false;
    QList<int> m_data, m_plotData = {79,79,48,87,94,66,63,63,56,89,55,72,87,19,88,54,38,89,98,43,36,53,79,99,95,36,64,61,78,91,84,83,39,79,63,49,69,43,79};
};

#endif // BACKEDINTERFACE_H
