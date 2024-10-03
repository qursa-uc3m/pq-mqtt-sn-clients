cmake_minimum_required(VERSION 3.16)
project(pq-mqtt-sn-clients VERSION 1.0.0 LANGUAGES C)

# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Define build types if not set
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Find wolfMQTT library
find_library(WOLFMQTT_LIBRARY wolfmqtt REQUIRED HINTS /usr/local/lib)
if(NOT WOLFMQTT_LIBRARY)
    message(FATAL_ERROR "wolfMQTT library not found. Please ensure it's installed correctly.")
endif()

# Find wolfMQTT headers
find_path(WOLFMQTT_INCLUDE_DIR wolfmqtt/mqtt_client.h
    PATHS /usr/local/include
    REQUIRED
)
if(NOT WOLFMQTT_INCLUDE_DIR)
    message(FATAL_ERROR "wolfMQTT headers not found. Please ensure they're installed correctly.")
endif()

# Find wolfSSL library
find_library(WOLFSSL_LIBRARY wolfssl REQUIRED HINTS /usr/local/lib)
if(NOT WOLFSSL_LIBRARY)
    message(FATAL_ERROR "wolfSSL library not found. Please ensure it's installed correctly.")
endif()

# Find wolfSSL headers
find_path(WOLFSSL_INCLUDE_DIR wolfssl/ssl.h
    PATHS /usr/local/include
    REQUIRED
)
if(NOT WOLFSSL_INCLUDE_DIR)
    message(FATAL_ERROR "wolfSSL headers not found. Please ensure they're installed correctly.")
endif()

# Include directories
include_directories(
    ${WOLFMQTT_INCLUDE_DIR}
    ${WOLFSSL_INCLUDE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/include/common
)

# Source files for snclient library
set(SN_CLIENT_SOURCES
    src/sn-client.c
    src/common/mqttexample.c
    src/common/mqttnet.c
    src/common/mqttport.c
)

# Add snclient library
add_library(snclient STATIC ${SN_CLIENT_SOURCES})

# Link snclient against wolfMQTT and wolfSSL
target_link_libraries(snclient PRIVATE ${WOLFMQTT_LIBRARY} ${WOLFSSL_LIBRARY})

# Include directories for snclient
target_include_directories(snclient PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/include/common
)

# Add sn-client executable
add_executable(sn-client src/sn-client.c)
target_link_libraries(sn-client PRIVATE snclient ${WOLFMQTT_LIBRARY} ${WOLFSSL_LIBRARY})

# Add sn-pub executable
add_executable(sn-pub src/sn-pub.c)
target_link_libraries(sn-pub PRIVATE snclient ${WOLFMQTT_LIBRARY} ${WOLFSSL_LIBRARY})

# Add sn-sub executable
add_executable(sn-sub src/sn-sub.c)
target_link_libraries(sn-sub PRIVATE snclient ${WOLFMQTT_LIBRARY} ${WOLFSSL_LIBRARY})

# Installation rules
include(GNUInstallDirs)

install(TARGETS snclient sn-client sn-pub sn-sub
        EXPORT snclient-targets
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(EXPORT snclient-targets
        FILE snclient-config.cmake
        NAMESPACE snclient::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/snclient
)

install(DIRECTORY include/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        FILES_MATCHING PATTERN "*.h"
)