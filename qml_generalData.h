#ifndef QML_GENERALDATA_H
#define QML_GENERALDATA_H

#include <QQuickItem>
#include <QColor>

class Qml_generalData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(unsigned int currentDepthTest READ currentDepthTest WRITE setCurrentDepthTest NOTIFY currentDepthTestChanged)//Q_PROPERTY(float ambient READ ambient WRITE setAmbient NOTIFY ambientChanged)


public:
    Qml_generalData(QObject* parent = nullptr);

    virtual ~Qml_generalData() {}

    void setCurrentDepthTest(const unsigned int& depthTest);

    auto currentDepthTest() const {
        return m_currentDepthTest;
    }


signals:
    void currentDepthTestChanged();

private:
    unsigned int m_currentDepthTest;

    void updateRenderer();

    QObject* getParent();
};

#endif // QML_GENERALDATA_H
