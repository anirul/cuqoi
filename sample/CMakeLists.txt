# Sample application (should take a file as input and decode it.)

add_executable(encoder
    encoder.cpp
)

target_include_directories(encoder
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/../include
)

target_link_libraries(encoder
    PUBLIC
        cuQoiLib
        absl::base
        absl::flags
        absl::flags_parse
)

set_property(TARGET encoder PROPERTY FOLDER "cuQoiSample")
