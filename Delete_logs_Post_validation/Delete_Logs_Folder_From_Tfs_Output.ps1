
$source="C:\TfsOutput" #location of directory to search
$strings=@("logs")

cd ($source); get-childitem -Include ($strings) -Recurse -force | Remove-Item -Force –Recurse