# $example_file = "cutlass/examples/12_gemm_bias_relu/gemm_bias_relu.cu"
$example_file = "cutlass/examples/59_ampere_gather_scatter_conv/ampere_gather_scatter_conv.cu"
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
    -arch=native `
    -D=NDEBUG `
    -g -G `
    -restrict `
    -expt-relaxed-constexpr `
    -D__CUDA_NO_HALF_CONVERSIONS__ `
    -std=c++20 `
    -o $output_file `
    $example_file

if ($?) { # Runs the file if the compilation was successful.
    Write-Host "Running: $output_file"
    . $output_file
}