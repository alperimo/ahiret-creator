#include "modeltexture.h"

ModelTexture::ModelTexture()
{

}

GLuint ModelTexture::textureFromFile(const QString& filePath, bool gamma){

    QOpenGLFunctions* ogl = QOpenGLContext::currentContext()->functions();

    QImage textureEmission;
    bool loaded = textureEmission.load(filePath);

    GLuint textureID;
    ogl->glGenTextures(1, &textureID);

    if (loaded)
    {
        textureEmission = QGLWidget::convertToGLFormat(textureEmission);

        ogl->glBindTexture(GL_TEXTURE_2D, textureID);
        ogl->glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureEmission.width(), textureEmission.height(), 0, GL_RGBA, GL_UNSIGNED_BYTE, textureEmission.bits());
        ogl->glGenerateMipmap(GL_TEXTURE_2D);

        ogl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        ogl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        ogl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        ogl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    }
    else
    {
        qDebug() << "Texture failed to load with QImage at path : " << filePath;
    }

    return textureID;
}

GLuint ModelTexture::readDDSFile(const QString &filename)
{
    QOpenGLFunctions* ogl = QOpenGLContext::currentContext()->functions();

    QGLWidget glWidget;
    glWidget.makeCurrent();

    GLuint texture = glWidget.bindTexture(filename);
    if (!texture)
        return 0;

    // Determine the size of the DDS image
    GLint width, height;
    glBindTexture(GL_TEXTURE_2D, texture);
    glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, &width);
    glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, &height);

    if (width == 0 || height == 0)
        return 0;

    QGLPixelBuffer pbuffer(QSize(width, height), glWidget.format(), &glWidget);
    if (!pbuffer.makeCurrent())
        return 0;

    pbuffer.drawTexture(QRectF(-1, -1, 2, 2), texture);

    GLuint textureID;
    QImage textureLoaded = pbuffer.toImage();
    textureLoaded = QGLWidget::convertToGLFormat(textureLoaded);

    ogl->glBindTexture(GL_TEXTURE_2D, textureID);
    ogl->glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureLoaded.width(), textureLoaded.height(), 0, GL_RGBA, GL_UNSIGNED_BYTE, textureLoaded.bits());
    ogl->glGenerateMipmap(GL_TEXTURE_2D);

    ogl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    ogl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    ogl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    ogl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    return textureID;
}
