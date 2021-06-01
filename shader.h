#ifndef SHADER_H
#define SHADER_H

#include <QOpenGLBuffer>
#include <QOpenGLShaderProgram>
#include <QOpenGLVertexArrayObject>
#include <QOpenGLFunctions>

#include <iostream>

class Shader
{
public:
    Shader(QOpenGLFunctions *ogl);
    ~Shader();

    void drawObject(QOpenGLFunctions *ogl);

    QOpenGLShaderProgram* getShaderProgram(){return m_program;}
    QOpenGLVertexArrayObject* getVAO(){return &m_vao;}
    QOpenGLBuffer* getVBO(){return &m_vbo;}
    QOpenGLBuffer* getEBO(){return &m_ebo;}

private:
    QOpenGLVertexArrayObject m_vao;
    QOpenGLBuffer m_vbo;
    QOpenGLBuffer m_ebo; //element buffer object = indices buffer object
    QOpenGLShaderProgram *m_program;
};

#endif // SHADER_H
