#include "filesystem.h"

FileSystem::FileSystem(QObject *parent) : QFileSystemModel(parent)
{
    //setFilter(QDir::NoDotAndDotDot | QDir::Files);
    setFilter(QDir::AllDirs | QDir::Files | QDir::NoDotAndDotDot);
}
