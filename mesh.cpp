#include "mesh.h"

/*Mesh::Mesh(QVector<Vertex> vertices_, QVector<GLuint> indices_, QVector<Texture> textures_) : vertices(vertices_), indices(indices_), textures(textures_){
    setupMesh();
};*/

Mesh::Mesh(QVector<Vertex> vertices_, QVector<GLuint> indices_, QVector<Texture> textures_, QSharedPointer<Material> material_, QOpenGLContext* ogl){
    this->vertices = vertices_;
    this->indices = indices_;
    this->textures = textures_;
    this->material = material_;

    this->ogl_ = ogl;

    setupMesh();
};

Mesh::~Mesh(){

}

void Mesh::setupMesh(){
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

    QOpenGLFunctions* ogl = ogl_->currentContext()->functions();

    m_vbo.bind();
    m_vbo.allocate(&vertices[0], vertices.size() * static_cast<int>(sizeof(Vertex)));

    m_ebo.bind();
    m_ebo.allocate(&indices[0], indices.size() * static_cast<int>(sizeof(GLuint)));

    qDebug() << "vertices[0]: " << vertices[0].position;

    qDebug() << "vertices[1]: " << vertices[1].position;

    ogl->glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)0);
    ogl->glEnableVertexAttribArray(0);

    ogl->glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)(offsetof(Vertex, normalCoord))); //(void*)(3 * sizeof(GLfloat))
    ogl->glEnableVertexAttribArray(1);

    ogl->glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)(offsetof(Vertex, textureCoord)));
    ogl->glEnableVertexAttribArray(2);

    ogl->glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)(offsetof(Vertex, tangent)));
    ogl->glEnableVertexAttribArray(3);

    ogl->glVertexAttribPointer(4, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)(offsetof(Vertex, biTangent)));
    ogl->glEnableVertexAttribArray(4);

    m_vao.release();

}

void Mesh::Draw(Shader &shader){
    GLuint diffuseNr = 0, specularNr = 0, emissionNr = 0;

    //QOpenGLFunctions *ogl = QOpenGLContext::currentContext()->functions();
    QOpenGLFunctions* ogl = ogl_->currentContext()->functions();
    QOpenGLShaderProgram* shaderProgram = shader.getShaderProgram();

    shaderProgram->bind();

    //qDebug() << "test ogl: " << ogl;

    for (GLuint i = 0; i < textures.size(); i++){
        ogl->glActiveTexture(GL_TEXTURE0 + i);
        QString textureNummer;
        QString textureName = textures[i].type;
        if (textureName == "texture_diffuse")
            textureNummer = QString::number(diffuseNr++);
        else if(textureName == "texture_specular")
            textureNummer = QString::number(specularNr++);
        else if(textureName == "texture_emission")
            textureNummer = QString::number(emissionNr++);

        shaderProgram->setUniformValue(shaderProgram->uniformLocation(QString("material.%1[%2]").arg(textureName, textureNummer)), i);
        ogl->glBindTexture(GL_TEXTURE_2D, textures[i].id);
    }

    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.ambient"), material->Ambient);
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.diffuse"), material->Diffuse);
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.specular"), material->Specular);
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.emission"), material->Emission);
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.specularStrength"), QVector3D(0.5f, 0.5f, 0.5f));
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.specularShininess"), material->Shininess);

    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.texture_activ[0]"), (diffuseNr > 0) ? true : false);
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.texture_activ[1]"), (specularNr > 0) ? true : false);
    shaderProgram->setUniformValue(shaderProgram->uniformLocation("material.texture_activ[2]"), (emissionNr > 0) ? true : false);

    //ogl->glActiveTexture(GL_TEXTURE0);

    m_vao.bind();
    //ogl->glDrawArrays(GL_TRIANGLES, 0, 36);


    //qDebug() << "m_vao : " << m_vao.objectId() << " size of vertices: " << vertices.size() << " size of indices " << indices.size();
    ogl->glDrawElements(GL_TRIANGLES, indices.size(), GL_UNSIGNED_INT, 0);
    m_vao.release();
}
