#include "sandboxitemmodel.h"

#include <QApplication>
#include <QStyle>
#include <QDir>
#include <QDebug>
#include <QDirIterator>

SandBoxItemModel::SandBoxItemModel(QObject *parent)
    :QStandardItemModel(parent)
{
    rootItem = this->invisibleRootItem();
    dirIcon = QIcon("qrc:/images/object_menu_folder");
    fileIcon = QIcon("qrc:/images/object_menu_folder");

    m_roleNameMapping[NAME] = "name";
}

SandBoxItemModel::~SandBoxItemModel()
{

}

QHash<int, QByteArray> SandBoxItemModel::roleNames() const
{
    return m_roleNameMapping;
}

void SandBoxItemModel::setSandBoxDetails(QString names)
{
    populateSandBoxes(names.split("\n"));
}

void SandBoxItemModel::populateSandBoxes(const QStringList &names)
{
    QString name;
    CustomStandardItem* parent;

    unsigned int fileIndex = 0;

    foreach (name, names) {
        if (mainDirectory && (++fileIndex > 1)) return; // nur erster Folder wird Main.

        if(!name.isEmpty())
        {
            name.remove("\r");
            parent = new CustomStandardItem(dirIcon, name);  //create the parent directory item
            parent->setAccessibleDescription(name);     //set actual path to item
            parent->setType("dir");
            if (!mainDirectory){
                rootItem->appendRow(parent);                //add the parent item to root item
                createDirectoryItem(name, parent);          //Iterate and populate the contents
            }else{
                createDirectoryItem(name, rootItem, true);          //Iterate and populate the contents
            }

        }
    }
}

void SandBoxItemModel::createDirectoryItem(QString dirName, QStandardItem *parentItem, bool forMainDirectory)
{
    QDir dir(dirName);
    QFileInfoList subFolders;
    QFileInfo folderName;
    CustomStandardItem* child;
    if (!forMainDirectory)
        subFolders = dir.entryInfoList(QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot);
    else
        subFolders = dir.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot);

    foreach (folderName, subFolders)
    {

        if(folderName.isFile())
        {
            child = new CustomStandardItem(fileIcon, folderName.fileName());
            child->setAccessibleDescription(folderName.filePath());
            child->setType("file");
            child->setEnabled(false);
        }
        else
        {
            child = new CustomStandardItem(dirIcon, folderName.fileName());
            child->setAccessibleDescription(folderName.filePath());
            child->setType("dir");
        }
        parentItem->appendRow(child);
        createDirectoryItem(folderName.filePath(), child);
    }
}
