cmake_minimum_required(VERSION 3.21)

project(aaxview VERSION 0.2 LANGUAGES CXX)

include(GNUInstallDirs)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    LabsFolderListModel
    LabsSettings
    Qml
    QmlCore
    Quick
    QuickControls2
    QuickLayouts
    QuickVectorImage
)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(aaxview-bin
    src/main.cpp
)

qt_policy(SET QTP0004 NEW)

qt_add_qml_module(aaxview-bin
    URI aaxview
    VERSION 1.0
    DISCARD_QML_CONTENTS
    QML_FILES
        src/Main.qml
        src/TextSetting.qml
        src/DropdownSetting.qml
        src/SettingsWindow.qml
)

set(QT_QML_OUTPUT_DIRECTORY_XML ON) 
set_target_properties(aaxview-bin PROPERTIES
    QT_QML_WARN_ON_UNRESOLVABLE_BINDINGS ON
)

target_compile_features(aaxview-bin PRIVATE cxx_std_17)

target_link_libraries(aaxview-bin PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::LabsFolderListModel
    Qt6::Qml
    Qt6::QmlCore
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::QuickLayouts
    Qt6::QuickVectorImage
)

install(PROGRAMS $<TARGET_FILE:aaxview-bin>
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    RENAME aaxview
)

install(FILES aaxview.desktop
    DESTINATION ${CMAKE_INSTALL_DATADIR}/applications
)

install(FILES aaxview.svg
    DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps
)
