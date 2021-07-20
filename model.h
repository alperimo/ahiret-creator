#include "mesh.h"



class Model : public QObject
{
    Q_OBJECT
public:
    Model(const QString& path, QOpenGLContext* ogl){
        loadModel(path);

        this->ogl_ = ogl;
    };

    QOpenGLContext* ogl_;

    void Draw(Shader& shader);

private:
    QVector<Mesh*> meshes;
    QVector<QSharedPointer<Material>> materials;
    QString directory;

    void loadModel(const QString& path);
    void processNode(aiNode* node, const aiScene* scene);
    Mesh* processMesh(aiMesh* mesh, const aiScene* scene);
    QVector<Texture> loadMaterialTextures(aiMaterial* mat, aiTextureType type, QString typeName);
    QSharedPointer<Material> processMaterial(aiMaterial* material);

    GLuint textureFromFile(const char* fileName_, const QString& directory, bool gamma = false);
};

