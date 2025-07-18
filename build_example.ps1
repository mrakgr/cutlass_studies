# $example_file = "cutlass/examples/12_gemm_bias_relu/gemm_bias_relu.cu"
# $example_file = "cutlass/examples/59_ampere_gather_scatter_conv/ampere_gather_scatter_conv.cu"
$example_file = "cutlass/examples/79_blackwell_geforce_gemm/79c_blackwell_geforce_mixed_mxfp8_mxfp6_bf16_gemm.cu"
$output_file = "bin/$($example_file | Split-Path -LeafBase)"
$output_dir = $output_file | Split-Path -Parent
Write-Host "Compiling '$example_file' into: $output_file"
if (-not (Test-Path $output_dir)) {
    New-Item $output_dir -ItemType Directory
}
nvcc `
    -I"cutlass/include" `
    -I"cutlass/examples/common" `
    -I"cutlass/build/include" `
    -I"cutlass/tools/util/include" `
    -isystem /usr/local/cuda/include `
    -isystem /usr/local/cuda/include/cccl `
    -g -G `
    -arch=sm_120a `
    -std=c++17 `
    --expt-relaxed-constexpr `
    -DCUTLASS_VERSIONS_GENERATED `
    -DNDEBUG `
    -Xcompiler=-fPIE `
    -DCUTLASS_ENABLE_TENSOR_CORE_MMA=1 `
    -DCUTLASS_ENABLE_GDC_FOR_SM100=1 `
    -ftemplate-backtrace-limit=0 `
    -DCUTLASS_TEST_LEVEL=0 `
    -DCUTLASS_TEST_ENABLE_CACHED_RESULTS=1 `
    -DCUTLASS_CONV_UNIT_TEST_RIGOROUS_SIZE_ENABLED=1 `
    -DCUTLASS_DEBUG_TRACE_LEVEL=0 `
    -Xcompiler=-Wconversion `
    -Xcompiler=-fno-strict-aliasing `
    -o $output_file `
    $example_file

if ($?) { # Runs the file if the compilation was successful.
    Write-Host "Done Compiling: $output_file"
    Write-Host "Running: $output_file" && . $output_file
}