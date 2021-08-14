#include "shader.h"

Shader::Shader(QString vertexShader, QString fragmentShader, QOpenGLContext *ogl)
{
    // Shader program oluşturma, vertex ve fragment shader oluşturup shader programa bağlanması

    m_program = new QOpenGLShaderProgram();

    QString vertexShaderUrl = ":/shaders/" + vertexShader;
    QString fragmentShaderUrl = ":/shaders/" + fragmentShader;

    if (!m_program->addShaderFromSourceFile(QOpenGLShader::Vertex, vertexShaderUrl)){
        qDebug() << "Vertex shader errors for " << vertexShader << ":\n" << m_program->log();
    }

    if (!m_program->addShaderFromSourceFile(QOpenGLShader::Fragment, fragmentShaderUrl))
    {
        qDebug() << "Fragment shader errors for " << fragmentShader << ":\n" << m_program->log();
    }

    if (!m_program->link())
        qDebug() << "Shader linker errors for :\n" << m_program->log();

    m_vbo = QOpenGLBuffer(QOpenGLBuffer::VertexBuffer);
    m_vbo.create();
    m_vbo.bind();
    m_vbo.setUsagePattern(QOpenGLBuffer::StaticDraw);

    m_ebo = QOpenGLBuffer(QOpenGLBuffer::IndexBuffer);
    m_ebo.create();
    m_ebo.bind();
    m_ebo.setUsagePattern(QOpenGLBuffer::StaticDraw);

    m_vao.create();
    m_vao.bind();

    this->ogl_ = ogl;

    /*m_program->enableAttributeArray(0);
    //m_program->setAttributeBuffer(0, GL_FLOAT, 0, 3); //3 vertex, 2 koordinats için
    m_program->setAttributeBuffer(0, GL_FLOAT, 0, 3, 5 * sizeof(GL_FLOAT));

    m_program->enableAttributeArray(1);
    m_program->setAttributeBuffer(1, GL_FLOAT, 3 * sizeof(GL_FLOAT), 2, 5 * sizeof(GL_FLOAT));*/


    //vbo,ebo ve vao release


    std::cout << "Shader() olusturuldu." << std::endl;
}

void Shader::loadToVAO(QVector<float> vertices, QVector<int> indices){

    if (vertices.size() == 0 || indices.size() == 0)
        return;

    QOpenGLFunctions* ogl = ogl_->currentContext()->functions();

    m_program->bind();
    m_vao.bind();
    m_vbo.bind();

    m_vbo.allocate(&vertices[0], vertices.size() * sizeof(float));

    ogl->glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (void*)0);
    ogl->glEnableVertexAttribArray(0);

    ogl->glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (void*)(3 * sizeof(float)));
    ogl->glEnableVertexAttribArray(1);

    ogl->glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (void*)(6 * sizeof(float)));
    ogl->glEnableVertexAttribArray(2);

    m_ebo.bind();
    m_ebo.allocate(&indices[0], indices.size() * sizeof(int));
}

Shader::~Shader(){
    m_vao.destroy();
    m_vbo.destroy();
    m_ebo.destroy();
    delete m_program;
}

void Shader::releaseShader(){
    m_vbo.release();
    m_ebo.release();
    m_vao.release();
}
