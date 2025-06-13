$example_file = "$env:CUTLASS_DIR/examples/12_gemm_bias_relu/gemm_bias_relu.cu"
$output_file = "bin/$($example_file | Split-Path -LeafBase)"
$output_dir = $output_file | Split-Path -Parent
Write-Host "Compiling '$example_file' into: $output_file"
if (-not (Test-Path $output_dir)) {
    New-Item $output_dir -ItemType Directory
}
nvcc `
    -I"$env:CUTLASS_DIR/include" `
    -I"$env:CUTLASS_DIR/examples/common" `
    -I"$env:CUTLASS_DIR/build/include" `
    -I"$env:CUTLASS_DIR/tools/util/include" `
    -isystem /usr/local/cuda/include `
    -isystem /usr/local/cuda/include/cccl `
    -arch=sm_120a `
    -D=NDEBUG `
    -g -G `
    -dopt=on `
    -restrict `
    -expt-relaxed-constexpr `
    -D__CUDA_NO_HALF_CONVERSIONS__ `
    -std=c++20 `
    -o $output_file `
    $example_file

if ($?) { # Runs the file if the compilation was successful.
    Write-Host "Running: $output_file"
    $env:CUDA_LAUNCH_BLOCKING=1
    . $output_file
}