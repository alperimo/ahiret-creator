#ifndef CAMERA_H
#define CAMERA_H

#include <QVector3D>
#include <QMatrix4x4>
#include <QtMath>
#include <QDebug>

const float YAW = -90.0f;
const float PITCH = 0.0f;
const float SPEED = 2.5f; // movement with keyboard
const float SENSITIVITY = 0.5f;
const float FOV = 45.0f; // field of view / ZOOM
const float FOV_SPEED = 2.0f;

enum cameraMovement {
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT
};

class Camera
{

    QVector3D cameraPos = QVector3D(0.0f, 0.0f, 3.0f);
    QVector3D cameraFront = QVector3D(0.0f, 0.0f, -1.0f);
    QVector3D cameraTarget = QVector3D(0.0f, 0.0f, 0.0f); //origin
    QVector3D cameraDirection = (cameraPos - cameraTarget).normalized();
    QVector3D cameraRight = QVector3D::crossProduct(QVector3D(0.0f, 1.0f, 0.0f), cameraDirection).normalized();
    QVector3D cameraUp = QVector3D::crossProduct(cameraDirection, cameraRight);
    QVector3D worldUp;

    public:
        float yaw = -90.0f; // negatif z eksenine bakmasi icin.
        float pitch = 0.0f;
        float movementSpeed;
        float mouseSensitivity;
        float fov, fov_speed;

        Camera(QVector3D position = QVector3D(0.0f, 0.0f, 3.0f), QVector3D worldUp = QVector3D(0.0f, 1.0f, 0.0f), float yaw = YAW, float pitch = PITCH)
            : cameraFront(QVector3D(0.0f, 0.0f, -1.0f)), movementSpeed(SPEED), mouseSensitivity(SENSITIVITY), fov(FOV), fov_speed(FOV_SPEED)
        {
            cameraPos = position;
            this->worldUp = worldUp;
            this->yaw = yaw;
            this->pitch = pitch;
            updateCameraVectors();
        }

        Camera(float posX, float posY, float posZ, float worldUpX, float worldUpY, float worldUpZ, float yaw, float pitch)
                : cameraFront(QVector3D(0.0f, 0.0f, -1.0f)), movementSpeed(SPEED), mouseSensitivity(SENSITIVITY), fov(FOV), fov_speed(FOV_SPEED)
        {
            cameraPos = QVector3D(posX, posY, posZ);
            this->worldUp = QVector3D(worldUpX, worldUpY, worldUpZ);
            this->yaw = yaw;
            this->pitch = pitch;
            updateCameraVectors();
        }

        void updateCameraVectors();
        void processKeyboard(cameraMovement direction, float deltaTime);
        void processMouseMovement(float xoffset, float yoffset, bool constrainPitch = true);
        void processMouseScroll(float yoffset);

        QVector3D getCameraPos() { return cameraPos; };
        QVector3D getCameraFront() { return cameraFront; };
        QVector3D getCameraTarget() { return cameraTarget; };
        QVector3D getCameraDirection() { return cameraDirection; };
        QVector3D getCameraUp() { return cameraUp; };

        QMatrix4x4 getCameraViewMatrix();
};

#endif // CAMERA_H
