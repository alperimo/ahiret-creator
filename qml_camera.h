#ifndef QML_CAMERA_H
#define QML_CAMERA_H

#include <QQuickItem>

const float SPEED = 2.0f; // movement with keyboard

class Qml_camera : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float movementSpeed READ movementSpeed WRITE setMovementSpeed NOTIFY movementSpeedChanged)
    Q_PROPERTY(float rotationSpeed READ rotationSpeed WRITE setRotationSpeed NOTIFY rotationSpeedChanged)
    Q_PROPERTY(float fov READ fov WRITE setFov NOTIFY fovChanged)
    Q_PROPERTY(float nearDistance READ nearDistance WRITE setNearDistance NOTIFY nearDistanceChanged)
    Q_PROPERTY(float farDistance READ farDistance WRITE setFarDistance NOTIFY farDistanceChanged)

public:
    Qml_camera(QObject* parent = nullptr);

    virtual ~Qml_camera() {}

    void setMovementSpeed(const float &movSpeed);
    void setRotationSpeed(const float &rotSpeed);
    void setFov(const float &fov);
    void setNearDistance(const float &nearDistance);
    void setFarDistance(const float &farDistance);

    float movementSpeed() const {
        return m_movementSpeed;
    }

    float rotationSpeed() const {
        return m_rotationSpeed;
    }

    float fov() const {
        return m_fov;
    }

    float nearDistance() const {
        return m_nearDistance;
    }

    float farDistance() const {
        return m_farDistance;
    }

signals:
    void movementSpeedChanged();
    void rotationSpeedChanged();
    void fovChanged();
    void nearDistanceChanged();
    void farDistanceChanged();

private:
    float m_movementSpeed;
    float m_rotationSpeed;
    float m_fov;
    float m_nearDistance;
    float m_farDistance;

    void updateRenderer();

    QObject* getParent();
};

#endif // QML_CAMERA_H
