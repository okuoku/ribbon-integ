# 
# INPUTs:
#   HOST: cygwin-ltsc2022 | cygwin-win10desktop | native
#   NAME: name of build (original HOST)
#   PHASE: prepare | build | test
#

cmake_path(ABSOLUTE_PATH CMAKE_CURRENT_LIST_DIR OUTPUT_VARIABLE root0)
cmake_path(APPEND root0 ..)
cmake_path(NATIVE_PATH root0 NORMALIZE root)

if(NOT NAME)
    set(NAME ${HOST})
endif()

message(STATUS "root = ${root}")

if("${HOST}" STREQUAL cygwin-ltsc2022)
    set(docker_image
        ghcr.io/okuoku/yunibuild-cygwin-ltsc2022)
    set(docker_imagetype cygwin)
    set(docker_isolation --isolation process)
elseif("${HOST}" STREQUAL cygwin-win10desktop)
    set(docker_image
        ghcr.io/okuoku/yunibuild-cygwin-win10desktop)
    set(docker_imagetype cygwin)
    set(docker_isolation --isolation process)
else()
    set(docker_image)
endif()

if("${docker_imagetype}" STREQUAL cygwin)

endif()

function(nest_native)
    if("${docker_imagetype}" STREQUAL cygwin)
        message(STATUS "Running docker... ${docker_image}")
        execute_process(COMMAND
            docker run --rm ${docker_isolation} 
            -v ${root}:c:/root:rw
            ${docker_image}
            "c:\\cyg64\\bin\\bash" --login -c
            "cmake -DHOST=native -DNAME=${HOST} -DPHASE=${PHASE} -P /cygdrive/c/root/integ/integbuild.cmake"
            RESULT_VARIABLE rr
            )
        if(rr)
            message(FATAL_ERROR "Exec error ${rr}")
        endif()
    else()
        message(FATAL_ERROR "Unknown image type ${docker_imagetype}")
    endif()
endfunction()

set(builddir ${CMAKE_CURRENT_LIST_DIR}/${NAME})

if("${PHASE}" STREQUAL prepare)
    if(docker_image)
        message(STATUS "Pull ${docker_image}")
        execute_process(COMMAND
            docker pull ${docker_image}
            RESULT_VARIABLE rr)
        if(rr)
            message(FATAL_ERROR "Error on pull image ${rr}")
        endif()
    endif()
elseif("${PHASE}" STREQUAL build)
    if("${HOST}" STREQUAL native)
        message(STATUS "Configure... builddir: ${builddir}")
        execute_process(COMMAND
            cmake -G Ninja -S ${root} -B ${builddir}
            RESULT_VARIABLE rr
            )
        if(rr)
            message(FATAL_ERROR "Config error ${rr}")
        endif()
        message(STATUS "Build... builddir: ${builddir}")
        execute_process(COMMAND
            cmake --build ${builddir}
            RESULT_VARIABLE rr
            )
        if(rr)
            message(FATAL_ERROR "Config error ${rr}")
        endif()
    else()
        nest_native()
    endif()
elseif("${PHASE}" STREQUAL test)
    if("${HOST}" STREQUAL native)
        message(STATUS "Test... builddir: ${builddir}")
        execute_process(COMMAND
            ctest -j10 .
            WORKING_DIRECTORY ${builddir}
            RESULT_VARIABLE rr
            )
        if(rr)
            message(FATAL_ERROR "Test error ${rr}")
        endif()
    else()
        nest_native()
    endif()
else()
    message(FATAL_ERROR "Unknown phase ${PHASE}")
endif()
