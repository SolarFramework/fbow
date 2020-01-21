## remove Qt dependencies
QT       -= core gui
CONFIG -= qt

#Add support for clang compiler
#QMAKE_CXX=clang

## global defintions : target lib name, version
INSTALLSUBDIR = thirdParties
TARGET = fbow
FRAMEWORK = fbowSolAR
VERSION=0.0.1

DEFINES += MYVERSION=$${VERSION}
DEFINES += TEMPLATE_LIBRARY
CONFIG += c++1z


CONFIG(debug,debug|release) {
    DEFINES += _DEBUG=1
    DEFINES += DEBUG=1
}

CONFIG(release,debug|release) {
    DEFINES += _NDEBUG=1
    DEFINES += NDEBUG=1
}

DEPENDENCIESCONFIG = shared recurse

#NOTE : CONFIG as staticlib or sharedlib, DEPENDENCIESCONFIG as staticlib or sharedlib, QMAKE_TARGET.arch and PROJECTDEPLOYDIR MUST BE DEFINED BEFORE templatelibconfig.pri inclusion
include ($$shell_quote($$shell_path($$(REMAKEN_RULES_ROOT)/qmake/templatelibconfig.pri)))  # Shell_quote & shell_path required for visual on windows

DEFINES += NOMINMAX

msvc {
DEFINES += FBOW_DSO_EXPORTS
}

SOURCES += \
    src/fbow.cpp \
    src/vocabulary_creator.cpp

HEADERS += \
    src/cpu.h \
    src/fbow.h \
    src/fbow_exports.h \
    src/vocabulary_creator.h

unix {
#
#   if buidling with clang
#	    QMAKE_CXX = clang++
#   	QMAKE_LINK= clang++
#
}

macx {
    DEFINES += _MACOS_TARGET_
    QMAKE_MAC_SDK= macosx
    QMAKE_CFLAGS += -mmacosx-version-min=10.7 -std=c11 #-x objective-c++
    QMAKE_CXXFLAGS += -mmacosx-version-min=10.7 -std=c11 -std=c++11 -fPIC#-x objective-c++
    QMAKE_LFLAGS += -mmacosx-version-min=10.7 -v -lstdc++
    LIBS += -lstdc++ -lc -lpthread
}

win32 {

    DEFINES += WIN64 UNICODE _UNICODE
    QMAKE_COMPILER_DEFINES += _WIN64
    QMAKE_CXXFLAGS += -wd4250 -wd4251 -wd4244 -wd4275
}
QMAKE_CXXFLAGS += -mavx -mmmx -msse -msse2 -msse3
DEFINES += USE_AVX USE_SSE USE_SSE2 USE_SSE3 USE_MMX

header.path  = $${PROJECTDEPLOYDIR}/interfaces/
header.files  = $$files($${PWD}/src/*.h*)

INSTALLS += header
