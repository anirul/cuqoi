# cuQoi lib
add_library(cuQoiLib
    STATIC
        cuQoi.cu
        ${CMAKE_CURRENT_SOURCE_DIR}/../include/cuqoi.hpp
)

target_include_directories(cuQoiLib
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/../include   
)

target_link_libraries(cuQoiLib
    PUBLIC
        glm::glm
)

set_property(TARGET cuQoiLib PROPERTY FOLDER "cuQoiLib")
