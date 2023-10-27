# cuQoi tests.
add_executable(cuQoiTest
    main.cpp
    cuqoi_test.hpp
    cuqoi_test.cpp
)


target_include_directories(cuQoiTest
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/../include
)

target_link_libraries(cuQoiTest
    PUBLIC
        cuQoiLib
        GTest::gtest
)

set_property(TARGET cuQoiTest PROPERTY FOLDER "cuQoiTest")
