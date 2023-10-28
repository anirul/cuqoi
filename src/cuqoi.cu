#include "cuqoi.hpp"

#include <cassert>
#include <cuda_runtime.h>
#include <fstream>
#include <stdexcept>
#include <vector>

namespace cuqoi
{

CuqoiImage::CuqoiImage(const std::string& file_name)
{
    std::ifstream ifs(file_name, std::ios::binary);
    if (!ifs.is_open())
    {
        throw std::runtime_error("Could not open file");
    }

    // Determine the file's size
    ifs.seekg(0, std::ios::end);
    std::streamsize file_size = ifs.tellg();
    ifs.seekg(0, std::ios::beg);

    // Create a buffer to hold the file content; we use a vector of characters
    // for convenience
    std::vector<char> buffer(file_size);

    // Read the content of the file into the buffer
    if (!ifs.read(buffer.data(), file_size))
    {
        throw std::runtime_error("Could not read file.");
    }

    OpenContent(buffer.data(), file_size);
}

CuqoiImage::CuqoiImage(void* ptr, size_t size)
{
    throw std::runtime_error("Not implemented");
}

void CuqoiImage::OpenContent(void* ptr, size_t size)
{
    // Open the header_.
    if (header_size_ > size) 
    {
        throw std::runtime_error("Invalid header (image is too small).");
    }
    // Get the header from the data.
    std::memcpy(&header_, ptr, header_size_);
    if ((header_.magic[0] != 'q') || (header_.magic[1] != 'o') ||
        (header_.magic[2] != 'i') || (header_.magic[3] != 'f'))
    {
        throw std::runtime_error("Invalid header (invalid code).");
    }
    
    throw std::runtime_error("Not implemented");
}

cuqoi::CuqoiImage::~CuqoiImage()
{
    // TODO add a cuda free here?
}

void CuqoiImage::Decompress()
{
    throw std::runtime_error("Not implemented");
}

void CuqoiImage::Compress()
{
    throw std::runtime_error("Not implemented");
}

void* CuqoiImage::Data()
{
    throw std::runtime_error("Not implemented");
}

size_t CuqoiImage::Size() const
{
    throw std::runtime_error("Not implemented");
}

} // namespace cuqoi