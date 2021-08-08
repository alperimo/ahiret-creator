#include "qml_light.h"
#include "openglitem.h"

CustomItemBase* getParent();

Qml_generalData::Qml_generalData(QObject* parent) : QObject(parent) {

    //setMovementSpeed(SPEED);

    //updateRenderer();

}

QObject* Qml_generalData::getParent(){
    CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
    return parent;
}

void Qml_generalData::updateRenderer(){
    CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
    parent->update();
}

void Qml_generalData::setCurrentDepthTest(const unsigned int& depthTest)
{
    if (depthTest != m_currentDepthTest){
        qDebug() << "cpp real outCutOff degisti with float! old: " << m_currentDepthTest << " new: " << depthTest;

        m_currentDepthTest = depthTest;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        //parent->getLight()->setQuadratic(m_quadratic);

        parent->update();

        emit currentDepthTest();
    }
}