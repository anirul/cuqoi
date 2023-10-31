#include "cuqoi.hpp"

#include <cassert>
#include <cuda_runtime.h>
#include <fstream>
#include <stdexcept>
#include <vector>

// This is the entry to the QOI byte decoding.
__global__ void DecryptQOIByte(
    int n, cuqoi::qoi_byte_storage_t* ptr, cuqoi::qoi_header_t header)
{
    int index = threadIdx.x;
    for (int i = 1; i < header.channels + 1; ++i)
    {
        if (header.channels == 3)
        {
            if (ptr[index - i].type !=
                cuqoi::qoi_type_t::QOI_OP_RGB)
            {
                ptr[index].valid = false;
            }
        }
        if (header.channels == 4)
        {
            if (ptr[index - i].type !=
                cuqoi::qoi_type_t::QOI_OP_RGBA)
            {
                ptr[index].valid = false;
            }
        }
    }
    if (!ptr[index].valid)
    {
        return;
    }
}

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
    file_buffer_.reserve(file_size);

    // Read the content of the file into the buffer
    if (!ifs.read(file_buffer_.data(), file_size))
    {
        throw std::runtime_error("Could not read file.");
    }
    // Check size (shouldn't happen).
    if (file_buffer_.size() != file_size)
    {
        throw std::runtime_error("Error in size.");
    }
    // Check the end of file.
    if (file_buffer_[file_size - 2] != 0x00 ||
        file_buffer_[file_size - 1] != 0x01)
    {
        throw std::runtime_error("No end, this should end by 0x00 && 0x01.");
    }

    OpenContent(file_buffer_.data(), file_size);
}

CuqoiImage::CuqoiImage(void* ptr, size_t size)
{
    throw std::runtime_error("Not implemented");
}

void CuqoiImage::OpenContent(void* ptr, size_t size)
{
    // Open the header_.
    if (QOI_HEADER_SIZE > size)
    {
        throw std::runtime_error("Invalid header (image is too small).");
    }
    // Get the header from the data.
    std::memcpy(&header_, ptr, QOI_HEADER_SIZE);
    if ((header_.magic[0] != 'q') || (header_.magic[1] != 'o') ||
        (header_.magic[2] != 'i') || (header_.magic[3] != 'f'))
    {
        throw std::runtime_error("Invalid header (invalid code).");
    }
    byte_size_ = size - (QOI_HEADER_SIZE + 2);
    if (byte_size_ <= 0)
    {
        throw std::runtime_error("Byte size shoulde be a valid number.");
    }
    // Allocate the CUDA memory.
    cudaMalloc(&cuda_storage_, byte_size_);
    // Copy the data to the CUDA memory.
    void* buffer = &file_buffer_[QOI_HEADER_SIZE];
    cudaMemcpy(&cuda_storage_, buffer, byte_size_, cudaMemcpyHostToDevice);
}

cuqoi::CuqoiImage::~CuqoiImage()
{
    if (cuda_storage_)
    {
        cudaFree(cuda_storage_);
    }
}

void CuqoiImage::Decrypt()
{
    DecryptQOIByte<<<1, byte_size_>>>(byte_size_, cuda_storage_, header_);
}

void CuqoiImage::Encrypt()
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