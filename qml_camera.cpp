#include "qml_camera.h"
#include "openglitem.h"

CustomItemBase* getParent();

Qml_camera::Qml_camera(QObject* parent) : QObject(parent) {

    //setMovementSpeed(SPEED);

    //updateRenderer();

}

QObject* Qml_camera::getParent(){
    CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
    return parent;
}

void Qml_camera::updateRenderer(){
    CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
    parent->update();
}

void Qml_camera::setMovementSpeed(const float &movSpeed){
    if (movSpeed != m_movementSpeed){
        qDebug() << "cpp movementSpeed degisti! old: " << m_movementSpeed << " new: " << movSpeed;
        m_movementSpeed = movSpeed;

        CustomItemBase* parent = static_cast<CustomItemBase*>(this->parent());
        parent->getCamera()->setMovementSpeed(m_movementSpeed);

        parent->update();

        emit movementSpeedChanged();

    }
}

void Qml_camera::setRotationSpeed(const float &rotSpeed){
    if (rotSpeed != m_rotationSpeed){
        qDebug() << "cpp rotationSpeed degisti! old: " << m_rotationSpeed << " new: " << rotSpeed;
        m_rotationSpeed = rotSpeed;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        parent->getCamera()->setRotationSpeed(m_rotationSpeed);

        parent->update();

        emit rotationSpeedChanged();
    }
}

void Qml_camera::setFov(const float &fov){
    if (fov != m_fov){
        m_fov = fov;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        parent->getCamera()->setFov(m_fov);

        parent->update();

        emit fovChanged();

    }
}

void Qml_camera::setNearDistance(const float &nearDistance){
    if (nearDistance != m_nearDistance){
        m_nearDistance = nearDistance;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        parent->getCamera()->setNearDistance(m_nearDistance);

        parent->update();

        emit nearDistanceChanged();
    }
}

void Qml_camera::setFarDistance(const float &farDistance){
    if (farDistance != m_farDistance){
        m_farDistance = farDistance;

        CustomItemBase *parent = (CustomItemBase*) getParent();
        parent->getCamera()->setFarDistance(m_farDistance);

        parent->update();

        emit farDistanceChanged();
    }
}
