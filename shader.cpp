#include "shader.h"

Shader::Shader(QString vertexShader, QString fragmentShader, QOpenGLFunctions *ogl)
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

    /*m_program->enableAttributeArray(0);
    //m_program->setAttributeBuffer(0, GL_FLOAT, 0, 3); //3 vertex, 2 koordinats için
    m_program->setAttributeBuffer(0, GL_FLOAT, 0, 3, 5 * sizeof(GL_FLOAT));

    m_program->enableAttributeArray(1);
    m_program->setAttributeBuffer(1, GL_FLOAT, 3 * sizeof(GL_FLOAT), 2, 5 * sizeof(GL_FLOAT));*/


    //vbo,ebo ve vao release


    std::cout << "Shader() olusturuldu." << std::endl;
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
