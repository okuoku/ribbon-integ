cmake_minimum_required(VERSION 3.12)
project(ribbon-integ)

enable_testing()

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

if(WITH_RIBBON_PREBOOT)
    set(USE_RIBBON_PREBOOT ON)
endif()

if(USE_YUNIBASE) # Full bootstrap
    if(WIN32)
        set(YUNI_WITH_YUNIBASE c:/yunibase)
    else()
        set(YUNI_WITH_YUNIBASE /opt/yunibase)
    endif()
    set(USE_FULL_BOOTSTRAP ON)
    message(STATUS "Ribbon full bootstrap")
elseif(NOT USE_RIBBON_PREBOOT) # Bootstrap using snapshot
    set(WITH_RIBBON_SNAPSHOT ${CMAKE_CURRENT_LIST_DIR}/_snapshot)
    set(USE_SNAPSHOT_BOOTSTRAP ON)
    message(STATUS "Ribbon snapshot bootstrap: ${WITH_RIBBON_SNAPSHOT}")
else() # No bootstrap (cross build etc.)
    if(NOT WITH_RIBBON_PREBOOT)
        set(WITH_RIBBON_PREBOOT ${CMAKE_CURRENT_LIST_DIR}/_snapshot/riboot.bin)
    endif()
    message(STATUS "Ribbon preboot: ${WITH_RIBBON_PREBOOT}")
endif()

set(RIBBON_INTEG_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})

set(WITH_YUNI ${CMAKE_CURRENT_LIST_DIR}/yuni)
set(WITH_RUNTIME ${CMAKE_CURRENT_LIST_DIR}/yuniribbit-proto)

add_subdirectory(ribbon)
