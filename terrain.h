#ifndef TERRAIN_H
#define TERRAIN_H

#include <QObject>
#include "shader.h"
#include "modeltexture.h"
#include "filesystem.h"

class Terrain : public QObject
{
    Q_OBJECT

public:
    Terrain(int gridX, int gridZ, Shader* shader);

    void appendTexture(const QList<QString>& texturePaths, FileSystem* fileSystem);
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

    Shader* shader;

    const float GRID_SIZE = 256;
    const float VERTEX_COUNT = 128;
    int gridX, gridZ;
    std::vector<float> xz;

    QVector<Texture> textures;

    QVector<float> vertices;
    QVector<int> indices;

    float vertices_[];

    void setTerrainGridXZ(int gridX, int gridZ);
    void generateTerrain();

};

#endif // TERRAIN_H
