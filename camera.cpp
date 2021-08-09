#include "camera.h"
#include "math.h"

#define degreesToRadians(angleDegrees) ((angleDegrees) * M_PI / 180.0)
#define radiansToDegrees(angleRadians) ((angleRadians) * 180.0 / M_PI)

QMatrix4x4 Camera::getCameraViewMatrix(){
    QMatrix4x4 viewMatrix;
    //viewMatrix.lookAt(cameraPos, QVector3D(0.0f, 0.0f, 0.0f), cameraUp);
    viewMatrix.lookAt(cameraPos, cameraPos + cameraFront, cameraUp);
    return viewMatrix;
}

void Camera::updateCameraVectors(){
    QVector3D frontDirection = QVector3D(0.0f, 0.0f, -1.0f);
    qDebug() << "old frontDirection: " << frontDirection;
    double radians = 90 * M_PI / 180;
    qDebug() << "yaw= " << (float) yaw << " und qCos for yaw = " << qCos(qDegreesToRadians(yaw));
    frontDirection.setX(qCos(qDegreesToRadians((float)yaw)));
    frontDirection.setZ(qSin(qDegreesToRadians((float)yaw)));
    frontDirection.setY(qSin(qDegreesToRadians((float)pitch)));

    //qDebug() << "new frontDirection: " << frontDirection;

    cameraFront = frontDirection.normalized();
    cameraRight = QVector3D::crossProduct(cameraFront, worldUp).normalized();
    cameraUp = QVector3D::crossProduct(cameraRight, cameraFront).normalized();

    /*qDebug() << "cameraFront: " << cameraFront;
    qDebug() << "cameraRight: " << cameraRight;
    qDebug() << "cameraUp: " << cameraUp;*/
}

void Camera::processKeyboard(cameraMovement direction, float deltaTime){
    float velocity = movementSpeed * deltaTime;
    if (direction == FORWARD)
        cameraPos += velocity * cameraFront;

    if (direction == BACKWARD)
        cameraPos -= velocity * cameraFront;

    if (direction == LEFT)
        cameraPos -= velocity * cameraRight;

    if (direction == RIGHT)
        cameraPos += velocity * cameraRight;

    qDebug() << "cameraPos: " << cameraPos;
}

void Camera::processMouseMovement(float xoffset, float yoffset, bool constrainPitch) {
    xoffset *= mouseSensitivity;
    yoffset *= mouseSensitivity;

    yaw += xoffset;
    pitch -= yoffset;

    //std::cout << "yaw: " << yaw << "pitch: " << pitch << " xoffset: " << xoffset << " yoffset: " << yoffset << std::endl;

    if (constrainPitch) {
        if (pitch > 89.0f)
            pitch = 89.0f;
        if (pitch < -89.0f)
            pitch = -89.0f;
    }


    updateCameraVectors();
}

void Camera::processMouseScroll(float yoffset) {
    cameraPos += ((float)yoffset * fov_speed) * cameraFront;
    /*fov -= (float)yoffset * fov_speed;
    if (fov < 1.0f)
        fov = 1.0f;
    if (fov > 60.0f)
        fov = 60.0f;*/
}

void Camera::setMovementSpeed(float movSpeed){
    qDebug() << "in camera mov speed icin cagri var";
    movementSpeed = movSpeed;
    qDebug() << "new movementSpeed: " << movementSpeed;
}

void Camera::setRotationSpeed(float rotSpeed){
    qDebug() << "in camera rot speed icin cagri var";
    mouseSensitivity = rotSpeed;
    qDebug() << "new mouseSensitivity: " << mouseSensitivity;
}

void Camera::setFov(float fov){
    qDebug() << "in camera fov icin cagri var";
    this->fov = fov;
    qDebug() << "new fov: " << fov;
}

void Camera::setNearDistance(float nearDistance){
    qDebug() << "in camera nearDistance icin cagri var";
    this->nearDistance = nearDistance;
    qDebug() << "new nearDistance: " << nearDistance;
}

void Camera::setFarDistance(float farDistance){
    qDebug() << "in camera farDistance icin cagri var";
    this->farDistance = farDistance;
    qDebug() << "new farDistance: " << farDistance;
}
