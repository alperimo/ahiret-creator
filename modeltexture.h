#ifndef MODELTEXTURE_H
#define MODELTEXTURE_H

#include <QObject>
#include <QOpenGLFunctions>
#include <QImage>
#include <QDebug>
#include <QOpenGLTexture>
#include <QGLWidget>

class ModelTexture : QObject
{
    Q_OBJECT
public:
    ModelTexture();
    //static GLuint textureFromFile(const char* fileName_, const QString& directory, bool gamma = false);
    static GLuint textureFromFile(const QString& filePath, bool gamma = false);
};

#endif // MODELTEXTURE_H
