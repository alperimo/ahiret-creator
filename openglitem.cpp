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
}

void CustomItemRenderer::render()
{
    std::cout << "render()!!!" << std::endl;

    if (firstRender){
        // hier könnte es initialisierungen geben.
        firstRender = false;
        ogl->glEnable(GL_DEPTH_TEST); // zBuffer/Depthbuffer/Depth testing aktif.
        initialize();
    }

    std::cout << "after first render" << std::endl;

    //glDisable(GL_DEPTH_TEST);
    //glDepthMask(true);

    ogl->glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    ogl->glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);  //glClear(GL_COLOR_BUFFER_BIT);

    /*
        ogl->glUseProgram(0);
        glBegin(GL_TRIANGLES);
            glVertex3d(0.0, 1.0, 0.0);
            glVertex3d(-1.0, -1.0, 0.0);
            glVertex3d(1.0, -1.0, 0.0);
        glEnd();
        glPopMatrix();

        glDrawArrays(GL_TRIANGLES, 0, 3);
    */

    drawObject();
    //update();


    if (m_Window){
        //std::cout << "resetOpenGLState()" << std::endl;
        //m_Window->resetOpenGLState();
    }

}

void CustomItemRenderer::synchronize(QQuickFramebufferObject *item) {
    std::cout << "CustomItemRenderer::synchronize()" << std::endl;
    CustomItemBase *customItemBase = static_cast<CustomItemBase *>(item);
    m_rotation = customItemBase->rotation();

    m_Window = item->window();

    item->setMirrorVertically(true); //qt default kordinat sistemini opengl'e göre düzenler(bu sayede y: 1.0 ekranın üstü olacak.)

    GLsizei w = item->width();
    GLsizei h = item->height();
    ogl->glViewport(0, 0, w, h);

    m_projection.setToIdentity();
    m_projection.perspective(45.0f, GLfloat(w) / GLfloat(h), 0.01f, 100.0f);

    //std::cout << "m_Window->width() = " << m_Window->width() << " height: " << m_Window->height() << std::endl;
    std::cout << "openGL window width() = " << item->width() << " height: " << item->height() << std::endl;
}

void CustomItemRenderer::drawObject(){
    QOpenGLShaderProgram *shaderProgram = shader->getShaderProgram();
    shaderProgram->bind();
    shader->getVAO()->bind();

    QMatrix4x4 m_model;
    QMatrix4x4 m_view;

    m_model.setToIdentity();
    m_model.rotate(50, QVector3D(0, 1, 0));
    m_view.setToIdentity();
    m_view.translate(0, 0, -3);


    qDebug() << m_model;
    qDebug() << m_view;
    qDebug() << m_projection;

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
}

// Item
void CustomItemBase::setRotation(const QVector3D &v){
    std::cout << "CustomItemBase::setRotation()" << std::endl;
    if (m_rotation != v){
        m_rotation = v;
        emit rotationChanged();
        update();
    }
}
