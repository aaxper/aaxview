#!/bin/sh

cd "$(dirname "$0")"
rcc resources.qrc -o qrc_resources.cpp
g++ main.cpp qrc_resources.cpp \
  -std=c++17 \
  -I/usr/include/qt6 \
  -I/usr/include/qt6/QtCore \
  -I/usr/include/qt6/QtGui \
  -I/usr/include/qt6/QtQml \
  -I/usr/include/qt6/QtQuick \
  -lQt6Core \
  -lQt6Gui \
  -lQt6Qml \
  -lQt6Quick \
  -o aaxview
sudo install -m 755 aaxview /usr/local/bin/aaxview
rm qrc_resources.cpp
rm aaxview
