#ifndef SANDBOXITEMMODEL_H
#define SANDBOXITEMMODEL_H

#include <QStandardItemModel>
#include <QStandardItem>
#include <QDebug>



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
    void createDirectoryItem(QString dirName, QStandardItem *parentItem = NULL);



    Q_INVOKABLE QVariant datax(const QModelIndex &index) const{
        qDebug() << "from cpp datax called!!!";

        return QStandardItemModel::itemFromIndex(index)->text();
    }

    Q_INVOKABLE QVariant getName(const QModelIndex &index) const
    {
        return QStandardItemModel::itemFromIndex(index)->text();
    }

    /*Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override
    {
        qDebug() << "data called hocaaaa";
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
};

#endif // SANDBOXITEMMODEL_H
