//#define DLLEXPORT __declspec(dllimport)

#include <QPointer>
#include <QSharedPointer>

#include <QVector>
#include <QVector3D>
#include <QVector2D>

#include <QOpenGLFunctions>
#include <QOpenGLBuffer>
#include <QOpenGLVertexArrayObject>
#include <QGLWidget>

#include <QImage>

#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>

#include <shader.h>
#include "stb_image.h"

struct Vertex
{
    QVector3D position;
    QVector3D normalCoord;
    QVector2D textureCoord;
    QVector3D tangent;
    QVector3D biTangent;
};

struct Texture{
    GLuint id;
    QString type;
    aiString path;
};

struct Material
{
    QString Name;
    QVector3D Ambient;
    QVector3D Diffuse;
    QVector3D Specular;
    QVector3D Emission;
    float Shininess;
};

class Mesh : public QObject
{
    Q_OBJECT
public:

    QVector<Vertex> vertices;
    QVector<GLuint> indices;
    QVector<Texture> textures;
    QSharedPointer<Material> material;

    Mesh(QVector<Vertex> vertices_, QVector<GLuint> indices_, QVector<Texture> textures_, QSharedPointer<Material> material_, QOpenGLContext* ogl);
    ~Mesh();

    QOpenGLContext* ogl_;

    void Draw(Shader &shader);

private:
    QOpenGLVertexArrayObject m_vao;
    QOpenGLBuffer m_vbo;
    QOpenGLBuffer m_ebo;

    void setupMesh();
};
