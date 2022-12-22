$python_files = Get-ChildItem -Path .\qtecommerce\ -Recurse -Depth 3 -Include '*.py'

foreach ( $python_file in $python_files ){
    $parent_path = $python_file.Directory
    Rename-Item -Path $python_file -NewName "$parent_path\main.rb"

}

# Get-ChildItem -Path .\qtecommerce\ -Recurse -Depth 3 -Include '*.py' | foreach { Rename-Item -Path $_ -NewName "$($_.Directory)\main.rb" }