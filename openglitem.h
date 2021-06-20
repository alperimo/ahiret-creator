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
#include <QKeyEvent>

#include <QTimer>
#include <QElapsedTimer>

#include <QPointF>
#include <QSet>

#include <camera.h>
#include <shader.h>
#include <qml_camera.h>

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

    QVector3D m_rotation;

    QQuickWindow *m_Window = nullptr; //pointing to mainWindow(GUI)

    Shader *shader;
    Camera *camera;

    void drawObject();

    QOpenGLFunctions *ogl;

    QMatrix4x4 m_projection;

    QTimer *qTimer; //start(int msec) msec sonra bir fonksiyon çalıştıraiblir bunun için QObject::connect ile signal belli bir slot'a atanır.
    QElapsedTimer *timer; //start, restart, elapsed, invalidate(isValid kontrolü yap)

private:
    bool firstRender = true;
    //keyboard, mouse io's
    float deltaTime = 0.0f;
    float lastFrame = 0.0f;
    float currentFrame = 0.0f;
};

//Q_DECLARE_METATYPE(Qml_camera*)
//Q_DECLARE_OPAQUE_POINTER(Qml_camera*)

class CustomItemBase : public QQuickFramebufferObject
{
    Q_OBJECT
    Q_PROPERTY(QVector3D rotation READ rotation WRITE setRotation NOTIFY rotationChanged)
    Q_PROPERTY(int testx READ testx WRITE setTestx NOTIFY testxChanged)
    Q_PROPERTY(Qml_camera* cam READ cam CONSTANT)

//properties für qml
public:
    Qml_camera *cam() const{
        return m_qmlCamera;
    }

    void setTestx(const int &test){
        if (test != m_testx){
            qDebug() << "cpp testx degisti! old: " << m_testx << " new: " << test;
            m_testx = test;
            emit testxChanged();
        }
    }

    int testx() const {
        return m_testx;
    }

signals:
    void testxChanged();

private:
    Qml_camera *m_qmlCamera;
    int m_testx;

public:
    QVector3D rotation() const { return m_rotation;}
    void setRotation(const QVector3D &v);

    Camera* getCamera() { return &camera; }

    explicit CustomItemBase(QQuickItem *parent = nullptr) : QQuickFramebufferObject(parent) {

        setMirrorVertically(true); //qt default kordinat sistemini opengl'e göre düzenler(bu sayede y: 1.0 ekranın üstü olacak.)
        setAcceptedMouseButtons(Qt::AllButtons);

        QObject::connect(this, SIGNAL(activeFocusChangedxxNo()), this, SLOT(activeFocusChangedxNo()));
        QObject::connect(this, SIGNAL(activeFocusChangedxx(QString)), this, SLOT(activeFocusChangedx(QString)));
        QObject::connect(this, SIGNAL(focusChangedSignal(bool)), this, SLOT(focusChangedSlot(bool)));

        m_qmlCamera = new Qml_camera(this);

        cam()->setMovementSpeed(5.0f);
        cam()->setRotationSpeed(0.5f);
        cam()->setFov(40.0f);
        cam()->setNearDistance(0.01f);
        cam()->setFarDistance(100.0f);

        //setAcceptTouchEvents(true);
        //setAcceptedMouseButtons(Qt::RightButton);

    }

    ~CustomItemBase();

    //virtual Renderer * createRenderer() const { return new CustomItemRenderer; }
    QQuickFramebufferObject::Renderer *createRenderer() const
    {
        std::cout << "createRenderer()!!!" << std::endl;
        return new CustomItemRenderer();
    }

    virtual void keyPressEvent(QKeyEvent *event);
    virtual void keyReleaseEvent(QKeyEvent *event);
    virtual void mousePressEvent(QMouseEvent *event);
    virtual void mouseMoveEvent(QMouseEvent *event);
    virtual void mouseReleaseEvent(QMouseEvent *event);

    QSet<int> getKeysPressed(){return keysPressed;}

    bool againUpdate();

    void updateCall() {update();};

    float deltaTime = 0.0f;
    float lastFrame = 0.0f;
    float currentFrame = 0.0f;

    Q_INVOKABLE void _keyPressEvent(); //virtual void keyPressEvent(QKeyEvent* event);

signals:
    void activeFocusChangedxx(const QString &msg);
    void activeFocusChangedxxNo();
    void focusChangedSignal(bool focus);

public slots:
    void activeFocusChangedx(const QString &msg);
    void activeFocusChangedxNo(){
        qDebug() << "cpp al olm mesaji";

    }
    void focusChangedSlot(bool focus);

protected:

    Q_INVOKABLE void _mousePressEvent(QPointF p);

protected: // nur variablen

private: // nur variablen
    QVector3D m_rotation;
    Camera camera;

    QSet<int> keysPressed;

    //keyboard, mouse io's

    float lastMX = 0.0f;
    float lastMY = 0.0f;

    bool mouseRightClick = false;
    bool mouseRightClick2 = false;

};


class CustomItem : public CustomItemBase
{
public:
    CustomItem(QQuickItem * parent = nullptr) : CustomItemBase(parent) {}
    virtual ~CustomItem() {}
};



#endif // OPENGLITEM_H
