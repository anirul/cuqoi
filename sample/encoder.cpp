#include "cuqoi.hpp"
#include "qoi.h"
#include <absl/flags/flag.h>
#include <absl/flags/parse.h>
#include <iostream>

ABSL_FLAG(std::string, in_file, "", "Input file to be QOIed.");
ABSL_FLAG(std::string, cpu_gpu, "cpu", "Decoding algorithm.");

int main(int ac, char** av)
try
{
    absl::ParseCommandLine(ac, av);
    if (absl::GetFlag(FLAGS_in_file).empty())
    {
        throw std::runtime_error("no input file specified");
    }
    if (absl::GetFlag(FLAGS_cpu_gpu) == "cpu")
    {
        qoi_desc desc{};
        void* ptr = qoi_read(absl::GetFlag(FLAGS_in_file).c_str(), &desc, 4);
        std::cout << "width x height : " << desc.width << " x " << desc.height
                  << "\n";
        std::cout << "color space    : " << desc.colorspace << "\n";
        std::cout << "channels       : " << desc.channels << "\n";
    }
    else if (absl::GetFlag(FLAGS_cpu_gpu) == "gpu")
    {
        throw std::runtime_error("not implemented yet!");        
    }
    else
    {
        throw std::runtime_error("option cpu_gpu no correct, valid options are "
                                 "\"cpu\" or \"gpu\".");
    }
    return 0;
}
catch (std::exception ex)
{
    std::cout << "Exception: " << ex.what() << std::endl;
    return -1;
}