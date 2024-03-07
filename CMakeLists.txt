cmake_minimum_required(VERSION 3.12)
project(ribbon-integ)

enable_testing()

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

if(USE_YUNIBASE)
    if(WIN32)
        set(YUNI_WITH_YUNIBASE c:/yunibase)
    else()
        set(YUNI_WITH_YUNIBASE /opt/yunibase)
    endif()
else()
    set(WITH_PREBOOT ${CMAKE_CURRENT_LIST_DIR}/dump.bin)
endif()

set(USE_FULL_BOOTSTRAP ON)

set(RIBBON_INTEG_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})

set(WITH_YUNI ${CMAKE_CURRENT_LIST_DIR}/yuni)
set(WITH_RUNTIME ${CMAKE_CURRENT_LIST_DIR}/yuniribbit-proto)

add_subdirectory(ribbon)
