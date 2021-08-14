#ifndef OPENGLITEM_H
#define OPENGLITEM_H

#include <iostream>

#include <QQuickItem>
#include <QQuickFramebufferObject>
#include <QOpenGLFramebufferObjectFormat>
#include <QOpenGLFunctions>
#include <QOpenGLTexture>

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

#include <QFileSystemModel>

#include <camera.h>
#include <shader.h>
#include <light.h>
#include <qml_camera.h>
#include <qml_light.h>
#include <qml_generalData.h>
#include <filesystem.h>
#include <sandboxitemmodel.h>

#include "model.h"
#include "terrain.h"

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

private: //model infos
    QOpenGLTexture *modelTextures[2] = {nullptr, nullptr}; // diffuseMap, specularMap
    GLuint textureIDs[1]; // emissionMap

private:

    QQuickWindow *m_Window = nullptr; //pointing to mainWindow(GUI)

    Shader* shader;
    Shader* shaderLight;
    QSharedPointer<Shader> shaderTerrainHq, shaderTerrainMq, shaderTerrainLq;
    Camera *camera;
    Light *light;

    Qml_light* light_qml;
    Qml_generalData* generalData_qml;

    FileSystem* fileSystem;

    QVector3D lightPos;

    QList<QSharedPointer<Model>> modelList;
    QList<QSharedPointer<Terrain>> terrainList;

    void drawObject();

    QOpenGLFunctions *ogl;

    QMatrix4x4 m_projection;

    QTimer *qTimer; //start(int msec) msec sonra bir fonksiyon çalıştıraiblir bunun için QObject::connect ile signal belli bir slot'a atanır.
    QElapsedTimer *timer; //start, restart, elapsed, invalidate(isValid kontrolü yap)

private:
    bool firstSynchronize = true;
    bool firstRender = true;
    //keyboard, mouse io's
    float deltaTime = 0.0f;
    float lastFrame = 0.0f;
    float currentFrame = 0.0f;

    QList<GLenum> depthFuncs = {0, GL_LESS, GL_ALWAYS, GL_NEVER, GL_EQUAL, GL_LEQUAL, GL_GREATER, GL_NOTEQUAL, GL_GEQUAL};

};

//Q_DECLARE_METATYPE(Qml_camera*)
//Q_DECLARE_OPAQUE_POINTER(Qml_camera*)

class CustomItemBase : public QQuickFramebufferObject
{
    Q_OBJECT
    Q_PROPERTY(Qml_camera* cam READ cam CONSTANT)
    Q_PROPERTY(Qml_light* light READ light CONSTANT)
    Q_PROPERTY(Qml_generalData* generalData READ generalData CONSTANT)
    Q_PROPERTY(QFileSystemModel* fileSystem READ fileSystem CONSTANT)
    Q_PROPERTY(SandBoxItemModel* fileSystemNew READ fileSystemNew CONSTANT)


//properties für qml
public:
    Qml_camera *cam() const{
        return m_qmlCamera;
    }

    Qml_light *light() const{
        return m_qmlLight;
    }

    Qml_generalData* generalData() const{
        return m_qmlGeneralData;
    }

    QFileSystemModel* fileSystem() const {
        return m_fileSystem;
    }

    SandBoxItemModel* fileSystemNew() const {
        return m_fileSystemNew;
    }

private:
    QPointer<Qml_camera> m_qmlCamera;//Qml_camera *m_qmlCamera;
    QPointer<Qml_light> m_qmlLight;//Qml_light *m_qmlLight;
    QPointer<Qml_generalData> m_qmlGeneralData;
    QPointer<FileSystem> m_fileSystem;
    QPointer<SandBoxItemModel> m_fileSystemNew;

public:

    Camera* getCamera() { return &camera; }
    Light* getLight() {return &lightInfos; }

    explicit CustomItemBase(QQuickItem *parent = nullptr) : QQuickFramebufferObject(parent) {

        setMirrorVertically(true); //qt default kordinat sistemini opengl'e göre düzenler(bu sayede y: 1.0 ekranın üstü olacak.)
        setAcceptedMouseButtons(Qt::AllButtons);

        QObject::connect(this, SIGNAL(activeFocusChangedxxNo()), this, SLOT(activeFocusChangedxNo()));
        QObject::connect(this, SIGNAL(activeFocusChangedxx(QString)), this, SLOT(activeFocusChangedx(QString)));
        QObject::connect(this, SIGNAL(focusChangedSignal(bool)), this, SLOT(focusChangedSlot(bool)));

        m_qmlCamera = new Qml_camera(this);
        m_qmlLight = new Qml_light(this);
        m_qmlGeneralData = new Qml_generalData(this);

        m_fileSystem = new FileSystem();
        m_fileSystem->setRootPath(m_fileSystem->getCurrentScenePath()+"objects/");

        m_fileSystemNew = new SandBoxItemModel();
        m_fileSystemNew->setUseMainDirectory(true);
        QFile file(m_fileSystem->getMainPath()+"deneme.txt"); //sandbox locations are read from the text file
        if (!file.open(QIODevice::ReadOnly)){
            qDebug() << "file couldn't open!";

        }else{
            //QString m_fileName = QString::fromStdString(file.readAll().toStdString());
            QString m_fileName = m_fileSystem->getObjectPath();
            qDebug() << "file okunan QString datax: " << m_fileName;
            m_fileSystemNew->setSandBoxDetails(m_fileName);
        }

        cam()->setMovementSpeed(5.0f);
        cam()->setRotationSpeed(0.5f);
        cam()->setFov(40.0f);
        cam()->setNearDistance(0.01f);
        cam()->setFarDistance(100.0f);

        light()->setAmbient("#FFFFFFFF");
        light()->setDiffuse("#FFFFFFFF");
        light()->setSpecular("#FFFFFFFF");

        light()->setPointLight(true);
        light()->setLinear(0.09f);
        light()->setQuadratic(0.032f);

        light()->setSpotLight(false);
        light()->setCutOff(12.5f);
        light()->setOutCutOff(17.5f);

        generalData()->setCurrentDepthTest(1);

        //setAcceptTouchEvents(true);
        //setAcceptedMouseButtons(Qt::RightButton);

    }

    ~CustomItemBase();

    QQuickFramebufferObject::Renderer *createRenderer() const
    {
        std::cout << "createRenderer()!!!" << std::endl;
        return new CustomItemRenderer();
    }

    FileSystem* getFileSystem() const { return m_fileSystem; }

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
    void activeFocusChangedxNo(){};

    void focusChangedSlot(bool focus);

protected:
    Q_INVOKABLE void _mousePressEvent(QPointF p);

public: // synhronize variablen
    unsigned int currentDepthTest = 1;

private: // nur variablen
    Camera camera;
    Light lightInfos;

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
