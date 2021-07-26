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
    dirIcon = QApplication::style()->standardIcon(QStyle::SP_DirIcon);      //icon for directories
    fileIcon = QApplication::style()->standardIcon(QStyle::SP_FileIcon);    //icon for files

    m_roleNameMapping[NAME] = "name";
}

SandBoxItemModel::~SandBoxItemModel()
{

}

QHash<int, QByteArray> SandBoxItemModel::roleNames() const
{
    return m_roleNameMapping;
}

/*
 Sandbox locations are parsed from the file which are seperated by new lines.
*/
void SandBoxItemModel::setSandBoxDetails(QString names)
{
    qDebug() << "SandBoxItemModel, setSandBoxDetails, names = " << names;
    populateSandBoxes(names.split("\n"));
}

/*
 method to populate the contents of the sandboxes parsed from the file.
*/
void SandBoxItemModel::populateSandBoxes(const QStringList &names)
{
    QString name;
    QStandardItem* parent;

    foreach (name, names) {
        if(!name.isEmpty())
        {
            name.remove("\r");
            qDebug() << "SandBoxItemModel: path = " << name;
            parent = new QStandardItem(dirIcon, name);  //create the parent directory item
            parent->setAccessibleDescription(name);     //set actual path to item
            rootItem->appendRow(parent);                //add the parent item to root item

            createDirectoryItem(name, parent);          //Iterate and populate the contents
        }else{
            qDebug() << "SandBoxItemModel: path = " << name << " but this is empty";
        }
    }
}

/*
  Method to populate the contents of the given directory in recursive manner.
  Each found child will be appended to its parent item.
  Files & folders will be using its own standard icons  from current style.
  child->setAccessibleDescription() is used to set the actual path of the item
  which will be useful.

*/
void SandBoxItemModel::createDirectoryItem(QString dirName, QStandardItem *parentItem)
{
    QDir dir(dirName);
    QFileInfoList subFolders;
    QFileInfo folderName;
    QStandardItem* child;
    subFolders = dir.entryInfoList(QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot);    //get all the sub folders
    foreach (folderName, subFolders)
    {

        if(folderName.isFile())
        {
            qDebug() << "SandBoxItemModel: fileName = " << folderName.fileName();
            child = new QStandardItem(fileIcon, folderName.fileName());                 //Append a file
            child->setAccessibleDescription(folderName.filePath());                     //set actual path to item
        }
        else
        {
            qDebug() << "SandBoxItemModel: folderName = " << folderName.fileName();
            child = new QStandardItem(dirIcon, folderName.fileName());                  //Append a folder
            child->setAccessibleDescription(folderName.filePath());                     //set actual path to item
        }
        parentItem->appendRow(child);
        createDirectoryItem(folderName.filePath(), child);                              //Recurse its subdirectories
    }
}
