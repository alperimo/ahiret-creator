#include "modeltexture.h"

ModelTexture::ModelTexture()
{

}

GLuint ModelTexture::textureFromFile(const QString& filePath, bool gamma){

    QOpenGLFunctions* ogl = QOpenGLContext::currentContext()->functions();

    //QString filename = QStringLiteral("%1/%2").arg(directory, fileName_);

    QImage textureEmission;
    bool loaded = textureEmission.load(filePath);

    GLuint textureID;
    ogl->glGenTextures(1, &textureID);

    if (loaded)
    {
        qDebug() << "image width: " << textureEmission.width();
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
