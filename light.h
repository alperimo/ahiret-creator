#ifndef LIGHT_H
#define LIGHT_H

#include <QOpenGLBuffer>
#include <QOpenGLShaderProgram>
#include <QOpenGLVertexArrayObject>
#include <QOpenGLFunctions>

#include <QColor>

class Light
{
public:
    Light();

    ~Light();

    void setAmbient(QString ambient) { this->ambient = ambient; }//void setAmbient(float ambient) { this->ambient = ambient; }
    void setDiffuse(QString diffuse) { this->diffuse = diffuse; }
    void setSpecular(QString specular) { this->specular = specular; }

    QColor getAmbient() { return QColor(ambient); }//float getAmbient() { return ambient; }
    QColor getDiffuse() { return QColor(diffuse); }
    QColor getSpecular() { return QColor(specular); }

private:
    QOpenGLFunctions *ogl;

    QString ambient;//float ambient;
    QString diffuse;
    QString specular;


};

#endif // LIGHT_H
