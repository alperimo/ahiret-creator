# Generated from openglunderqml.pro.

cmake_minimum_required(VERSION 3.14)
project(qtQuickEmpty LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if(NOT DEFINED INSTALL_EXAMPLESDIR)
  set(INSTALL_EXAMPLESDIR "examples")
endif()

set(INSTALL_EXAMPLEDIR "${INSTALL_EXAMPLESDIR}/qml")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS Qml)
find_package(Qt6 COMPONENTS Quick)

qt_add_executable(qtQuickEmpty
    main.cpp
    squircle.cpp squircle.h
)
set_target_properties(qtQuickEmpty PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)
target_link_libraries(qtQuickEmpty PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
)


# Resources:
set(qtQuickEmpty_resource_files
    "main.qml"
)

qt6_add_resources(qtQuickEmpty "qtQuickEmpty"
    PREFIX
        "/qtQuickEmpty"
    FILES
        ${qtQuickEmpty_resource_files}
)

install(TARGETS qtQuickEmpty
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)

set_target_properties(qtQuickEmpty PROPERTIES
    QT_QML_MODULE_VERSION 1.0
    QT_QML_MODULE_URI OpenGLUnderQML
)

qt6_qml_type_registration(qtQuickEmpty)
