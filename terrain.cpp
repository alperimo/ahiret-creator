#include "terrain.h"
#include "math.h"

Terrain::Terrain(int gridX, int gridZ, QList<QSharedPointer<Shader>>& shaders, const Camera* camera)
{
    this->shaders = shaders;
    this->camera = camera;

    setMaxDistanceLevels();
    setTerrainGridXZ(gridX, gridZ);
}

void Terrain::setTerrainGridXZ(int gridX, int gridZ){
    this->gridX = gridX;
    this->gridZ = gridZ;

    xz.clear();
    xz.push_back(gridX * GRID_SIZE);
    xz.push_back(gridZ * GRID_SIZE);
    position = QVector3D(xz.at(0), 0.0f, xz.at(1));

}

void Terrain::appendTexture(const QList<QString>& texturePaths, FileSystem* fileSystem){
    for (auto& t : texturePaths){
        Texture texture;
        texture.id = ModelTexture::textureFromFile(QString("%1/%2").arg(fileSystem->getTerrainPath(), t));
        textures.append(texture);
    }
}

void Terrain::setMaxDistanceLevels(){
    float hq_lv1 = GRID_SIZE / NODE_COUNT * (2*sqrt(2));
    float mq_lv1 = GRID_SIZE / NODE_COUNT * (4*sqrt(2));
    maxDistanceLevels.push_back(hq_lv1);
    maxDistanceLevels.push_back(mq_lv1);
}

void Terrain::generateTerrain(){

    hqVertices.clear(); mqVertices.clear(); lqVertices.clear();
    hqIndices.clear(); mqIndices.clear(); lqIndices.clear();
    hqIndicesPointer = 0; mqIndicesPointer = 0; lqIndicesPointer = 0;

    QVector3D cameraPos = camera->getCameraPos();

    /*for (int q=0; q<16; q++){
        hqVertices.push_back(0); // startX + (x/(VERTEX_COUNT-1) * (endX-startX))
        hqVertices.push_back(0.0f);
        hqVertices.push_back(0); // z

        //normal vertices
        hqVertices.push_back(0.0f);
        hqVertices.push_back(1.0f);
        hqVertices.push_back(0.0f);
        //texture vertices
        hqVertices.push_back(0); // u
        hqVertices.push_back(0); // v
    }*/

    for (int z=1; z<NODE_COUNT+1; z++){
        for (int x=1; x<NODE_COUNT+1; x++){
            QVector3D vertexPos(x/(NODE_COUNT-1) * GRID_SIZE, 0.0f, z/(NODE_COUNT) * GRID_SIZE);
            QVector3D vertexWorldPos = vertexPos + position;

            // x --> x-1 node
            float distance = cameraPos.distanceToPoint(vertexWorldPos);
            if (distance <= maxDistanceLevels.at(0)) // HIGH_QUALITY
            {
                loadVertex(x, z, 0, hqVertices, hqIndices);
            }else if(distance > maxDistanceLevels.at(0) && distance <= maxDistanceLevels.at(1)){ // MEDIUM_QUALITY
                loadVertex(x, z, 1, mqVertices, mqIndices);
            }else{ // LOW_QUALITY
                loadVertex(x, z, 2, lqVertices, lqIndices);
            }

            //loadVertex(x, z, 0, hqVertices, hqIndices);

        }
    }

    //qDebug() << "size hqVertices, mq, lq: " << hqVertices.size() << " " << mqVertices.size() << " " << lqVertices.size();
    //qDebug() << "size hqIndices, mq, lq: " << hqIndices.size() << " " << mqIndices.size() << " " << lqIndices.size();
    //qDebug() << "hqIndicesPointer, mq, lq: " << hqIndicesPointer << " " << mqIndicesPointer << " " << lqIndicesPointer;

    shaders.at(0)->loadToVAO(hqVertices, hqIndices);
    shaders.at(1)->loadToVAO(mqVertices, mqIndices);
    shaders.at(2)->loadToVAO(lqVertices, lqIndices);

    //qDebug() << "hqVertices: " << hqVertices;
    //qDebug() << "hqIndices: " << hqIndices;

}

void Terrain::loadVertex(const int& nodeX, const int& nodeZ, const int& lodLevel, QVector<float>& vertices, QVector<int>& indices)
{

    const float& VERTEX_COUNT = VERTEX_COUNTS[lodLevel];
    float nodeSelectedX = (float)nodeX/(NODE_COUNT) * GRID_SIZE; // x*(GRID_SIZE/NODE_COUNT);
    float nodePreviousX = (float)(nodeX-1)/(NODE_COUNT) * GRID_SIZE; //startX + (GRID_SIZE/NODE_COUNT);

    float nodeSelectedZ = (float)nodeZ/(NODE_COUNT) * GRID_SIZE;
    float nodePreviousZ = (float)(nodeZ-1)/(NODE_COUNT) * GRID_SIZE;

    //qDebug() << nodeX << ", " << nodeZ << " = " << nodeSelectedX << ", " << nodeSelectedZ;

    int addedVertexCount = 0;

    for (int z=0; z<VERTEX_COUNT; z++){
        for (int x=0; x<VERTEX_COUNT; x++){

            //coord vertices
            float nodeCurrentX = nodePreviousX + (x/(VERTEX_COUNT-1) * (nodeSelectedX-nodePreviousX));
            float nodeCurrentZ = nodePreviousZ + (z/(VERTEX_COUNT-1) * (nodeSelectedZ-nodePreviousZ));

            //qDebug() << nodeX << ", " << nodeZ << " -- " << x << ", " << z << " = " << nodeCurrentX << ", " << nodeCurrentZ;
            vertices.push_back(nodeCurrentX); // startX + (x/(VERTEX_COUNT-1) * (endX-startX))
            vertices.push_back(0.0f);
            vertices.push_back(nodeCurrentZ); // z

            //normal vertices
            vertices.push_back(0.0f);
            vertices.push_back(1.0f);
            vertices.push_back(0.0f);
            //texture vertices
            vertices.push_back(nodeCurrentX / GRID_SIZE); // u
            vertices.push_back(nodeCurrentZ / GRID_SIZE); // v

            addedVertexCount++;
        }
    }

    double indicesPointer = vertices.size()/8 - addedVertexCount; //(lodLevel == 0) ? hqIndices.size() : (lodLevel == 1) ? mqIndices.size() : lqIndices.size();
    //if (indicesPointer != 0) indicesPointer++;

    //qDebug() << nodeX << ", " << nodeZ << " -- indicesPointer: " << indicesPointer << " indices size: " << indices.size();

    for (int iz=0; iz<VERTEX_COUNT-1; iz++){
        for (int ix=0; ix<VERTEX_COUNT-1; ix++){
            int topLeft = indicesPointer + ((iz*VERTEX_COUNT) + ix);
            int topRight = (topLeft+1);
            int bottomLeft = indicesPointer + (((iz+1)*VERTEX_COUNT) + ix);
            int bottomRight = (bottomLeft+1);

            //if ((nodeX == 2 && nodeZ == 2))
            //    qDebug() << "topLeft: " << topLeft << " bottomLeft: " << bottomLeft;

            indices.push_back(topLeft);
            indices.push_back(bottomLeft);
            indices.push_back(topRight);
            indices.push_back(topRight);
            indices.push_back(bottomLeft);
            indices.push_back(bottomRight);


        }
    }


}

void Terrain::renderTerrain(){

    QOpenGLFunctions* ogl = shaders.at(0)->ogl_->currentContext()->functions();

    /*for (GLuint i = 0; i < textures.size(); i++){
        ogl->glActiveTexture(GL_TEXTURE0 + i);

        shader->getShaderProgram()->setUniformValue(shader->getShaderProgram()->uniformLocation(QString("textures[%1]").arg(i)), i);
        ogl->glBindTexture(GL_TEXTURE_2D, textures[i].id);
    }*/

    //qDebug() << "vertices size for terrain: " << vertices.size();
    //ogl->glDrawArrays(GL_TRIANGLES, 0, vertices.size());

    generateTerrain();

    QMatrix4x4 m_model;
    m_model.setToIdentity();
    m_model.translate(getTerrainPosition());

    QOpenGLShaderProgram* shaderProgramHq = shaders.at(0)->getShaderProgram();
    QOpenGLShaderProgram* shaderProgramMq = shaders.at(1)->getShaderProgram();
    QOpenGLShaderProgram* shaderProgramLq = shaders.at(2)->getShaderProgram();

    shaderProgramHq->setUniformValue(shaderProgramHq->uniformLocation("modelMatrix"), m_model);
    shaders.at(0)->getVAO()->bind();
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    ogl->glDrawElements(GL_TRIANGLES, hqIndices.size(), GL_UNSIGNED_INT, 0);
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    shaders.at(0)->getVAO()->release();

    shaderProgramMq->setUniformValue(shaderProgramHq->uniformLocation("modelMatrix"), m_model);
    shaders.at(1)->getVAO()->bind();
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    ogl->glDrawElements(GL_TRIANGLES, mqIndices.size(), GL_UNSIGNED_INT, 0);
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    shaders.at(1)->getVAO()->release();

    shaderProgramLq->setUniformValue(shaderProgramHq->uniformLocation("modelMatrix"), m_model);
    shaders.at(2)->getVAO()->bind();
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    ogl->glDrawElements(GL_TRIANGLES, lqIndices.size(), GL_UNSIGNED_INT, 0);
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    shaders.at(2)->getVAO()->release();

}
