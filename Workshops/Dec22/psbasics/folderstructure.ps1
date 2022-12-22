$root_dir = New-Item -ItemType Directory -Path 'qtecommerce'
$src_dir = New-Item -ItemType Directory -Path "$root_dir\src"
$test_dir = New-Item -ItemType Directory -Path "$root_dir\test"
New-Item -ItemType File -Path "${src_dir}\main.py"
New-Item -ItemType File -Path "${test_dir}\main.py"
Write-Host "The tree structure"
tree /f $root_dir