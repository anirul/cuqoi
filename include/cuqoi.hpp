#pragma once

#include <glm/glm.hpp>
#include <string>

namespace cuqoi
{

// class CuqoiImage
// This is a wrapper around the image data, it can be initialized from a file or
// from a pointer to the data.
class CuqoiImage
{
  public:
    CuqoiImage(const std::string& file_name);
    CuqoiImage(void* ptr, size_t size);
    void Decompress();
    void Compress();
    void* Data();
    size_t Size() const;
    virtual ~CuqoiImage();

  private:
    // From the QOI web site.
    struct qoi_header_
    {
        char magic[4];      // magic bytes "qoif"
        uint32_t width;     // image width in pixels (BE)
        uint32_t height;    // image height in pixels (BE)
        uint8_t channels;   // 3 = RGB, 4 = RGBA
        uint8_t colorspace; // 0 = sRGB with linear alpha
                            // 1 = all channels linear
    };
    // File header.
    qoi_header_ header_;
    const size_t header_size_ = sizeof(qoi_header_);
    void OpenContent(void* ptr, size_t size);
};

} // namespace cuqoi
