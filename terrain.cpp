#include "terrain.h"

Terrain::Terrain(int gridX, int gridZ, Shader* shader)
{
    this->shader = shader;
    setTerrainGridXZ(gridX, gridZ);
}

void Terrain::setTerrainGridXZ(int gridX, int gridZ){
    this->gridX = gridX;
    this->gridZ = gridZ;

    xz.clear();
    xz.push_back(gridX * GRID_SIZE);
    xz.push_back(gridZ * GRID_SIZE);
    position = QVector3D(xz.at(0), 0.0f, xz.at(1));

    generateTerrain();
}

void Terrain::appendTexture(const QList<QString>& texturePaths, FileSystem* fileSystem){
    for (auto& t : texturePaths){
        Texture texture;
        texture.id = ModelTexture::textureFromFile(QString("%1/%2").arg(fileSystem->getTerrainPath(), t));
        textures.append(texture);
    }
}

void Terrain::generateTerrain(){

    /*float verticesx[] = {
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

    QOpenGLFunctions* ogl = shader->ogl_->currentContext()->functions();

    shader->getShaderProgram()->bind();
    shader->getVAO()->bind();
    shader->getVBO()->bind();

    shader->getVBO()->allocate(verticesx, sizeof(verticesx));

    ogl->glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (void*)0);
    ogl->glEnableVertexAttribArray(0);

    ogl->glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (void*)(3 * sizeof(float)));
    ogl->glEnableVertexAttribArray(1);

    ogl->glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (void*)(6 * sizeof(float)));
    ogl->glEnableVertexAttribArray(2);*/


    vertices.clear();
    indices.clear();

    /*QVector<float> test = {0.0f, 0.0f, -1.0f,
                          0.0f, 0.0f, 0.0f,
                          1.0f, 0.0f, -1.0f,
                           1.0f, 0.0f, -1.0f,
                           0.0f, 0.0f, 0.0f,
                          1.0f, 0.0f, 0.0f};
    vertices.append(test);

    QVector<int> test2 = {0, 1, 2, 2, 1, 5};
    indices.append(test2);*/

    QVector<float> fakeVertices;
    int tp = 0, ap = 0;
    for (int z=0; z<VERTEX_COUNT; z++){
        for (int x=0; x<VERTEX_COUNT; x++){
            //coord vertices
            vertices.push_back((float)x / ((float)VERTEX_COUNT-1) * GRID_SIZE); // x
            vertices.push_back(0.0f); // y (für jetzt ist es 0, da HeightMap nicht implementiert wird)
            vertices.push_back((float)z / ((float)VERTEX_COUNT-1) * GRID_SIZE); // z

            //normal vertices
            vertices.push_back(0.0f);
            vertices.push_back(1.0f);
            vertices.push_back(0.0f);
            //texture vertices
            vertices.push_back((float)x / ((float)VERTEX_COUNT-1)); // u
            vertices.push_back((float)z / ((float)VERTEX_COUNT-1)); // v

            //fake vertices
            if (tp % 3) {
                tp = 0;
                ap++;
            }

            fakeVertices.push_back(ap*8 + tp);
            tp++;
        }
    }

    qDebug() << "size of fakeVertices: " << fakeVertices.size();


    for (int iz=0; iz<VERTEX_COUNT-1; iz++){
        for (int ix=0; ix<VERTEX_COUNT-1; ix++){
            int topLeft = (iz*VERTEX_COUNT) + ix;
            int topRight = topLeft+1;
            int bottomLeft = ((iz+1)*VERTEX_COUNT) + ix;
            int bottomRight = bottomLeft+1;
            /*int topLeft = fakeVertices.at((iz*VERTEX_COUNT) + ix);
            int topRight = topLeft+1;
            int bottomLeft = fakeVertices.at(((iz+1)*VERTEX_COUNT) + ix);
            int bottomRight = bottomLeft+1;*/
            indices.push_back(topLeft);
            indices.push_back(bottomLeft);
            indices.push_back(topRight);
            indices.push_back(topRight);
            indices.push_back(bottomLeft);
            indices.push_back(bottomRight);
        }
    }

    shader->loadToVAO(vertices, indices);
}

void Terrain::renderTerrain(){
    QOpenGLFunctions* ogl = shader->ogl_->currentContext()->functions();

    /*for (GLuint i = 0; i < textures.size(); i++){
        ogl->glActiveTexture(GL_TEXTURE0 + i);

        shader->getShaderProgram()->setUniformValue(shader->getShaderProgram()->uniformLocation(QString("textures[%1]").arg(i)), i);
        ogl->glBindTexture(GL_TEXTURE_2D, textures[i].id);
    }*/

    QMatrix4x4 m_model;
    m_model.setToIdentity();
    m_model.translate(getTerrainPosition());
    shader->getShaderProgram()->setUniformValue(shader->getShaderProgram()->uniformLocation("modelMatrix"), m_model);

    //qDebug() << "vertices size for terrain: " << vertices.size();
    shader->getVAO()->bind();
    //ogl->glDrawArrays(GL_TRIANGLES, 0, vertices.size());
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    ogl->glDrawElements(GL_TRIANGLES, indices.size(), GL_UNSIGNED_INT, 0);
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    shader->getVAO()->release();
}
