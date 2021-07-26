#ifndef FILESYSTEM_H
#define FILESYSTEM_H

#include <QFileSystemModel>
#include <QObject>

#include <QDebug>

Q_DECLARE_METATYPE(QModelIndex)

enum ItemRoles {
    NAME = Qt::UserRole + 1,
    TYPE
};

enum Roles {
    FileSizeRole = Qt::UserRole + 1
};

class FileSystem : public QFileSystemModel
{
    Q_OBJECT
    Q_PROPERTY(QModelIndex rootPathIndex READ rootPathIndex CONSTANT)
    Q_PROPERTY(QString rootPathQml READ rootPathQml CONSTANT)

public:
    QModelIndex rootPathIndex() const{
        return index(rootPath());
    }

    QString rootPathQml() const{
        return rootPath();
    }

    Q_INVOKABLE QVariant datax(const QModelIndex &index, int role = -1) const
    {
        qDebug() << "lannn index: " << index;
        qDebug() << "return: " << QFileSystemModel::data(this->index(index.row(), 1, index.parent()), role);
        switch (role) {
        case FileSizeRole:
            return QFileSystemModel::data(this->index(index.row(), 1, index.parent()),
                                          Qt::DisplayRole);
        default:
            return QFileSystemModel::data(index, role);
        }
    }


public:
    explicit FileSystem(QObject *parent = nullptr);
};

#endif // FILESYSTEM_H
