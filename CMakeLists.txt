cmake_minimum_required(VERSION 3.16)
project(qt-wl-bridge CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)


if (DEFINED ENV{KBMON_DEV_PREFIX})
    string(REPLACE ":" ";" KBMON_DEV_PREFIX "$ENV{KBMON_DEV_PREFIX}")
    set(CMAKE_PREFIX_PATH ${KBMON_DEV_PREFIX})
    foreach(_p ${KBMON_DEV_PREFIX})
        list(APPEND CMAKE_INCLUDE_PATH ${_p}/usr/include/aarch64-linux-gnu)
        list(APPEND CMAKE_LIBRARY_PATH ${_p}/usr/lib/aarch64-linux-gnu)
    endforeach()
endif()

find_package(Qt6 COMPONENTS Gui REQUIRED)

add_library(qt-wl-bridge SHARED qt_wl_bridge.cpp)
target_link_libraries(qt-wl-bridge PRIVATE Qt6::Gui)


set_target_properties(qt-wl-bridge PROPERTIES
    BUILD_RPATH "$ORIGIN"
    INSTALL_RPATH "$ORIGIN"
)
