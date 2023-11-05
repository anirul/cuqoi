# Sample application (should take a file as input and decode it.)

add_executable(encoder
    encoder.cpp
)

find_path(QOI_INCLUDE_DIRS "qoi.h")

target_include_directories(encoder
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/../include
        ${QOI_INCLUDE_DIRS}
)

target_link_libraries(encoder
    PUBLIC
        cuQoiLib
        absl::base
        absl::flags
        absl::flags_parse
)

set_property(TARGET encoder PROPERTY FOLDER "cuQoiSample")
