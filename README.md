# cuqoi

Cuda version of QOI (Quite Ok Image) format. See [there](https://qoiformat.org/qoi-specification.pdf) for a full definition.

## Decoding

The idea is to decrypt this if possible in parallel.

- Parse the file (or at least the header) on CPU.
- Send the data to the GPU and header.
- Make a kernel either per fragment (byte).

The decrypting per fragment would work as follow.

### Get the first valid basis

Go back into the file to search for the first valid byte (b11111111 or b11111110) should not have to go back more than 4 bytes. Then check if the byte before is (b01) this would mean a double byte. If it is not found then this is a valid byte.

### Compute the size and output temporary result

The size can be computed by [the same way](https://github.com/anirul/OpenCL_Crash_Course) we do histogram. It could be computed int log2 time of the whole image.

```cpp
struct byte_storage_t {
    int type;           // What it the underlying type?
    int pos = -1;       // Position in the image.
    int repeat = 0;     // Is it repeated?
    glm::vec4 color;    // Color.
};
```

### Compute the final color

Complete the final color go back if needed and check the array for color (I m not sure this will ever work). Actually you could make it hold forever (or at least the length of the image) if you have a lot of increases. It may be possible to use the same technique than in histogram and divide this to a log2 battle once more.

### Put the final color

Just output the color at the designated position repeated if needed.
