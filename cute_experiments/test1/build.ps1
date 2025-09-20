$cutlass_dir = "../../cutlass"
$example_file = "main.cu"
$output_file = "bin/$($example_file | Split-Path -LeafBase)"
$output_dir = $output_file | Split-Path -Parent
Write-Host "Compiling '$example_file' into: $output_file"
if (-not (Test-Path $output_dir)) {
    New-Item $output_dir -ItemType Directory
}
nvcc `
    -I"$cutlass_dir/include" `
    -I"$cutlass_dir/examples/common" `
    -I"$cutlass_dir/build/include" `
    -I"$cutlass_dir/tools/util/include" `
    -isystem /usr/local/cuda/include `
    -isystem /usr/local/cuda/include/cccl `
    -g -G `
    -arch=sm_120a `
    -std=c++17 `
    --expt-relaxed-constexpr `
    -o $output_file `
    $example_file

if ($?) { # Runs the file if the compilation was successful.
    Write-Host "Done Compiling: $output_file"
    Write-Host "Running: $output_file" && . $output_file
}