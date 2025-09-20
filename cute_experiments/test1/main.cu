#include <cuda_runtime.h>
#include <iostream>
#include <cstdio>

// Use Thrust to handle host/device allocations
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

// Cutlass includes
#include <cutlass/half.h>                       // F16 data type
#include <cutlass/util/print_error.hpp>
#include <cutlass/arch/barrier.h>
#include <cutlass/cluster_launch.hpp>

// CuTe includes
#include <cute/tensor.hpp>                      // CuTe tensor implementation
#include <cute/numeric/integral_constant.hpp>   // Compile time in constants such as _1, _256 etc.
#include <cute/algorithm/cooperative_copy.hpp>  // Auto vectorized copy operation

using namespace cute;

int main() {
    int device;
    cudaGetDevice(&device);

    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, device);

    int computeCapability = prop.major * 10 + prop.minor;
    std::cout << "Compute capability: " << computeCapability << std::endl;

    if (computeCapability == 120) {
        std::cout << "Nice." << std::endl;
        return 0;
    } else {
        std::cout << "The program requires a GPU with compute capability of 12.0" << std::endl;
        return -1;
    }
}
