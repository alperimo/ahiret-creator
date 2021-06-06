#include "openglitem.h"

static bool initialized = false;

//Renderer
QOpenGLFramebufferObject * CustomItemRenderer::createFramebufferObject(const QSize & size)
{
    //firstRender = true;
    std::cout << "CustomItemRenderer::createFramebufferObject()!!!" << std::endl;
    QOpenGLFramebufferObjectFormat format;
    format.setAttachment(QOpenGLFramebufferObject::CombinedDepthStencil);
    format.setSamples(4);
    return new QOpenGLFramebufferObject(size, format);
}

CustomItemRenderer::CustomItemRenderer(){
    std::cout << "CustomItemRenderer::CustomItemRenderer()" << std::endl;
    ogl = QOpenGLContext::currentContext()->functions();
    ogl->initializeOpenGLFunctions();
}

void CustomItemRenderer::initialize(){
    // initialize OpenGL parts... (shaders)
    shader = new Shader(ogl);
    //camera = new Camera();

    /*qTimer = new QTimer();
    qTimer->start(1000);*/

    timer = new QElapsedTimer();
    timer->start();
}

void CustomItemRenderer::render()
{
    //std::cout << "render()!!!" << std::endl;
    if (firstRender){
        firstRender = false;
        ogl->glEnable(GL_DEPTH_TEST); // zBuffer/Depthbuffer/Depth testing aktif.
        initialize();
    }
    //std::cout << "after first render" << std::endl;

    ogl->glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    ogl->glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    currentFrame = (float) timer->elapsed() / 1000;
    deltaTime = currentFrame - lastFrame;
    lastFrame = currentFrame;

    drawObject();
    update();

    if (m_Window){
        m_Window->resetOpenGLState();
    }

}

void CustomItemRenderer::synchronize(QQuickFramebufferObject *item) {
    //std::cout << "CustomItemRenderer::synchronize()" << std::endl;
    CustomItemBase *customItemBase = static_cast<CustomItemBase *>(item);
    m_rotation = customItemBase->rotation();

    m_Window = item->window();

    customItemBase->deltaTime = deltaTime;
    customItemBase->currentFrame = currentFrame;
    customItemBase->lastFrame = lastFrame;

    //std::cout << "deltaTime: " << deltaTime << std::endl;

    camera = customItemBase->getCamera();

    qDebug() << "CustomItemRenderer::synchronize() cameraPos " << camera.getCameraPos();

    //if (customItemBase->getRightMouseEvent() != nullptr)
    //    customItemBase->mouseMoveEvent(customItemBase->getRightMouseEvent());

    GLsizei w = item->width();
    GLsizei h = item->height();
    ogl->glViewport(0, 0, w, h);

    m_projection.setToIdentity();
    m_projection.perspective(45.0f, GLfloat(w) / GLfloat(h), 0.01f, 100.0f);

    if (customItemBase->againUpdate())
        customItemBase->_keyPressEvent();

    //std::cout << "m_Window->width() = " << m_Window->width() << " height: " << m_Window->height() << std::endl;
    //std::cout << "openGL window width() = " << item->width() << " height: " << item->height() << std::endl;
}

void CustomItemRenderer::drawObject(){
    QOpenGLShaderProgram *shaderProgram = shader->getShaderProgram();
    shaderProgram->bind();
    shader->getVAO()->bind();

    QMatrix4x4 m_model;
    QMatrix4x4 m_view;

    m_model.setToIdentity();
    //m_model.rotate(timer->elapsed() * 0.1, QVector3D(0.5, 1, 0));
    m_view.setToIdentity();
    //m_view.translate(0, 0, -3);
    m_view = camera.getCameraViewMatrix();

    //qDebug() << "m_view: " << m_view.column(3).x();

    /*qDebug() << m_model;
    qDebug() << m_view;
    qDebug() << m_projection;*/

    int m_modelLoc = shaderProgram->uniformLocation("modelMatrix");
    int m_viewLoc = shaderProgram->uniformLocation("viewMatrix");
    int m_projectionLoc = shaderProgram->uniformLocation("projectionMatrix");

    shaderProgram->setUniformValue(m_modelLoc, m_model);
    shaderProgram->setUniformValue(m_viewLoc, m_view);
    shaderProgram->setUniformValue(m_projectionLoc, m_projection);

    ogl->glDrawArrays(GL_TRIANGLES, 0, 36);
    shader->getVAO()->release();
}

CustomItemRenderer::~CustomItemRenderer(){
    if (shader)
        delete shader;

    if (timer->isValid()){
        timer->invalidate();
        delete timer;
    }

    /*if (qTimer->isActive())
    {
        qTimer->stop();
        delete qTimer;
    }*/
}

// Item

CustomItemBase::~CustomItemBase(){
    keysPressed.clear();
}

void CustomItemBase::keyPressEvent(QKeyEvent *event){
    //qDebug() << "cpp keyPressEvent: " << event->text();

    if (!keysPressed.contains(event->key()))
        keysPressed.insert(event->key());

    qDebug() << "size of keysPressed = " << keysPressed.size();

    _keyPressEvent();
}

void CustomItemBase::keyReleaseEvent(QKeyEvent *event){
    //keysPressed -= event->key();
    //qDebug() << "cpp keyReleaseEvent: " << event->text();
    if (keysPressed.contains(event->key()))
        keysPressed.remove(event->key());

    _keyPressEvent();
}

void CustomItemBase::mousePressEvent(QMouseEvent *event){
    setFocus(true);
    qDebug() << "cpp mousePressEvent: " << event->button();
    if (event->button() == Qt::RightButton){
        mouseRightClick = true;
        qDebug() << "x: " << event->x() << " y: " << event->y();
    }
}

void CustomItemBase::mouseMoveEvent(QMouseEvent *event){

    if (!mouseRightClick)
        return;

    if (mouseRightClick && !mouseRightClick2){
        lastMX = event->x();
        lastMY = event->y();
        mouseRightClick2 = true;
    }

    float currentX = (float)event->x();
    float currentY = (float)event->y();

    float offsetX = currentX - lastMX;
    float offsetY = currentY - lastMY;

    lastMX = currentX;
    lastMY = currentY;

    qDebug() << "offsetX: " << offsetX << " offsetY: " << offsetY;

    camera.processMouseMovement(offsetX, offsetY, true);

    update();
}

void CustomItemBase::mouseReleaseEvent(QMouseEvent *event){
    if (event->button() == Qt::RightButton){
        mouseRightClick = false;
        mouseRightClick2 = false;
    }
}

void CustomItemBase::_mousePressEvent(QPointF p){ // sürekli update edilir

}

void CustomItemBase::_keyPressEvent(){ // sürekli update edilir
    if (keysPressed.contains(Qt::Key_W))
        camera.processKeyboard(FORWARD, deltaTime);
    if (keysPressed.contains(Qt::Key_S))
        camera.processKeyboard(BACKWARD, deltaTime);
    if (keysPressed.contains(Qt::Key_A))
        camera.processKeyboard(LEFT, deltaTime);
    if (keysPressed.contains(Qt::Key_D))
        camera.processKeyboard(RIGHT, deltaTime);

   if (keysPressed.contains(Qt::Key_Right))
   {
        camera.yaw += 1.0f;
        camera.updateCameraVectors();
    }

    if (keysPressed.contains(Qt::Key_Left))
    {
        camera.yaw -= 1.0f;
        camera.updateCameraVectors();
    }

    update();
}

bool CustomItemBase::againUpdate(){
    if (keysPressed.size() > 0 || mouseRightClick)
        return true;

    return false;
}

void CustomItemBase::setRotation(const QVector3D &v){
    std::cout << "CustomItemBase::setRotation()" << std::endl;
    if (m_rotation != v){
        m_rotation = v;
        emit rotationChanged();
        update();
    }
}
