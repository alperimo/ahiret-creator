#define Q_DECL_IMPORT __declspec(dllimport)
#define DLLEXPORT __declspec(dllexport)

#include "model.h"

void Model::Draw(Shader &shader)
{
    for (auto m : meshes){
        m->Draw(shader);
    }
}

void Model::loadModel(const QString& path){
    Assimp::Importer import;

    const aiScene *scene = import.ReadFile(path.toStdString().c_str(),
                                           aiProcess_GenSmoothNormals |
                                                       aiProcess_CalcTangentSpace |
                                                       aiProcess_Triangulate |
                                                       aiProcess_JoinIdenticalVertices |
                                                       aiProcess_SortByPType);

    if(!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode)
    {
        qDebug() << "ERROR::ASSIMP::" << import.GetErrorString();
        return;
    }

    if(scene->HasMaterials()){
        for (unsigned int i = 0; i < scene->mNumMaterials; i++){
            auto mater = processMaterial(scene->mMaterials[i]);
            materials.push_back(mater);
        }
    }

    directory = path.mid(0, path.toStdString().find_last_of("/")); // mid for QString, substr for std::string

    processNode(scene->mRootNode, scene);
}

void Model::processNode(aiNode *node, const aiScene *scene){
    for (unsigned int i = 0; i < node->mNumMeshes; i++){
        aiMesh* mesh = scene->mMeshes[node->mMeshes[i]];
        meshes.push_back(processMesh(mesh, scene));
    }

    // for each children node of this node
    for (unsigned int i = 0; i < node->mNumChildren; i++){
        processNode(node->mChildren[i], scene);
    }
}

Mesh* Model::processMesh(aiMesh *mesh, const aiScene *scene){
    QVector<Vertex> vertices;
    QVector<GLuint> indices;
    QVector<Texture> textures;
    QSharedPointer<Material> material_;

    for (unsigned int i = 0; i<mesh->mNumVertices; i++)
    {
        Vertex vertex;
        vertex.position = QVector3D(mesh->mVertices[i].x, mesh->mVertices[i].y, mesh->mVertices[i].z);
        if (mesh->HasNormals())
            vertex.normalCoord = QVector3D(mesh->mNormals[i].x, mesh->mNormals[i].y, mesh->mNormals[i].z);
        if (mesh->mTextureCoords[0]){
            vertex.textureCoord = QVector2D(mesh->mTextureCoords[0][i].x, mesh->mTextureCoords[0][i].y);
            vertex.tangent = QVector3D(mesh->mTangents[i].x, mesh->mTangents[i].y, mesh->mTangents[i].z);
            vertex.biTangent = QVector3D(mesh->mBitangents[i].x, mesh->mBitangents[i].y, mesh->mBitangents[i].z);
        }else{
            vertex.textureCoord = QVector2D(0.0f, 0.0f);
            vertex.tangent = QVector3D(0.0f, 0.0f, 0.0f);
            vertex.biTangent = QVector3D(0.0f, 0.0f, 0.0f);
        }

        vertices.push_back(vertex);
    }

    for (unsigned int i = 0; i<mesh->mNumFaces; i++){
        aiFace face = mesh->mFaces[i];
        for (unsigned int j = 0; j < face.mNumIndices; j++){
            indices.push_back(face.mIndices[j]);
        }
    }

    if (mesh->mMaterialIndex >= 0)
    {
        aiMaterial* material = scene->mMaterials[mesh->mMaterialIndex];
        QVector<Texture> diffuseMaps = loadMaterialTextures(material, aiTextureType_DIFFUSE, "texture_diffuse");
        for (auto t_d : diffuseMaps){
            textures.push_back(t_d);
        }

        QVector<Texture> specularMaps = loadMaterialTextures(material, aiTextureType_SPECULAR, "texture_specular");
        for (auto t_s : specularMaps){
            textures.push_back(t_s);
        }

        QVector<Texture> normalMaps = loadMaterialTextures(material, aiTextureType_NORMALS, "texture_normal");
        for (auto t_n : normalMaps){
            textures.push_back(t_n);
        }

        QVector<Texture> heightMaps = loadMaterialTextures(material, aiTextureType_HEIGHT, "texture_height");
        for (auto t_h : heightMaps){
            textures.push_back(t_h);
        }

        material_ = materials.at(mesh->mMaterialIndex);
    }

    QPointer<Mesh> mx = new Mesh(vertices, indices, textures, material_, ogl_);
    return mx;
}

QVector<Texture> Model::loadMaterialTextures(aiMaterial* mat, aiTextureType type, QString typeName){
    QVector<Texture> textures;
    for (unsigned int i = 0; i < mat->GetTextureCount(type); i++){
        aiString str;
        mat->GetTexture(type, i, &str);

        bool skip = false;
        /*[&]{
            for (Mesh& m: meshes){
                for (Texture t : m.textures){
                    if (t.path == str){
                        skip = true;
                        textures.push_back(t);
                        return;
                    }
                }
            }
        }();*/

        if (!skip)
        {
            Texture texture;
            //texture.id = textureFromFile(str.C_Str(), this->directory);
            texture.id = ModelTexture::textureFromFile(QString("%1/%2").arg(this->directory, str.C_Str()));
            texture.type = typeName;
            texture.path = str;
            textures.push_back(texture);
        }

    }
    return textures;
}

QSharedPointer<Material> Model::processMaterial(aiMaterial *material){
    QSharedPointer<Material> mater(new Material);

    aiString mName;
    material->Get(AI_MATKEY_NAME, mName);

    if (mName.length > 0)
        mater->Name = mName.C_Str();

    int shadingModel;
    material->Get(AI_MATKEY_SHADING_MODEL, shadingModel);

    if (shadingModel != aiShadingMode_Phong && shadingModel != aiShadingMode_Gouraud)
    {
        qDebug() << "This mesh's shading model is not implemented in this loader, setting to default material";
        mater->Name = "DefaultMaterial";

        mater->Ambient = QVector3D(1.0f, 1.0f, 1.0f);
        mater->Diffuse = QVector3D(1.0f, 1.0f, 1.0f);
        mater->Specular = QVector3D(1.0f, 1.0f, 1.0f);
        mater->Emission = QVector3D(1.0f, 1.0f, 1.0f);
        mater->Shininess = 30;

    }else{
        aiColor3D dif(0.f,0.f,0.f);
        aiColor3D amb(0.f,0.f,0.f);
        aiColor3D spec(0.f,0.f,0.f);
        aiColor3D emis(0.f,0.f,0.f);
        float shine = 0.0;

        material->Get(AI_MATKEY_COLOR_AMBIENT, amb);
        material->Get(AI_MATKEY_COLOR_DIFFUSE, dif);
        material->Get(AI_MATKEY_COLOR_SPECULAR, spec);
        material->Get(AI_MATKEY_COLOR_EMISSIVE, emis);
        material->Get(AI_MATKEY_SHININESS, shine);

        mater->Ambient = QVector3D(amb.r, amb.g, amb.b);
        mater->Diffuse = QVector3D(dif.r, dif.g, dif.b);
        mater->Specular = QVector3D(spec.r, spec.g, spec.b);
        mater->Emission = QVector3D(emis.r, emis.g, emis.b);
        mater->Shininess = shine;

        mater->Ambient *= .2; // scale
        if (mater->Shininess == 0.0)
            mater->Shininess = 30;
    }

    return mater;
}
