#include "qml_light.h"
#include "openglitem.h"

CustomItemBase* getParent();

Qml_light::Qml_light(QObject* parent) : QObject(parent) {

    //setMovementSpeed(SPEED);

    //updateRenderer();

}

QObject* Qml_light::getParent(){
    CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
    return parent;
}

void Qml_light::updateRenderer(){
    CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
    parent->update();
}

void Qml_light::setAmbient(const QString &ambient, bool init){//void Qml_light::setAmbient(const float &ambient){
    if (ambient != m_ambient){
        m_ambient = ambient;

        qDebug() << "cpp real ambient degisti with QString! old: " << m_ambient << " new: " << ambient;

        CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
        parent->getLight()->setAmbient(m_ambient);

        parent->update();

        emit ambientChanged();
    }
}

void Qml_light::setDiffuse(const QString &diffuse){

    if (diffuse != m_diffuse){
        m_diffuse = diffuse;

        qDebug() << "cpp real diffuse degisti with QString! old: " << m_diffuse << " new: " << diffuse;

        CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
        parent->getLight()->setDiffuse(m_diffuse);

        parent->update();

        emit diffuseChanged();
    }
}

void Qml_light::setSpecular(const QString &specular){
    if (specular != m_specular){
        m_specular = specular;

        qDebug() << "cpp real specular degisti with QString! old: " << m_specular << " new: " << specular;

        CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
        parent->getLight()->setSpecular(m_specular);

        parent->update();

        emit specularChanged();
    }
}

void Qml_light::setPointLight(const bool &pointLight){
    if (pointLight != m_pointLight){
        m_pointLight = pointLight;

        qDebug() << "cpp real pointLight degisti with float! old: " << m_pointLight << " new: " << pointLight;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        //parent->getLight()->setQuadratic(m_quadratic);

        parent->update();

        emit pointLightChanged();
    }
}

void Qml_light::setLinear(const float &linear){
    if (linear != m_linear){
        m_linear = linear;

        qDebug() << "cpp real linear degisti with float! old: " << m_linear << " new: " << linear;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        //parent->getLight()->setLinear(m_linear);

        parent->update();

        emit linearChanged();
    }
}

void Qml_light::setQuadratic(const float &quadratic){
    if (quadratic != m_quadratic){
        m_quadratic = quadratic;

        qDebug() << "cpp real quadratic degisti with float! old: " << m_quadratic << " new: " << quadratic;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        //parent->getLight()->setQuadratic(m_quadratic);

        parent->update();

        emit quadraticChanged();
    }
}

void Qml_light::setSpotLight(const bool &spotLight){
    if (spotLight != m_spotLight){
        m_spotLight = spotLight;

        qDebug() << "cpp real spotLight degisti with float! old: " << m_spotLight << " new: " << spotLight;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        //parent->getLight()->setQuadratic(m_quadratic);

        parent->update();

        emit spotLightChanged();
    }
}

void Qml_light::setCutOff(const float &cutOff){
    if (cutOff != m_cutOff){
        m_cutOff = cutOff;

        qDebug() << "cpp real cutOff degisti with float! old: " << m_cutOff << " new: " << cutOff;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        //parent->getLight()->setQuadratic(m_quadratic);

        parent->update();

        emit cutOffChanged();
    }
}

void Qml_light::setOutCutOff(const float &outCutOff){
    if (outCutOff != m_outCutOff){
        m_outCutOff = outCutOff;

        qDebug() << "cpp real outCutOff degisti with float! old: " << m_outCutOff << " new: " << outCutOff;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        //parent->getLight()->setQuadratic(m_quadratic);

        parent->update();

        emit outCutOffChanged();
    }
}
