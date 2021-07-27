#include "filesystem.h"

FileSystem::FileSystem(QObject *parent) : QFileSystemModel(parent)
{
    //setFilter(QDir::NoDotAndDotDot | QDir::Files);

    m_roleNameMapping[NAME] = "name";

    setFilter(QDir::AllDirs | QDir::Files | QDir::NoDotAndDotDot);
}

QHash<int, QByteArray> FileSystem::roleNames() const
{
    return m_roleNameMapping;
}
