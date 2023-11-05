#pragma once

#include <glm/glm.hpp>
#include <string>
#include <vector>

namespace cuqoi
{

// From the QOI web site.
struct qoi_header_t
{
    char magic[4];           // magic bytes "qoif"
    std::uint32_t width;     // image width in pixels (BE)
    std::uint32_t height;    // image height in pixels (BE)
    std::uint8_t channels;   // 3 = RGB, 4 = RGBA
    std::uint8_t colorspace; // 0 = sRGB with linear alpha
                             // 1 = all channels linear
};

// Header size.
constexpr std::size_t QOI_HEADER_SIZE = sizeof(qoi_header_t);

// Type of QOI byte.
enum class qoi_type_t : unsigned char
{
    QOI_OP_RGB   = 0b11111110, // OP || R || G || B
    QOI_OP_RGBA  = 0b11111111, // OP || R || G || B || A
    QOI_OP_INDEX = 0b00000000, // OP | index
    QOI_OP_DIFF  = 0b01000000, // OP | dr | dg | db
    QOI_OP_LUMA  = 0b10000000, // OP | dg || dr - dg | db - dg
    QOI_OP_RUN   = 0b11000000, // OP | run
};

// QOI byte GPU data.
struct qoi_byte_storage_t
{
    int pos = -1;           // Position in the image.
    int repeat = 0;         // Is it repeated?
    std::int8_t color[4];   // Color.
    qoi_type_t type;        // What it the underlying type?
    bool valid = true;      // Is this bit valid?
};

// class CuqoiImage
// This is a wrapper around the image data, it can be initialized from a file or
// from a pointer to the data.
class CuqoiImage
{
  public:
    CuqoiImage(const std::string& file_name);
    CuqoiImage(void* ptr, size_t size);
    void Decrypt();
    void Encrypt();
    void* Data();
    size_t Size() const;
    virtual ~CuqoiImage();

  protected:
    // File header.
    qoi_header_t header_;
    qoi_byte_storage_t* cuda_storage_ = nullptr;
    std::vector<char> file_buffer_;
    std::size_t byte_size_ = 0;

  private:
    void OpenContent(void* ptr, size_t size);
};

} // namespace cuqoi
