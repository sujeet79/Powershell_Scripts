
$source="C:\PvcsInput\new" #location of directory to search
$strings="Validation_Output.txt"

cd ($source); get-childitem -Include ($strings) -Recurse -force | Remove-Item -Force –Recurse