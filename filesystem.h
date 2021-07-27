#ifndef FILESYSTEM_H
#define FILESYSTEM_H

#include <QFileSystemModel>
#include <QObject>

#include <QDebug>

Q_DECLARE_METATYPE(QModelIndex)


class FileSystem : public QFileSystemModel
{
    Q_OBJECT
    Q_PROPERTY(QModelIndex rootPathIndex READ rootPathIndex CONSTANT)
    Q_PROPERTY(QString rootPathQml READ rootPathQml CONSTANT)

public:

    enum ItemRoles {
        NAME = Qt::UserRole + 1,
        TYPE
    };

    explicit FileSystem(QObject *parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;

    QModelIndex rootPathIndex() const{
        return index(rootPath());
    }

    QString rootPathQml() const{
        return rootPath();
    }

private:
    QHash<int, QByteArray> m_roleNameMapping;
};

#endif // FILESYSTEM_H
