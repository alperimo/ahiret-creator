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
    double radians = 90 * M_PI / 180;
    frontDirection.setX(qCos(qDegreesToRadians((float)yaw)));
    frontDirection.setZ(qSin(qDegreesToRadians((float)yaw)));
    frontDirection.setY(qSin(qDegreesToRadians((float)pitch)));

    cameraFront = frontDirection.normalized();
    cameraRight = QVector3D::crossProduct(cameraFront, worldUp).normalized();
    cameraUp = QVector3D::crossProduct(cameraRight, cameraFront).normalized();
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
}

void Camera::processMouseMovement(float xoffset, float yoffset, bool constrainPitch) {
    xoffset *= mouseSensitivity;
    yoffset *= mouseSensitivity;

    yaw += xoffset;
    pitch -= yoffset;

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
}

void Camera::setMovementSpeed(float movSpeed){
    movementSpeed = movSpeed;
}

void Camera::setRotationSpeed(float rotSpeed){
    mouseSensitivity = rotSpeed;
}

void Camera::setFov(float fov){
    this->fov = fov;
}

void Camera::setNearDistance(float nearDistance){
    this->nearDistance = nearDistance;
}

void Camera::setFarDistance(float farDistance){
    this->farDistance = farDistance;
}
