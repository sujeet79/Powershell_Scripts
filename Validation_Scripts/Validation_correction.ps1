##Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

$source = "C:\TFS\Wellmark_SI\Facets\WMK" #location of starting directory

$Folder = "C:\TFS\Wellmark_SI\Facets\WMK"  #location of Target directory
Out-File $Folder\Logs.txt

#$CI = Read-Host -Prompt 'Input CI Name'

$dstSql = "$Folder\$_\Database"

function append-upd { 
  process{
   foreach-object {
   $dstSql = "$source\$content\$content1"

##Facets to COre
   
     Get-ChildItem $source\$content\$content1 -Recurse -Filter Facets -Directory | Rename-Item -NewName { $_.name -replace 'Facets', 'Core'}


 ####CUSTOM
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -match "Stored Procedure" }  | New-Item -Type dir "$dstSql\Functions\Custom"
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -match "Stored Procedure" }  | ForEach-Object { Move-Item $_.fullname "$dstSql\Functions\Custom" -include "*.sqp" }
    
  #####Stage
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Stored Procedure" }  | New-Item -Type dir "$dstSql\Functions\Stage"
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Stored Procedure" }  | ForEach-Object { Move-Item $_.fullname "$dstSql\Functions\Stage" -include "*.sqp" }

  #####FacetsXC
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "FacetsXC" -and $_.Directory.parent.Name -match "Stored Procedure" }  | New-Item -Type dir "$dstSql\Functions\FacetsXC"
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "FacetsXC" -and $_.Directory.parent.Name -match "Stored Procedure"  }  | ForEach-Object { Move-Item $_.fullname "$dstSql\Functions\FacetsXC" -include "*.sqp" }

#####Facets
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "Facets" -and $_.Directory.Name -notmatch "FacetsXC" -and $_.Directory.parent.Name -match "Stored Procedure" }  | New-Item -Type dir "$dstSql\Functions\Core"
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "Facets" -and $_.Directory.Name -notmatch "FacetsXC" -and $_.Directory.parent.Name -match "Stored Procedure" }  | ForEach-Object { Move-Item $_.fullname "$dstSql\Functions\Core" -include "*.sqp" }
#####Core
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "Core" -and $_.Directory.parent.Name -match "Stored Procedure" }  | New-Item -Type dir "$dstSql\Functions\Core"
    Get-ChildItem $source\$content\$content1 -Recurse | Where-Object { $_.Extension -eq ".sqp" -and $_.Directory.Name -match "Core" -and $_.Directory.parent.Name -match "Stored Procedure" }  | ForEach-Object { Move-Item $_.fullname "$dstSql\Functions\Core" -include "*.sqp" }

###Rollback

#Get-ChildItem $source\$content\$content1  -Recurse | Where-Object { $_.Directory.Name -match "Facets" -and $_.Directory.parent.Name -match "Rollback Scripts" -and $_.Directory.Name -notmatch "Custom" -and $_.Directory.Name -notmatch "Stage" -and $_.Directory.Name -notmatch "FacetsXC" }  | ForEach-Object {Add-Content -Path "$Folder\Logs.txt" -Value $content}  | Get-Unique -OnType
#Get-ChildItem $source\$content\$content1  -Recurse | Where-Object {$_.Directory.Name -match "Core" -and $_.Directory.parent.Name -match "Rollback Scripts" -and $_.Directory.Name -notmatch "Custom" -and $_.Directory.Name -notmatch "Stage" -and $_.Directory.Name -notmatch "FacetsXC" }  |  ForEach-Object {Add-Content -Path "$Folder\Logs.txt" -Value $content}  | Get-Unique -OnType

#gc $Folder\Logs.txt | sort | get-unique > $Folder\CIs_with_Rollbacks.txt

   if($_ -match "Update"){
   
   [String]$var = "$content"
   #Add-Content -Path "$Folder\Logs.txt" -Value $var
   
   Rename-Item $source\$content\$content1\"Update" $source\$content\$content1\"Update Scripts"
   }
   }}}


function append-TFS { 
  process{
   foreach-object { 

   $content1 = $_
 
    if ($content1 -match "Database"){

   $upd = Get-ChildItem -Path $source\$content\$content1  | Where-Object {$_.PSIsContainer}

   $upd | append-upd
   
   
   
 }

 }}}




 
#Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer} | Sort Name | Select -ExpandProperty Name | Out-File $Folder\CIs.txt
$contentPVCS = Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer}


function append-pvcs { 
  process{
   foreach-object { 
                  
$content = $_


$contentTFS = Get-ChildItem -Path $source\$content | Where-Object {$_.PSIsContainer}

$contentTFS | append-TFS



}}}




$contentPVCS | append-pvcs




Remove-Item –path $Folder\Logs.txt 
