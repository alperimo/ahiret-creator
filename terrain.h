#ifndef TERRAIN_H
#define TERRAIN_H

#include <QObject>
#include "shader.h"
#include "camera.h"
#include "modeltexture.h"
#include "filesystem.h"

class Terrain : public QObject
{
    Q_OBJECT

public:
    Terrain(int gridX, int gridZ, QList<QSharedPointer<Shader>>& shaders, const Camera* camera);

    void appendTexture(const QList<QString>& texturePaths, FileSystem* fileSystem);
    void loadTexture(QSharedPointer<Shader> shader, const int& lodLevel);
    void renderTerrain();

    decltype (auto) getTerrainPosition() { return position; }
    auto getVertices() -> const QVector<float>& { return vertices; }

private:
    struct Texture{
        GLuint id;
    };

protected:

private:
    QVector3D position;

    QList<QSharedPointer<Shader>> shaders;
    const Camera* camera;

    // LOD_TERRAIN
    const float NODE_COUNT = 16;
    QList<float> VERTEX_COUNTS = {32, 8, 2};
    QVector<float> maxDistanceLevels;

    QVector<float> hqVertices, mqVertices, lqVertices;
    QVector<int> hqIndices, mqIndices, lqIndices;
    double hqIndicesPointer = 0, mqIndicesPointer = 0, lqIndicesPointer = 0;

    // END_OF_LOD_TERRAIN

    const float GRID_SIZE = 256;
    //const float VERTEX_COUNT = 128;

    int gridX, gridZ;
    std::vector<float> xz;

    QVector<Texture> textures;

    QVector<float> vertices;
    QVector<int> indices;

    void setTerrainGridXZ(int gridX, int gridZ);
    void setMaxDistanceLevels();
    void loadVertex(const int& nodeX, const int& nodeZ, const int& lodLevel, QVector<float>& vertices, QVector<int>& indices);
    void generateTerrain();

};

#endif // TERRAIN_H
