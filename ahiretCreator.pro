QT += quick widgets opengl
CONFIG += c++latest

QML_IMPORT_NAME = OpenGLUnderQML
QML_IMPORT_MAJOR_VERSION = 1

QML_IMPORT_NAME = OpenGLCamera
QML_IMPORT_MAJOR_VERSION = 1

LIBS   += -lopengl32
LIBS   += -lglu32

win32: RC_ICONS += images/ahiret.ico
#RC_FILE = ahiret.rc
#ICON = resource/icon/font-awesome-qml.icns

INCLUDEPATH += C:\Qt\5.15.2\mingw81_64\include\
INCLUDEPATH += C:\Qt\5.15.2\msvc2019_64\include\

#LIBS += -L$$PWD/includes/lib/assimp-vc142-mt
#PRE_TARGETDEPS += $$PWD/includes/lib/assimp-vc142-mt.dll
#LIBS += "C:\Users\Alperen\OneDrive\PyQT5 Projects - OneDrive\ahiret_msvc2019\debug\assimp-vc142-mt.dll"

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        camera.cpp \
        filesystem.cpp \
        light.cpp \
        main.cpp \
        mesh.cpp \
        model.cpp \
        modeltexture.cpp \
        mytreemodel.cpp \
        openglitem.cpp \
        qml_camera.cpp \
        qml_generalData.cpp \
        qml_light.cpp \
        sandboxitemmodel.cpp \
        shader.cpp \
        stb_image.cpp \
        terrain.cpp

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
    ahiret.rc \
    cd.mtl \
    cd.obj \
    container.jpg \
    container2.png \
    images/left_menu_button2.svg \
    images/left_menu_button3.svg \
    images/left_menu_button4.svg \
    include/lib/assimp-vc142-mt.lib \
    includes/assimp/.editorconfig \
    includes/assimp/config.h.in \
    includes/lib/assimp-vc142-mt.lib \
    shaders/fragmentShader.txt \
    shaders/vertexShader.txt

HEADERS += \
    camera.h \
    filesystem.h \
    includes/assimp/BaseImporter.h \
    includes/assimp/Bitmap.h \
    includes/assimp/BlobIOSystem.h \
    includes/assimp/ByteSwapper.h \
    includes/assimp/Compiler/poppack1.h \
    includes/assimp/Compiler/pstdint.h \
    includes/assimp/Compiler/pushpack1.h \
    includes/assimp/CreateAnimMesh.h \
    includes/assimp/DefaultIOStream.h \
    includes/assimp/DefaultIOSystem.h \
    includes/assimp/DefaultLogger.hpp \
    includes/assimp/Defines.h \
    includes/assimp/Exceptional.h \
    includes/assimp/Exporter.hpp \
    includes/assimp/GenericProperty.h \
    includes/assimp/Hash.h \
    includes/assimp/IOStream.hpp \
    includes/assimp/IOStreamBuffer.h \
    includes/assimp/IOSystem.hpp \
    includes/assimp/Importer.hpp \
    includes/assimp/LineSplitter.h \
    includes/assimp/LogAux.h \
    includes/assimp/LogStream.hpp \
    includes/assimp/Logger.hpp \
    includes/assimp/Macros.h \
    includes/assimp/MathFunctions.h \
    includes/assimp/MemoryIOWrapper.h \
    includes/assimp/NullLogger.hpp \
    includes/assimp/ParsingUtils.h \
    includes/assimp/Profiler.h \
    includes/assimp/ProgressHandler.hpp \
    includes/assimp/RemoveComments.h \
    includes/assimp/SGSpatialSort.h \
    includes/assimp/SceneCombiner.h \
    includes/assimp/SkeletonMeshBuilder.h \
    includes/assimp/SmoothingGroups.h \
    includes/assimp/SmoothingGroups.inl \
    includes/assimp/SpatialSort.h \
    includes/assimp/StandardShapes.h \
    includes/assimp/StreamReader.h \
    includes/assimp/StreamWriter.h \
    includes/assimp/StringComparison.h \
    includes/assimp/StringUtils.h \
    includes/assimp/Subdivision.h \
    includes/assimp/TinyFormatter.h \
    includes/assimp/Vertex.h \
    includes/assimp/XMLTools.h \
    includes/assimp/ZipArchiveIOSystem.h \
    includes/assimp/aabb.h \
    includes/assimp/ai_assert.h \
    includes/assimp/anim.h \
    includes/assimp/camera.h \
    includes/assimp/cexport.h \
    includes/assimp/cfileio.h \
    includes/assimp/cimport.h \
    includes/assimp/color4.h \
    includes/assimp/color4.inl \
    includes/assimp/config.h \
    includes/assimp/defs.h \
    includes/assimp/fast_atof.h \
    includes/assimp/importerdesc.h \
    includes/assimp/irrXMLWrapper.h \
    includes/assimp/light.h \
    includes/assimp/material.h \
    includes/assimp/material.inl \
    includes/assimp/matrix3x3.h \
    includes/assimp/matrix3x3.inl \
    includes/assimp/matrix4x4.h \
    includes/assimp/matrix4x4.inl \
    includes/assimp/mesh.h \
    includes/assimp/metadata.h \
    includes/assimp/pbrmaterial.h \
    includes/assimp/port/AndroidJNI/AndroidJNIIOSystem.h \
    includes/assimp/postprocess.h \
    includes/assimp/qnan.h \
    includes/assimp/quaternion.h \
    includes/assimp/quaternion.inl \
    includes/assimp/scene.h \
    includes/assimp/texture.h \
    includes/assimp/types.h \
    includes/assimp/vector2.h \
    includes/assimp/vector2.inl \
    includes/assimp/vector3.h \
    includes/assimp/vector3.inl \
    includes/assimp/version.h \
    light.h \
    mesh.h \
    model.h \
    modeltexture.h \
    mytreemodel.h \
    openglitem.h \
    qml_camera.h \
    qml_generalData.h \
    qml_light.h \
    sandboxitemmodel.h \
    shader.h \
    stb_image.h \
    terrain.h

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/includes/lib/ -lassimp-vc142-mt
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/includes/lib/ -lassimp-vc142-mt
else:unix: LIBS += -L$$PWD/includes/lib/ -lassimp-vc142-mt

INCLUDEPATH += $$PWD/includes
DEPENDPATH += $$PWD/includes
