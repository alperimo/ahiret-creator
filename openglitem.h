#ifndef OPENGLITEM_H
#define OPENGLITEM_H

#include <iostream>

#include <QQuickItem>
#include <QQuickFramebufferObject>
#include <QOpenGLFramebufferObjectFormat>
#include <QOpenGLFunctions>

#include <QOpenGLVertexArrayObject>
#include <QOpenGLBuffer>
#include <QOpenGLShaderProgram>
#include <QVector3D>

#include <QQuickWindow>

#include "shader.h"

class CustomItemRenderer : public QQuickFramebufferObject::Renderer
{
public:
    CustomItemRenderer();
    ~CustomItemRenderer(); //normalde virtual idi.

private:
    virtual void render();
    void initialize();
    virtual QOpenGLFramebufferObject * createFramebufferObject(const QSize & size);

    virtual void synchronize(QQuickFramebufferObject *item);

private:
    bool firstRender = true;

    QVector3D m_rotation;

    QQuickWindow *m_Window = nullptr; //pointing to mainWindow(GUI)

    Shader *shader;

    void drawObject();

    QOpenGLFunctions *ogl;

    QMatrix4x4 m_projection;
};


class CustomItemBase : public QQuickFramebufferObject
{
    Q_OBJECT
    Q_PROPERTY(QVector3D rotation READ rotation WRITE setRotation NOTIFY rotationChanged)
public:
    QVector3D rotation() const { return m_rotation;}
    void setRotation(const QVector3D &v);

    explicit CustomItemBase(QQuickItem *parent = nullptr) : QQuickFramebufferObject(parent) {}
    //virtual Renderer * createRenderer() const { return new CustomItemRenderer; }
    QQuickFramebufferObject::Renderer *createRenderer() const
    {
        std::cout << "createRenderer()!!!" << std::endl;
        return new CustomItemRenderer();
    }



private:
    QVector3D m_rotation;
};


class CustomItem : public CustomItemBase
{
public:
    CustomItem(QQuickItem * parent = nullptr) : CustomItemBase(parent) {}
    virtual ~CustomItem() {}
};



#endif // OPENGLITEM_H
