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
    dirIcon = QIcon("qrc:/images/object_menu_folder"); //QApplication::style()->standardIcon(QStyle::SP_DirIcon);      //icon for directories
    fileIcon = QIcon("qrc:/images/object_menu_folder"); //QApplication::style()->standardIcon(QStyle::SP_FileIcon);    //icon for files

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
    CustomStandardItem* parent;

    unsigned int fileIndex = 0;

    foreach (name, names) {
        if (mainDirectory && (++fileIndex > 1)) return; // nur erster Folder wird Main.

        if(!name.isEmpty())
        {
            name.remove("\r");
            qDebug() << "SandBoxItemModel: path = " << name;
            parent = new CustomStandardItem(dirIcon, name);  //create the parent directory item
            parent->setAccessibleDescription(name);     //set actual path to item
            parent->setType("dir");
            if (!mainDirectory){
                rootItem->appendRow(parent);                //add the parent item to root item
                createDirectoryItem(name, parent);          //Iterate and populate the contents
            }else{
                createDirectoryItem(name, rootItem, true);          //Iterate and populate the contents
            }

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
void SandBoxItemModel::createDirectoryItem(QString dirName, QStandardItem *parentItem, bool forMainDirectory)
{
    QDir dir(dirName);
    QFileInfoList subFolders;
    QFileInfo folderName;
    CustomStandardItem* child;
    if (!forMainDirectory)
        subFolders = dir.entryInfoList(QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot);    //get all the sub folders
    else
        subFolders = dir.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot);

    foreach (folderName, subFolders)
    {

        if(folderName.isFile())
        {
            qDebug() << "SandBoxItemModel: fileName = " << folderName.fileName();
            child = new CustomStandardItem(fileIcon, folderName.fileName());                 //Append a file
            child->setAccessibleDescription(folderName.filePath());                     //set actual path to item
            child->setType("file");
            child->setEnabled(false);
        }
        else
        {
            qDebug() << "SandBoxItemModel: folderName = " << folderName.fileName();
            child = new CustomStandardItem(dirIcon, folderName.fileName());                  //Append a folder
            child->setAccessibleDescription(folderName.filePath());                     //set actual path to item
            child->setType("dir");
        }
        parentItem->appendRow(child);
        createDirectoryItem(folderName.filePath(), child);                              //Recurse its subdirectories
    }
}
