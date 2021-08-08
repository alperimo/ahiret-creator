#include "terrain.h"

Terrain::Terrain(int gridX, int gridZ, Shader* shader)
{
    this->shader = shader;
    setTerrainGridXZ(gridX, gridZ);
}

void Terrain::setTerrainGridXZ(int gridX, int gridZ){
    this->gridX = gridX;
    this->gridZ = gridZ;

    xz[0] = gridX * GRID_SIZE;
    xz[1] = gridZ * GRID_SIZE;

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

    for (int z=0; z<VERTEX_COUNT; z++){
        for (int x=0; x<VERTEX_COUNT; x++){
            //coord vertices
            vertices.push_back((float)x / (VERTEX_COUNT-1) * GRID_SIZE); // x
            vertices.push_back(0); // y (für jetzt ist es 0, da HeightMap nicht implementiert wird)
            vertices.push_back((float)z / (VERTEX_COUNT-1) * GRID_SIZE); // z
            //normal vertices
            vertices.push_back(0);
            vertices.push_back(1);
            vertices.push_back(0);
            //texture vertices
            vertices.push_back((float)x / (VERTEX_COUNT-1)); // u
            vertices.push_back((float)z / (VERTEX_COUNT-1)); // v
        }
    }

    for (int iz=0; iz<VERTEX_COUNT-1; iz++){
        for (int ix=0; ix<VERTEX_COUNT-1; ix++){
            int topLeft = (iz)*VERTEX_COUNT + ix;
            int topRight = topLeft+1;
            int bottomLeft = (iz+1)*VERTEX_COUNT + ix;
            int bottomRight = bottomLeft+1;
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
    shader->getVAO()->bind();
    QOpenGLFunctions* ogl = QOpenGLContext::currentContext()->functions();
    ogl->glDrawElements(GL_TRIANGLES, indices.size(), GL_UNSIGNED_INT, 0);
    shader->getVAO()->release();
}
