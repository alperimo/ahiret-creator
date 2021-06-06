QT += quick widgets
CONFIG += c++11

QML_IMPORT_NAME = OpenGLUnderQML
QML_IMPORT_MAJOR_VERSION = 1

LIBS   += -lopengl32
LIBS   += -lglu32

INCLUDEPATH += C:\Qt\5.15.2\mingw81_64\include\

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        camera.cpp \
        main.cpp \
        openglitem.cpp \
        shader.cpp \
        squircle.cpp

RESOURCES += \
            qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#DISTFILES += \
#    components/CustomBorder.qml

DISTFILES += \
    images/ediphocam.jpg \
    images/left_menu_button2.png \
    images/left_menu_button2.svg \
    images/left_menu_button3.svg \
    images/left_menu_button4.svg \
    shaders/fragmentShader.txt \
    shaders/vertexShader.txt

HEADERS += \
    camera.h \
    openglitem.h \
    shader.h \
    squircle.h
