#include <iostream>
#include <absl/flags/flag.h>
#include <absl/flags/parse.h>
#include "cuqoi.hpp"

ABSL_FLAG(std::string, in_file, "", "Input file to be QOIed.");

int main(int ac, char** av) try 
{
    absl::ParseCommandLine(ac, av);
    if (absl::GetFlag(FLAGS_in_file).empty())
    {
        throw std::runtime_error("no input file specified");
    }
    return 0;
} 
catch (std::exception ex) 
{
    std::cout << "Exception: " << ex.what() << std::endl;
    return -1;
}