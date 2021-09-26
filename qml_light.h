#ifndef QML_LIGHT_H
#define QML_LIGHT_H

#include <QQuickItem>
#include <QColor>

class Qml_light : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString ambient READ ambient WRITE setAmbient NOTIFY ambientChanged)
    Q_PROPERTY(QString diffuse READ diffuse WRITE setDiffuse NOTIFY diffuseChanged)
    Q_PROPERTY(QString specular READ specular WRITE setSpecular NOTIFY specularChanged)

    Q_PROPERTY(bool pointLight READ pointLight WRITE setPointLight NOTIFY pointLightChanged)
    Q_PROPERTY(float linear READ linear WRITE setLinear NOTIFY linearChanged)
    Q_PROPERTY(float quadratic READ quadratic WRITE setQuadratic NOTIFY quadraticChanged)

    Q_PROPERTY(bool spotLight READ spotLight WRITE setSpotLight NOTIFY spotLightChanged)
    Q_PROPERTY(float cutOff READ cutOff WRITE setCutOff NOTIFY cutOffChanged)
    Q_PROPERTY(float outCutOff READ outCutOff WRITE setOutCutOff NOTIFY outCutOffChanged)

public:
    Qml_light(QObject* parent = nullptr);

    virtual ~Qml_light() {}

    void setAmbient(const QString &ambient, bool init = 0);
    void setDiffuse(const QString &diffuse);
    void setSpecular(const QString &specular);

    void setPointLight(const bool &pointLight);
    void setLinear(const float &linear);
    void setQuadratic(const float &quadratic);

    void setSpotLight(const bool &spotLight);
    void setCutOff(const float &cutOff);
    void setOutCutOff(const float &outCutOff);

    QString ambient() const {
        return m_ambient;
    }

    QString diffuse() const {
        return m_diffuse;
    }

    QString specular() const {
        return m_specular;
    }

    bool pointLight() const {
        return m_pointLight;
    }

    float linear() const {
        return m_linear;
    }

    float quadratic() const {
        return m_quadratic;
    }

    bool spotLight() const {
        return m_spotLight;
    }

    float cutOff() const {
        return m_cutOff;
    }

    float outCutOff() const {
        return m_outCutOff;
    }

signals:
    void ambientChanged();
    void diffuseChanged();
    void specularChanged();

    void pointLightChanged();
    void linearChanged();
    void quadraticChanged();

    void spotLightChanged();
    void cutOffChanged();
    void outCutOffChanged();

private:
    QString m_ambient;
    QString m_diffuse;
    QString m_specular;

    bool m_pointLight;
    float m_linear;
    float m_quadratic;

    bool m_spotLight;
    float m_cutOff;
    float m_outCutOff;

    void updateRenderer();

    QObject* getParent();
};

#endif // QML_LIGHT_H
