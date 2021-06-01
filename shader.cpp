#include "shader.h"

Shader::Shader(QOpenGLFunctions *ogl)
{
    // Shader program oluşturma, vertex ve fragment shader oluşturup shader programa bağlanması
    m_program = new QOpenGLShaderProgram();

    if (!m_program->addShaderFromSourceFile(QOpenGLShader::Vertex, ":/shaders/vertexShader.txt")){
        qDebug() << "Vertex shader errors :\n" << m_program->log();
    }

    if (!m_program->addShaderFromSourceFile(
        QOpenGLShader::Fragment, ":/shaders/fragmentShader.txt"))
    {
        qDebug() << "Fragment shader errors :\n" << m_program->log();
    }

    if (!m_program->link())
        qDebug() << "Shader linker errors :\n" << m_program->log();

    // VBO ve EBO(indices buffer object) oluşturma
    float vertices[] = {
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
         0.5f, -0.5f, -0.5f,  1.0f, 0.0f,
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,

        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
         0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,

        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

         0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
         0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
         0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
         0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
         0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
         0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
         0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,

        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f
    };

    unsigned int indices[] = {  // note that we start from 0!
        0, 1, 3,   // first triangle
        1, 2, 3    // second triangle
    };

    m_vbo = QOpenGLBuffer(QOpenGLBuffer::VertexBuffer);
    m_vbo.create();
    m_vbo.setUsagePattern(QOpenGLBuffer::StaticDraw);
    m_vbo.bind(); //VBO bağlandı. bu sayede içine veriler yazılabilir.
    m_vbo.allocate(vertices, sizeof(vertices));

    m_ebo = QOpenGLBuffer(QOpenGLBuffer::IndexBuffer);
    m_ebo.create();
    m_ebo.setUsagePattern(QOpenGLBuffer::StaticDraw);
    m_ebo.bind();
    m_ebo.allocate(indices, sizeof(indices));

    m_vao.create();
    m_vao.bind();

    /*m_program->enableAttributeArray(0);
    //m_program->setAttributeBuffer(0, GL_FLOAT, 0, 3); //3 vertex, 2 koordinats için
    m_program->setAttributeBuffer(0, GL_FLOAT, 0, 3, 5 * sizeof(GL_FLOAT));

    m_program->enableAttributeArray(1);
    m_program->setAttributeBuffer(1, GL_FLOAT, 3 * sizeof(GL_FLOAT), 2, 5 * sizeof(GL_FLOAT));*/

    ogl->glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), (void*)0);
    ogl->glEnableVertexAttribArray(0);

    ogl->glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), (void*)(3 * sizeof(float)));
    ogl->glEnableVertexAttribArray(1);
    //vbo,ebo ve vao release
    m_vbo.release();
    m_ebo.release();
    m_vao.release();

    std::cout << "Shader() olusturuldu." << std::endl;
}

Shader::~Shader(){
    m_vao.destroy();
    m_vbo.destroy();
    m_ebo.destroy();
    delete m_program;
}
