#ifndef QML_GENERALDATA_H
#define QML_GENERALDATA_H

#include <QQuickItem>
#include <QColor>

class Qml_generalData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(unsigned int currentDepthTest READ currentDepthTest WRITE setCurrentDepthTest NOTIFY currentDepthTestChanged)
    Q_PROPERTY(float deltaTime READ deltaTime WRITE setDeltaTime NOTIFY deltaTimeChanged)


public:
    Qml_generalData(QObject* parent = nullptr);

    virtual ~Qml_generalData() {}

    void setCurrentDepthTest(const unsigned int& depthTest);
    void setDeltaTime(const float& value);

    decltype (auto) currentDepthTest() const {
        return m_currentDepthTest;
    }

    float deltaTime() const {
        return m_deltaTime;
    }

signals:
    void currentDepthTestChanged();
    void deltaTimeChanged();

private:
    unsigned int m_currentDepthTest;
    float m_deltaTime = 0.0f;

    void updateRenderer();

    QObject* getParent();
};

#endif // QML_GENERALDATA_H
