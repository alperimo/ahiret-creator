#ifndef SANDBOXITEMMODEL_H
#define SANDBOXITEMMODEL_H

#include <QStandardItemModel>
#include <QStandardItem>
#include <QDebug>

class CustomStandardItem : public QStandardItem
{
public:
    CustomStandardItem();
    CustomStandardItem(int rows, int columns = 1) : QStandardItem(rows, columns) {};
    CustomStandardItem(const QIcon &icon, const QString &text) : QStandardItem(icon, text) {};
    CustomStandardItem(const QString &text) : QStandardItem(text) {};
    ~CustomStandardItem(){};

    void setType(QString type_) {type = type_;}
    decltype (auto) getType() {return type;}

private:
    QString type;
};

class SandBoxItemModel : public QStandardItemModel
{
    Q_OBJECT
public:
    SandBoxItemModel(QObject* parent = 0);
    ~SandBoxItemModel();

    enum ItemRoles {
        NAME = Qt::DisplayRole
    };

    QHash<int, QByteArray> roleNames() const override;

    void setSandBoxDetails(QString names);
    void populateSandBoxes(const QStringList &names);
    void createDirectoryItem(QString dirName, QStandardItem *parentItem = NULL, bool forMainDirectory=false);

    Q_INVOKABLE QStandardItem* datax(const QModelIndex &index) const{
        qDebug() << "from cpp: datax called!!!";
        return QStandardItemModel::itemFromIndex(index);
    }

    Q_INVOKABLE QString getIconType(const QModelIndex &index) const
    {
        return dynamic_cast<CustomStandardItem*>(QStandardItemModel::itemFromIndex(index))->getType();
    }


    void setUseMainDirectory(bool flag){mainDirectory=flag;}

    /*Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override
    {
        switch (role) {
            //case NAME:
            //    return QFileSystemModel::data(this->index(index.row(), 1, index.parent()),
              //                                Qt::DisplayRole);
            default:
                return QStandardItemModel::data(index, role);
        }
    }*/

private:

    QHash<int, QByteArray> m_roleNameMapping;

    QStandardItem *rootItem;
    QIcon dirIcon;
    QIcon fileIcon;

    bool mainDirectory = false;
};

#endif // SANDBOXITEMMODEL_H
