#include "openglitem.h"

#include <QFileInfo>

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
    shader = new Shader("shader.vs", "shader.fs", ogl);
    shaderLight = new Shader("shaderLight.vs", "shaderLight.fs", ogl);

    // VBO ve EBO(indices buffer object) oluşturma
    float vertices[] = {
        // positions          // normals           // texture coords
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 0.0f,
         0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 0.0f,
         0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 1.0f,
         0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 0.0f,

        -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 0.0f,
         0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 0.0f,
         0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 1.0f,
         0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 1.0f,
        -0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 0.0f,

        -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
        -0.5f,  0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 1.0f,
        -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 0.0f,
        -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 0.0f,

         0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
         0.5f,  0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f,
         0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
         0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
         0.5f, -0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 0.0f,
         0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f,

        -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 1.0f,
         0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 1.0f,
         0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 0.0f,
         0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 0.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 0.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 1.0f,

        -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 1.0f,
         0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 1.0f,
         0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 0.0f,
         0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 1.0f
    };

    unsigned int indices[] = {  // note that we start from 0!
        0, 1, 3,   // first triangle
        1, 2, 3    // second triangle
    };



    //QPointer<Model> modelTest = new Model("qrc:/scene/models/tank/IS4.obj");

    //modelTextures were removed

    shaderLight->getShaderProgram()->bind();

    lightPos = QVector3D(0.0f, 0.0f, 0.0f); //QVector3D(1.2f, 1.0f, 2.0f);//QVector3D(3.0f, 0.5f, -1.0f);

    QOpenGLVertexArrayObject* shaderLight_vao = shaderLight->getVAO();
    QOpenGLBuffer* shaderLight_vbo = shaderLight->getVBO();
    QOpenGLBuffer* shaderLight_ebo = shaderLight->getEBO();

    shaderLight_vao->bind();

    shaderLight_vbo->bind();
    shaderLight_vbo->allocate(vertices, sizeof(vertices));

    ogl->glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (void*)0);
    ogl->glEnableVertexAttribArray(0);

    ogl->glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (void*)(3 * sizeof(float)));
    ogl->glEnableVertexAttribArray(1);

    shaderLight_ebo->bind();
    shaderLight_ebo->allocate(indices, sizeof(indices));

    shaderLight->releaseShader();

    //camera = new Camera();

    /*qTimer = new QTimer();
    qTimer->start(1000);*/

    timer = new QElapsedTimer();
    timer->start();

    shader->getShaderProgram()->bind();
    QPointer<Model> modelTest2 = new Model("C:/textures/tank/IS4.obj", QOpenGLContext::currentContext());
    modelList.append(modelTest2);
}

void CustomItemRenderer::render()
{
    if (firstRender){
        firstRender = false;
        ogl->glEnable(GL_DEPTH_TEST); // zBuffer/Depthbuffer/Depth testing aktif.
        initialize();
    }

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

    m_Window = item->window();

    customItemBase->deltaTime = deltaTime;
    customItemBase->currentFrame = currentFrame;
    customItemBase->lastFrame = lastFrame;

    //std::cout << "deltaTime: " << deltaTime << std::endl;

    camera = customItemBase->getCamera();
    light = customItemBase->getLight();

    light_qml = customItemBase->light();

    GLsizei w = item->width();
    GLsizei h = item->height();
    ogl->glViewport(0, 0, w, h);

    m_projection.setToIdentity();
    m_projection.perspective(camera->getFov(), GLfloat(w) / GLfloat(h), camera->getNearDistance(), camera->getFarDistance());
    //m_projection.perspective(45.0f, GLfloat(w) / GLfloat(h), 0.01f, 100.0f);

    if (customItemBase->againUpdate())
        customItemBase->_keyPressEvent();
}

void CustomItemRenderer::drawObject(){
    QOpenGLShaderProgram *shaderProgram = shader->getShaderProgram();
    shaderProgram->bind();

    QMatrix4x4 m_model;
    QMatrix4x4 m_view;

    QMatrix4x4 m_model_forNormal;
    QMatrix4x4 m_view_forNormal;

    m_model.setToIdentity();
    //m_model.rotate(timer->elapsed() * 0.1, QVector3D(0.5, 1, 0));
    m_view.setToIdentity();
    //m_view.translate(0, 0, -3);
    m_view = camera->getCameraViewMatrix();

    m_model_forNormal = m_model.inverted().transposed();
    m_view_forNormal = m_view.inverted().transposed();

    lightPos.setX(2.0f * qSin(lastFrame));
    lightPos.setY(0.0f);
    lightPos.setZ(1.5f * qCos(lastFrame));

    /*qDebug() << m_model;
    qDebug() << m_view;
    qDebug() << m_projection;*/

    int m_modelLoc = shaderProgram->uniformLocation("modelMatrix");
    int m_viewLoc = shaderProgram->uniformLocation("viewMatrix");
    int m_projectionLoc = shaderProgram->uniformLocation("projectionMatrix");

    shaderProgram->setUniformValue(m_modelLoc, m_model);
    shaderProgram->setUniformValue(m_viewLoc, m_view);
    shaderProgram->setUniformValue(m_projectionLoc, m_projection);

    shaderProgram->setUniformValue(shaderProgram->uniformLocation("viewMatrix_forNormal"), m_view_forNormal); //shaderProgram->setUniformValue(shaderProgram->uniformLocation("modelMatrix_forNormal"), m_model_forNormal);

    shaderProgram->setUniformValue(shaderProgram->uniformLocation("lightPos"), lightPos); // für VS
    //shaderProgram->setUniformValue(shaderProgram->uniformLocation("cameraPos"), camera->getCameraPos());

        // Light properties
    QVector3D lightColor = QVector3D(1.0f, 1.0f, 1.0f);//QVector3D(2.0f, 0.7f, 1.3f);
    //QVector3D light_diffuse = lightColor;// lightColor * 0.5f;

    QColor light_ambient = light->getAmbient();//QVector3D(1.0f, 1.0f, 1.0f);//lightDiffuseColor * 0.2f;
    QColor light_diffuse = light->getDiffuse();//QVector3D(1.0f, 1.0f, 1.0f);//lightDiffuseColor * 0.2f;
    QColor light_specular = light->getSpecular();//QVector3D(1.0f, 1.0f, 1.0f);//lightDiffuseColor * 0.2f;

    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.position"), lightPos);
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.direction"), QVector4D(-0.2f, -1.0f, -0.3f, 1.0f));
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.lightColor"), lightColor);

    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.ambient"), QVector3D(light_ambient.redF(), light_ambient.greenF(), light_ambient.blueF())); //light->getAmbient() * light_ambient
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.diffuse"), QVector3D(light_diffuse.redF(), light_diffuse.greenF(), light_diffuse.blueF())); //light->getAmbient() * light_ambient
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.specular"), QVector3D(light_specular.redF(), light_specular.greenF(), light_specular.blueF())); //light->getAmbient() * light_ambient

    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.pointLight"), light_qml->pointLight());
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.constant"), 1.0f);
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.linear"), light_qml->linear());
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.quadratic"), light_qml->quadratic());

    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.spotLight"), light_qml->spotLight());
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.cameraFront"), camera->getCameraFront());
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.cameraPos"), camera->getCameraPos());
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.cutOff"), (float) qCos(qDegreesToRadians(light_qml->cutOff())));
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.outCutOff"), (float) qCos(qDegreesToRadians(light_qml->outCutOff())));


    //shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.diffuse"), light->getDiffuse() * light_diffuse);
    //shaderProgram->setUniformValue(shaderProgram->uniformLocation("light.specular"), light->getSpecular() * lightColor);

    //shaderProgram->setUniformValue(shaderProgram->uniformLocation("lightColor"), lightColor);

    // Material properties
        //shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.ambient"), QVector3D(0.24725f, 0.1995f, 0.0745f));
        //shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.diffuse"), QVector3D(0.75164f, 0.60648f, 0.22648f));

    for (Model* m : modelList){
        m->Draw(*shader);
    }

    //QVector3D objectColor(1.0f, 0.5f, 0.31f);
    QVector3D objectColor(1.0f, 0.839f, 0.0f);
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("objectColor"), objectColor);

    /*shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.ambient"), QVector3D(1.0f, 1.0f, 1.0f));
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.diffuse"), QVector3D(1.0f, 1.0f, 1.0f));
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.specular"), QVector3D(1.0f, 1.0f, 1.0f));
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.specularStrength"), QVector3D(0.5f, 0.5f, 0.5f));
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.specularShininess"), 32.0f);*/

    /*shader->getVAO()->bind();

    ogl->glActiveTexture(GL_TEXTURE0);
    modelTextures[0]->bind();
    ogl->glActiveTexture(GL_TEXTURE1);
    modelTextures[1]->bind();
    ogl->glActiveTexture(GL_TEXTURE2);
    ogl->glBindTexture(GL_TEXTURE_2D, textureIDs[0]);

    QVector3D cubePositions[] = {
        QVector3D( 0.0f,  0.0f,  0.0f),
        QVector3D( 2.0f,  5.0f, -15.0f),
        QVector3D(-1.5f, -2.2f, -2.5f),
        QVector3D(-3.8f, -2.0f, -12.3f),
        QVector3D( 2.4f, -0.4f, -3.5f),
        QVector3D(-1.7f,  3.0f, -7.5f),
        QVector3D( 1.3f, -2.0f, -2.5f),
        QVector3D( 1.5f,  2.0f, -2.5f),
        QVector3D( 1.5f,  0.2f, -1.5f),
        QVector3D(-1.3f,  1.0f, -1.5f)
    };

    for (GLuint i=0; i<1; i++){
        m_model.setToIdentity();
        m_model.translate(cubePositions[i]);
        float angle = 20.0f * i;
        m_model.rotate(angle, QVector3D(1.0f, 0.3f, 0.5f));
        shaderProgram->setUniformValue(m_modelLoc, m_model);
        ogl->glDrawArrays(GL_TRIANGLES, 0, 36);
    }

    shader->getVAO()->release();*/

    // lightShader
    QOpenGLShaderProgram* shaderLightProgram = shaderLight->getShaderProgram();
    shaderLightProgram->bind();
    shaderLightProgram->setUniformValue(shaderLightProgram->uniformLocation("projectionMatrix"), m_projection);
    shaderLightProgram->setUniformValue(shaderLightProgram->uniformLocation("viewMatrix"), m_view);
    m_model.setToIdentity();
    m_model.translate(lightPos);
    //m_model.translate(QVector3D(3.0f, 0.5f, -1.0f));
    m_model.scale(0.2f);
    shaderLightProgram->setUniformValue(shaderLightProgram->uniformLocation("modelMatrix"), m_model);

    shaderLight->getVAO()->bind();
    ogl->glDrawArrays(GL_TRIANGLES, 0, 36);
    shaderLight->getVAO()->release();
}

CustomItemRenderer::~CustomItemRenderer(){
    if (shader)
        delete shader;

    if (timer->isValid()){
        timer->invalidate();
        delete timer;
    }

    /*for (u_int i=0; i<sizeof(modelTextures); i++){
        if (modelTextures[i])
            delete modelTextures[i];
    }*/


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

void CustomItemBase::activeFocusChangedx(const QString &msg){
    qDebug() << "cpp activeFocusChanged: " << msg;
}

void CustomItemBase::focusChangedSlot(bool focus){
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

   /*if (keysPressed.contains(Qt::Key_Right))
   {
        camera.yaw += 1.0f;
        camera.updateCameraVectors();
    }

    if (keysPressed.contains(Qt::Key_Left))
    {
        camera.yaw -= 1.0f;
        camera.updateCameraVectors();
    }*/

    update();
}

bool CustomItemBase::againUpdate(){
    if (keysPressed.size() > 0 || mouseRightClick)
        return true;

    return false;
}
