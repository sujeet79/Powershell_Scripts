#SUJEET#

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force

#Set-ExecutionPolicy Unrestricted
#Set-ExecutionPolicy remotesigned


##********* USER INPUT ROOT TFS FOLDER NAME PROVIDED BY CLIENT **************##
#$clientCIroot = Read-Host -Prompt 'Input ROOT TFS Folder Name'


##********* USER INPUT TFS FOLDER NAME PROVIDED BY CLIENT **************##
$clientCI = Read-Host -Prompt 'Input TFS Folder Name for Version Folders '



########## Get Start Time ##########
$startDTM = (Get-Date)

########## SOURCE PATH ###########
#$source = "\\css-svc-nas-07.services.tzghosting.net\fixrepository\WMK_TFS_Migration\powershell_sujeet\Source_PVCS" 
$source = "C:\PvcsInput"

########## TARGET PATH ###########
#$Folder = "\\css-svc-nas-07.services.tzghosting.net\fixrepository\WMK_TFS_Migration\powershell_sujeet\Target_TFS" 
$Folder = "C:\TfsOutput"

#$CI = Read-Host -Prompt 'Input CI Name '

function append-TFS { 
  process{
   foreach-object { 
   
   $dstSql = "$Folder\$content\$_\Database"
    $dstsFiles = "$Folder\$content\$_\FileSystem"
    $dotnet = "$Folder\$content\$_"

###############################################################################################################################



#*************** Documentation STARTS ********************#
#*************** Documentation STARTS ********************#
$srcdoc = "$source\$content\$_"
#Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Documentation" }  | New-Item -Type dir "$dotnet\Documentation"
Copy-Item $source\$content\$_\*Documentation $dotnet\Documentation -Recurse -Container 
Copy-Item $source\$content\$_\*\*Documentation $dotnet\Documentation -Recurse -Container 
#robocopy $srcdoc\Documentation $dotnet\Documentation
 


#*************** CUSTOM STARTS ********************#
#*************** CUSTOM STARTS ********************#

########### ROLLBACK ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrDel*" -or $_.Name -like "*ScrRlb*" -or $_.Name -like "*ScrRol*" -or $_.Name -like "*ScrDrp*" -or $_.Name -like "*ScrCln*" -or $_.Name -like "*ScrRbk*" -and $_.Directory.Name -match "Custom" <#-and $_.Directory.Parent.Name -notmatch "Table"#>}  | New-Item -Type dir "$dstSql\Rollback Scripts\Custom"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrDel*" -or $_.Name -like "*ScrRlb*" -or $_.Name -like "*ScrRol*" -or $_.Name -like "*ScrDrp*" -or $_.Name -like "*ScrCln*" -or $_.Name -like "*ScrRbk*" -and $_.Directory.Name -match "Custom" <#-and $_.Directory.Parent.Name -notmatch "Table"#>}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Rollback Scripts\Custom" -include "*.sq*" }
 
 ############ UPDATE ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrUpd*" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Update Scripts\Custom"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrUpd*" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Update Scripts\Custom" -include "*.sq*" }
 
 ############ OTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrOts*" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir $dstSql\OTS\Custom
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrOts*" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\OTS\Custom -include "*.sq*" }
 
 ############ FUNCTIONS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.Directory.Name -match "Custom" -and $_.DirectoryName -match "Function" -and $_.DirectoryName -notmatch "facetsxc" -and $_.DirectoryName -notmatch "Table"}  | New-Item -Type dir "$dstSql\Functions\Custom"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.Directory.Name -match "Custom" -and $_.DirectoryName -match "Function" -and $_.DirectoryName -notmatch "facetsxc" -and $_.DirectoryName -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Functions\Custom" -include "*.sqp" }
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.DirectoryName -match "Custom" -and $_.Directory.Parent.Name -match "Stored Procedure"  -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Functions\Custom"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.DirectoryName -match "Custom" -and $_.Directory.Parent.Name -match "Stored Procedure"  -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "Table" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Functions\Custom" -include "*.sqp" }
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*wmkpf*" -and $_.Directory.Name -match "Custom" -and $_.Directory.Parent.Name -match "Stored Procedure" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Functions\Custom"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*wmkpf*" -and $_.Directory.Name -match "Custom" -and $_.Directory.Parent.Name -match "Stored Procedure" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item "$dstSql\Functions\Custom" -include "*.sq*" }
 
 ############ ALTER SCRIPTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrAlt*" -and $_.Directory.Name -match "Custom" -and $_.DirectoryName -notmatch "facetsxc" <#-and $_.Directory.parent.Name -notmatch "Table"#>}  | New-Item -Type dir "$dstSql\Alter Scripts\Custom"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrAlt*" -and $_.Directory.Name -match "Custom" -and $_.DirectoryName -notmatch "facetsxc" <#-and $_.Directory.parent.Name -notmatch "Table"#>}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Alter Scripts\Custom" -include "*.sq*" }
 
 ############ INSERT SCRIPTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrIns*" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Insert Scripts\Custom"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrIns*" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Insert Scripts\Custom" -include "*.sq*" }
 
 ############ SQT TABLE SCRIPTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqt" -and $_.Directory.parent.Name -match "Table" -and $_.Directory.Name -match "Custom"}  | New-Item -Type dir "$dstSql\Table Scripts\Custom"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqt" -and $_.Directory.parent.Name -match "Table" -and $_.Directory.Name -match "Custom"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\Custom" -include "*.sqt" }
  
 ############TABLE SCRIPTS##########
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -like "*ScrTbl*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Directory.Name -match "Custom" <#-and $_.Directory.Parent.Name -match "Table"#>}  | New-Item -Type dir "$dstSql\Table Scripts\Custom"
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -like "*ScrTbl*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Directory.Name -match "Custom" <#-and $_.Directory.Parent.Name -match "Table"#>}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\Custom" -include "*.sq*" }
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Directory.Name -match "Custom" -and $_.Directory.Parent.Name -match "Table"  -and $_.Directory.Parent.Name -notmatch "Stored Procedure"}  | New-Item -Type dir "$dstSql\Table Scripts\Custom"
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Directory.Name -match "Custom" -and $_.Directory.Parent.Name -match "Table"  -and $_.Directory.Parent.Name -notmatch "Stored Procedure"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\Custom" -include "*.sq*" }
 
 ############VIEWS##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -match "View" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir $dstSql\Views\Custom
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -match "View" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Views\Custom -include "*.sq*" }
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "View"}  | New-Item -Type dir $dstSql\Views
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "View"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Views -include "*.sql" }
 
 ############ INDEXES ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -match "Index" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir $dstSql\Indexes\Custom
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -match "Index" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Indexes\Custom -include "*.sq*" }
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrInx*" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir $dstSql\Indexes\Custom
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrInx*" -and $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Indexes\Custom -include "*.sq*" }
 

 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Index"}  | New-Item -Type dir $dstSql\Indexes
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Index"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Indexes -include "*.sql" }
 
 ############ TRIGGERS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -match "Trigger" }  | New-Item -Type dir $dstSql\Triggers\Custom
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Custom" -and $_.Directory.parent.Name -match "Trigger" }  | ForEach-Object { Copy-Item $_.fullname $dstSql\Triggers\Custom -include "*.sq*" }
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Trigger"}  | New-Item -Type dir $dstSql\Triggers
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Trigger"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Triggers -include "*.sql" }
 
 ############ STORED PROCEDURES ##########
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -notlike "*wmkpf*" -and $_.Directory.Name -match "Custom" -and $_.Directory.Parent.Name -match "Stored Procedure" -and $_.Directory.Parent.Name -notmatch "Table" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*"}  | New-Item -Type dir "$dstSql\Stored Procedures\Custom"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -notlike "*wmkpf*" -and $_.Directory.Name -match "Custom" -and $_.Directory.Parent.Name -match "Stored Procedure" -and $_.Directory.Parent.Name -notmatch "Table" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Stored Procedures\Custom" -include "*.sql" }
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Stored Procedure"}  | New-Item -Type dir "$dstSql\Stored Procedures"
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Stored Procedure"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Stored Procedures" -include "*.sql" }
 

#*************** CUSTOM ENDS ********************#
#*************** CUSTOM ENDS ********************#


###############################################################################################################################

#*************** STAGE STARTS ********************#
#*************** STAGE STARTS ********************#

 ############ ROLLBACK ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrDel*" -or $_.Name -like "*ScrRlb*" -or $_.Name -like "*ScrRol*" -or $_.Name -like "*ScrDrp*" -or $_.Name -like "*ScrCln*" -or $_.Name -like "*ScrRbk*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Rollback Scripts\Stage"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrDel*" -or $_.Name -like "*ScrRlb*" -or $_.Name -like "*ScrRol*" -or $_.Name -like "*ScrDrp*" -or $_.Name -like "*ScrCln*" -or $_.Name -like "*ScrRbk*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Rollback Scripts\Stage" -include "*.sq*" }
 
 ############ UPDATE ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrUpd*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Update Scripts\Stage"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrUpd*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Update Scripts\Stage" -include "*.sq*" }
 
 ############ OTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrOts*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir $dstSql\OTS\Stage
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrOts*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\OTS\Stage -include "*.sq*" }
 
 ############ FUNCTIONS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.Directory.Name -match "Stage" -and $_.DirectoryName -match "Function" -and $_.DirectoryName -notmatch "facetsxc" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Functions\Stage"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.Directory.Name -match "Stage" -and $_.DirectoryName -match "Function" -and $_.DirectoryName -notmatch "facetsxc" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Functions\Stage" -include "*.sqp" }
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp" -and  $_.DirectoryName -match "Stage" -and $_.Directory.Parent.Name -match "Stored Procedure"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "FacetsXC" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Functions\Stage"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp" -and  $_.DirectoryName -match "Stage" -and $_.Directory.Parent.Name -match "Stored Procedure"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Table" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Functions\Stage" -include "*.sqp" }
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*wmkpf*" -and $_.Directory.Name -match "Stage" -and $_.Directory.Parent.Name -match "Stored Procedure" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Functions\Stage"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*wmkpf*" -and $_.Directory.Name -match "Stage" -and $_.Directory.Parent.Name -match "Stored Procedure" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item "$dstSql\Functions\Stage" -include "*.sq*" }

 ############ ALTER SCRIPTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrAlt*" -and $_.Directory.Name -match "Stage" -and $_.DirectoryName -notmatch "facetsxc" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Alter Scripts\Stage"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrAlt*" -and $_.Directory.Name -match "Stage" -and $_.DirectoryName -notmatch "facetsxc" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Alter Scripts\Stage" -include "*.sq*" }
 
 ############ INSERT SCRIPTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrIns*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Insert Scripts\Stage"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrIns*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Insert Scripts\Stage" -include "*.sq*" }
 
 ############ SQT TABLE SCRIPTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqt" -and $_.Directory.parent.Name -match "Table" -and $_.Directory.Name -match "Stage"}  | New-Item -Type dir "$dstSql\Table Scripts\Stage"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqt" -and $_.Directory.parent.Name -match "Table" -and $_.Directory.Name -match "Stage"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\Stage" -include "*.sqt" }
  
 ############TABLE SCRIPTS##########
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -like "*ScrTbl*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Table"}  | New-Item -Type dir "$dstSql\Table Scripts\Stage"
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -like "*ScrTbl*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\Stage" -include "*.sq*" }
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Table"}  | New-Item -Type dir "$dstSql\Table Scripts\Stage"
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Table"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\Stage" -include "*.sq*" }
 
 ############VIEWS##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "View" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir $dstSql\Views\Stage
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "View" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Views\Stage -include "*.sq*" }
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "View"}  | New-Item -Type dir $dstSql\Views
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "View"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Views -include "*.sql" }
 
 ############ INDEXES ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Index" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir $dstSql\Indexes\Stage
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Index" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Indexes\Stage -include "*.sq*" }
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrInx*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir $dstSql\Indexes\Stage
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrInx*" -and $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Indexes\Stage -include "*.sq*" }
 

 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Index"}  | New-Item -Type dir $dstSql\Indexes
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Index"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Indexes -include "*.sql" }
 
 ############ TRIGGERS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Trigger" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir $dstSql\Triggers\Stage
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Trigger" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Triggers\Stage -include "*.sq*" }
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Trigger"}  | New-Item -Type dir $dstSql\Triggers
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Trigger"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Triggers -include "*.sql" }
 
 ############ STORED PROCEDURES ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -notlike "*wmkpf*" -and  $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Stored Procedure" -and $_.Directory.parent.Name -notmatch "Table" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*"}  | New-Item -Type dir "$dstSql\Stored Procedures\Stage"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -notlike "*wmkpf*" -and  $_.Directory.Name -match "Stage" -and $_.Directory.parent.Name -match "Stored Procedure" -and $_.Directory.parent.Name -notmatch "Table" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Stored Procedures\Stage" -include "*.sql" }
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Stored Procedure"}  | New-Item -Type dir "$dstSql\Stored Procedures"
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Stored Procedure"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Stored Procedures" -include "*.sql" }

#*************** STAGE ENDS ********************#
#*************** STAGE ENDS ********************#

###############################################################################################################################

#*************** FACETS STARTS ********************#
#*************** FACETS STARTS ********************#

############ ROLLBACK ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrDel*" -or $_.Name -like "*ScrRlb*" -or $_.Name -like "*ScrRol*" -or $_.Name -like "*ScrDrp*" -or $_.Name -like "*ScrCln*" -or $_.Name -like "*ScrRbk*" -and $_.DirectoryName -match "Facet" -and $_.Directory.Name -notmatch "Rollback Script" -and $_.Directory.Name -notmatch "Custom" -and $_.Directory.Name -notmatch "_Facets" -and $_.Directory.Name -notmatch "Stage" -and $_.Directory.Name -notmatch "FacetsXC"}  | New-Item -Type dir "$dstSql\Rollback Scripts\Core"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrDel*" -or $_.Name -like "*ScrRlb*" -or $_.Name -like "*ScrRol*" -or $_.Name -like "*ScrDrp*" -or $_.Name -like "*ScrCln*" -or $_.Name -like "*ScrRbk*" -and $_.DirectoryName -match "Facet" -and $_.Directory.Name -notmatch "Rollback Script" -and $_.Directory.Name -notmatch "Custom" -and $_.Directory.Name -notmatch "_Facets" -and $_.Directory.Name -notmatch "Stage" -and $_.Directory.Name -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Rollback Scripts\Core" -include "*.sq*" }
 
 ############ UPDATE ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrUpd*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir "$dstSql\Update Scripts\Facets"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrUpd*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Update Scripts\Facets" -include "*.sq*" }
 
 ############ OTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrOts*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir $dstSql\OTS\Core
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrOts*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\OTS\Core -include "*.sq*" }
 
 ############ FUNCTIONS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -match "Function"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir "$dstSql\Functions\Core"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -match "Function"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Functions\Core" -include "*.sqp" }

 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp" -and  $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "Stored Procedure"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir "$dstSql\Functions\Core"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp" -and  $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "Stored Procedure"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Functions\Core" -include "*.sqp" }
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*wmkpf*" -and $_.Directory.Name -match "Facet" -and $_.Directory.Parent.Name -match "Stored Procedure" -and $_.Directory.parent.Name -notmatch "Table"}  | New-Item -Type dir "$dstSql\Functions\Core"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*wmkpf*" -and $_.Directory.Name -match "Facet" -and $_.Directory.Parent.Name -match "Stored Procedure" -and $_.Directory.parent.Name -notmatch "Table"}  | ForEach-Object { Copy-Item "$dstSql\Functions\Core" -include "*.sq*" } 

 ############ ALTER SCRIPTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrAlt*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir "$dstSql\Alter Scripts\Core"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrAlt*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Alter Scripts\Core" -include "*.sq*" }
 
 ############ INSERT SCRIPTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrIns*" -and $_.DirectoryName -match "Facet"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir "$dstSql\Insert Scripts\Core"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrIns*" -and $_.DirectoryName -match "Facet"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Insert Scripts\Core" -include "*.sq*" }
 
 ############ SQT TABLE SCRIPTS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqt" -and $_.DirectoryName -match "Table" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir "$dstSql\Table Scripts\Core"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqt" -and $_.DirectoryName -match "Table" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\Core" -include "*.sqt" }
  
 ############TABLE SCRIPTS##########
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -like "*ScrTbl*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -match "Table"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir "$dstSql\Table Scripts\Core"
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -like "*ScrTbl*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -match "Table" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\Core" -include "*.sq*" }
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -match "Table"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir "$dstSql\Table Scripts\Facets"
 Get-ChildItem $source\$content\$_  -Recurse  | Where-Object { $_.Name -notlike "*ScrDel*" -and $_.Name -notlike "*ScrIns*" -and $_.Name -notlike "*ScrUpd*" -and $_.Name -notlike "*ScrOts*" -and $_.Name -notlike "*ScrAlt*" -and $_.Name -notlike "*ScrRol*" -and $_.Name -notlike "*ScrDrp*" -and $_.Name -notlike "*ScrCln*" -and $_.Name -notlike "*ScrRbk*" -and $_.DirectoryName -match "Facet" -and $_.DirectoryName -match "Table"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\Facets" -include "*.sq*" }
 
 ############VIEWS##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "View"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir $dstSql\Views\Core
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "View" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Views\Core -include "*.sq*" }
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "View"}  | New-Item -Type dir $dstSql\Views
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "View"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Views -include "*.sql" }
 
 ############ INDEXES ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "Index" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir $dstSql\Indexes\Core
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "Index" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Indexes\Core -include "*.sq*" }
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrInx*" -and $_.Directory.Name -match "Facet" -and $_.Directory.parent.Name -notmatch "Table" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir $dstSql\Indexes\Core
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Name -like "*ScrInx*" -and $_.Directory.Name -match "Facet" -and $_.Directory.parent.Name -notmatch "Table" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Indexes\Core -include "*.sq*" }
 

 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Index"}  | New-Item -Type dir $dstSql\Indexes
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Index"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Indexes -include "*.sql" }
 
 ############ TRIGGERS ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "Trigger" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | New-Item -Type dir $dstSql\Triggers\Core
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "Trigger" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Triggers\Core -include "*.sq*" }
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Trigger"}  | New-Item -Type dir $dstSql\Triggers
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Trigger"}  | ForEach-Object { Copy-Item $_.fullname $dstSql\Triggers -include "*.sql" }
 
 ############ STORED PROCEDURES ##########
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object {$_.Name -notlike "*wmkpf*" -and $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "Stored Procedure"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" }  | New-Item -Type dir "$dstSql\Stored Procedures\Core"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object {$_.Name -notlike "*wmkpf*" -and $_.DirectoryName -match "Facet" -and $_.Directory.Parent.Name -match "Stored Procedure"  -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" }  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Stored Procedures\Core" -include "*.sql" }
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Stored Procedure"}  | New-Item -Type dir "$dstSql\Stored Procedures"
 #Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "Stored Procedure"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Stored Procedures" -include "*.sql" }

#*************** FACETS ENDS ********************#
#*************** FACETS ENDS ********************#

###############################################################################################################################


#*************** FacetsXC ********************#
#*************** FacetsXC ********************#
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "FacetsXC" -and $_.Directory.parent.Name -notmatch "Table"} | New-Item -Type dir $dstSql\FacetsXC
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "FacetsXC" -and $_.Directory.parent.Name -notmatch "Table"} | ForEach-Object { Copy-Item $_.fullname $dstSql\FacetsXC -include "*.sq*" }
 

#*************** FacetsXC TABLE SCRIPT ********************#
#*************** FacetsXC TABLE SCRIPT ********************#
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "FacetsXC" -and $_.Directory.parent.Name -match "Table"} | New-Item -Type dir "$dstSql\Table Scripts\FacetsXC"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.DirectoryName -match "FacetsXC" -and $_.Directory.parent.Name -match "Table"} | ForEach-Object { Copy-Item $_.fullname "$dstSql\Table Scripts\FacetsXC" -include "*.sql","*.sqt" }

#*************** FacetsXC FUNCTIONS ********************#
#*************** FacetsXC FUNCTIONS ********************#
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.DirectoryName -match "Function" -and $_.DirectoryName -match "FacetsXC"}  | New-Item -Type dir "$dstSql\Functions\FacetsXC"
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqp"  -and $_.DirectoryName -match "Function"}  | ForEach-Object { Copy-Item $_.fullname "$dstSql\Functions\FacetsXC" -include "*.sqp" }
 

#*************** SQT  FILES ********************#
#*************** SQT  FILES ********************#
# Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqt" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC" -and $_.DirectoryName  }  | New-Item -Type dir $dstsFiles\Scripts
#Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sqt" -and $_.DirectoryName -notmatch "Custom" -and $_.DirectoryName -notmatch "Stage" -and $_.DirectoryName -notmatch "FacetsXC" }  | ForEach-Object { Copy-Item $_.fullname "$dstsFiles\Scripts" -include "*.sqt" }
 
   
#*************** FMT FORMAT FILES ********************#
#*************** FMT FORMAT FILES ********************#
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".fmt"  -or $_.DirectoryName -match "Format files"}  | New-Item -Type dir $dstsFiles\Formatfiles
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".fmt"  -or $_.DirectoryName -match "Format files"}  | ForEach-Object { Copy-Item $_.fullname $dstsFiles\Formatfiles -include "*.fmt" }

 
#*************** DLL, SLN DOTNET FILES ********************#
#*************** DLL, SLN DOTNET FILES ********************#
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".dll" }  | New-Item -Type dir $dotnet\Dotnet
 #Get-ChildItem -Path $source -Recurse -Include *.dll | Copy-Item -Destination $dotnet\Dotnet
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".dll" }  | ForEach-Object { Copy-Item $_.fullname "$dotnet\Dotnet" -include "*.dll" }
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sln" }  | New-Item -Type dir $dotnet\Dotnet
 #Get-ChildItem -Path $source -Recurse -Include *.sln| Copy-Item -Destination $dotnet\Dotnet
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".sln" }  | ForEach-Object { Copy-Item $_.fullname "$dotnet\Dotnet" -include "*.sln" }
 

#*************** XML ********************#
#*************** XML ********************#
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".xml" }  | New-Item -Type dir $dstsFiles\Runfiles
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".xml" }  | ForEach-Object { Copy-Item $_.fullname $dstsFiles\Runfiles -include "*.xml" }
 

#*************** VBS, DTSX, PLX, BAT Scripts *********************#
#*************** VBS, DTSX, PLX, BAT Scripts *********************#
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".vbs" }  | New-Item -Type dir $dstsFiles\Scripts
 #Get-ChildItem -Path $source -Recurse -Include *.vbs | Copy-Item -Destination $dstsFiles\Scripts
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".vbs" }  | ForEach-Object { Copy-Item $_.fullname $dstsFiles\Scripts -include "*.vbs" }
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".dtsx" }  | New-Item -Type dir $dstsFiles\Scripts
 #Get-ChildItem -Path $source -Recurse -Include *.dtsx | Copy-Item -Destination $dstsFiles\Scripts
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".dtsx" }  | ForEach-Object { Copy-Item $_.fullname $dstsFiles\Scripts -include "*.dtsx" }
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".plx" }  | New-Item -Type dir $dstsFiles\Scripts
 #Get-ChildItem -Path $source -Recurse -Include *.plx | Copy-Item -Destination $dstsFiles\Scripts
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".plx" }  | ForEach-Object { Copy-Item $_.fullname $dstsFiles\Scripts -include "*.plx" }
 
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".bat" }  | New-Item -Type dir $dstsFiles\Scripts
 #Get-ChildItem -Path $source -Recurse -Include *.bat | Copy-Item -Destination $dstsFiles\Scripts
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".bat" }  | ForEach-Object { Copy-Item $_.fullname $dstsFiles\Scripts -include "*.bat" }


#*************** MSI ********************#
#*************** MSI ********************#
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".msi" }  | New-Item -Type dir $dstsFiles\Windows\MSI
 #Get-ChildItem -Path $source -Recurse -Include *.msi | Copy-Item -Destination $dstsFiles\Windows\MSI
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".msi" }  | ForEach-Object { Copy-Item $_.fullname $dstsFiles\Windows\MSI -include "*.msi" }
 

#*************** EXE ********************#
#*************** EXE ********************#
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".exe" }  | New-Item -Type dir $dstsFiles\Windows\EXE
 #Get-ChildItem -Path $source -Recurse -Include *.exe | Copy-Item -Destination $dstsFiles\Windows\EXE
 Get-ChildItem $source\$content\$_  -Recurse | Where-Object { $_.Extension -eq ".exe" }  | ForEach-Object { Copy-Item $_.fullname $dstsFiles\Windows\EXE -include "*.exe" }

#*************** LOG FILES .TXT ********************#
#*************** LOG FILES .TXT ********************#

Get-ChildItem -Path $source\$content\$_ -Recurse -Exclude *.xlsx,*.txt,*.complete,*.TGT,*.cs,*.csproj,*.user,*.xslt,*.zip -Attributes !Directory | Sort FullName | Select -ExpandProperty Name |  Out-File $source\$content\$_\Files_Logs.txt

#*************** Excluded FILES .TXT ********************#
#*************** Excluded FILES .TXT ********************#

Get-ChildItem -Path $source\$content\$_ -Recurse -Include *.xlsx,*.txt,*.complete,*.TGT,*.cs,*.csproj,*.user,*.xslt,*.zip -Attributes !Directory | Sort FullName | Select -ExpandProperty Name |  Out-File $Folder\$content\$_\logs\Excluded_files.txt



#remove-item $Folder\$_\WMK_501 -Force -Recurse -ErrorAction SilentlyContinue

#Rename-Item $Folder\$content\$_ $Folder\$content\"$content"_"$_"

#*************** LOGS FOLDER CREATION ********************#
#*************** LOGS FOLDER CREATION ********************#
New-Item -Type dir $Folder\$content\$_\logs 


#*************** Excluded FILES .TXT ********************#
#*************** Excluded FILES .TXT ********************#

Get-ChildItem -Path $source\$content\$_ -Recurse -Include *.xlsx,*.txt,*.complete,*.TGT,*.cs,*.csproj,*.user,*.xslt,*zip -Exclude "Files_Logs.txt" -Attributes !Directory | Sort FullName | Select -ExpandProperty Name |  Out-File $Folder\$content\$_\logs\Excluded_files.txt



#*************** COPIED FILES .TXT ********************#
#*************** COPIED FILES .TXT ********************#
Get-ChildItem -Path $Folder\$content\$_ -Recurse -Attributes -Exclude "Copied_Files_Logs.txt","Excluded_files.txt" !Directory | Sort FullName | Sort FullName | Select -ExpandProperty Name |  Out-File $Folder\$content\$_\logs\Copied_Files_Logs.txt



#*************** DIFFERENCES .TXT ********************#
#*************** DIFFERENCES .TXT ********************#
Compare-Object -referenceObject $(Get-Content $source\$content\$_\Files_Logs.txt) -differenceObject $(Get-Content $Folder\$content\$_\logs\Copied_Files_Logs.txt) | %{$_.Inputobject + $_.SideIndicator} | ft -auto | out-file $Folder\$content\$_\logs\Differences.txt 
#Compare-Object -referenceObject $(Get-Content $source\$content\$_\Files_Logs.txt) -differenceObject $(Get-Content $Folder\$content\$_\logs\Copied_Files_Logs.txt | Where {-not ($_.StartsWith("Number of files copied"))}) | %{$_.Inputobject + $_.SideIndicator} | ft -auto | out-file $Folder\$content\$_\logs\Differences.txt 


#*************** COUNT ********************#
#*************** COUNT ********************#

$countSource = Get-ChildItem -Path $source\$content\$_ -Recurse -Attributes !Directory -Exclude  *.txt | Measure-Object | %{$_.Count} 

Add-Content $Folder\$content\$_\logs\Differences.txt  "Total Number  of files at SOURCE = $countSource"

$countTarget = Get-ChildItem -Path $Folder\$content\$_ -Recurse -Attributes !Directory -Exclude  *.txt | Measure-Object | %{$_.Count} 

Add-Content $Folder\$content\$_\logs\Differences.txt  "Total Number  of files at TARGET = $countTarget"

$countExclude = Get-ChildItem -Path $source\$content\$_  -Include *.xlsx,*.txt,*.complete,*.TGT,*.cs,*.csproj,*.user,*.xslt,*.zip -Exclude "Files_Logs.txt"  -Recurse -Attributes !Directory  | Measure-Object | %{$_.Count}


Add-Content $Folder\$content\$_\logs\Differences.txt  "Total Number  of files Excluded = $countExclude"



#*************** Rename Folder ********************#
#*************** Rename Folder ********************#


$data = @($_)
$newData = $data | foreach {
 $array1 = $_.ToString().Split("_")
 $newArray1 = @()
 $i = ($array1.Count -2)
 $newArray1 += $array1[$i]
 $new_name1 = $newArray1 -join ""

 $array2 = $new_name1.ToString().Split(".")
 $newArray2 = @()
 $j = $array2[0]
 $k = $array2[1]
 $newArray2 = $j+"."+$k
 #$new_name2 = $newArray2 -join ""

 $new_name = $newArray2
 }
 $final_name = $clientCI+"_"+$new_name
Rename-Item $Folder\$content\$_ $Folder\$content\$final_name


################ FILE NAMES WITH TFS PATH ######################

#*************** Artifacts .TXT ********************#
#*************** Artifacts .TXT ********************#
Get-ChildItem -Path $Folder\$content\$final_name -Recurse -Attributes !Directory -Exclude  *.txt | Sort FullName | Select -ExpandProperty fullname | Out-File $Folder\$content\$final_name\logs\Artifacts.txt



$TextFile= "$Folder\$content\$final_name\logs"

$copiedfiles = Get-Content "$TextFile\Artifacts.txt"

function append-excel { 
  process{
   foreach-object {
                  $_.Replace(“C:\TfsOutput\$content”,"RITM000000|$/Wellmark_SI/FACETS") 
                  } }}

$copiedfiles | append-excel | Set-Content  "$TextFile\Artifacts.txt"


$copiedfiles1 = Get-Content "$TextFile\Artifacts.txt"

function append-excels { 
  process{
   foreach-object {
                  $_.Replace(“\”,"/") 
                  } }}

$copiedfiles1 | append-excels | Set-Content  "$TextFile\Artifacts.txt"

#################### ARTIFACT LIST EXCEL SHEET START ################################################################
<#
$Time = Get-Content "$TextFile\Artifacts.txt"

$Excel = New-Object -ComObject excel.application
$excel.visible = $False
$workbook = $excel.Workbooks.Add()
$diskSpacewksht= $workbook.Worksheets.Item(1)
$diskSpacewksht.Name = "Artifacts"
$diskSpacewksht.Cells.Item(1,1) = 'File Name'
$diskSpacewksht.Cells.Item(1,2) = 'Change-Set'
#$diskSpacewksht.Cells.Item(3,2) = 'Current'
#$diskSpacewksht.Cells.Item(3,3) = 'Volt'

#Write Data to Excel file
$col = 2
 foreach ($timeVal in $Time){
              $diskSpacewksht.Cells.Item($col,1) = $timeVal 
              $col++
              }

#Save Excel file

#excel.DisplayAlerts = 'False'
$ext=".xlsx"
$path= "$Folder\$content\$final_name\Artifacts$ext"
$workbook.SaveAs($path) 
$workbook.Close
$excel.DisplayAlerts = 'False'
$excel.Quit()
#>
#################### ARTIFACT LIST EXCEL SHEET END ################################################################

Remove-Item "$source\$content\$_\Files_Logs.txt"

Remove-Item "$Folder\$content\$final_name\logs\Artifacts.txt"

}}}


#$zipy = Get-ChildItem -Path $source | Where-Object { $_.Extension -eq ".zip"}

#function zip-unzip { 
 # process{
   #foreach-object { 
                  
#$fily = $_

 #if ( $content.Extension -eq ".zip" ){ 
 #$unzip = "$fily.Basename"
  
  #Expand-Archive -Path "$source\$fily" -DestinationPath "$source\$unzip"

  #}}}


 
#Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer} | Sort Name | Select -ExpandProperty Name | Out-File $Folder\CIs.txt
$contentPVCS = Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer }

 
#$unzip = Get-ChildItem $source  -Recurse | Where-Object { $_.Extension -eq ".zip" } | Sort basename | Select -ExpandProperty basename |  ForEach-Object {New-Item -Type dir "$source\$_"} | Start-Sleep -s 10
#Start-Sleep -s 10
#Get-ChildItem $source  -Recurse | Where-Object { $_.Extension -eq ".zip" }  |  ForEach-Object {Expand-Archive -Path "$source\$_" -DestinationPath "$unzip"}



function append-pvcs { 
  process{
   foreach-object { 
                  
$content = $_


#Get-ChildItem $source\*zip | Expand-Archive -DestinationPath $source\$content | Out-Null#
Get-ChildItem $source\$content\*zip | Expand-Archive -DestinationPath $source\$content
  
$contentTFS = Get-ChildItem -Path $source\$content | Where-Object {$_.PSIsContainer}

$contentTFS | append-TFS

$counttfs = Get-ChildItem -Path $Folder\$content | Where-Object {$_.PSIsContainer }| Measure-Object | %{$_.Count} 

Write-host $counttfs 

Rename-Item $Folder\$content $Folder\$clientCI


}}}




$contentPVCS | append-pvcs




#C:\script\TFS.ps1 2> C:\script\results.txt

#################### Get End Time ####################
$endDTM = (Get-Date)

####################  Echo Time elapsed ###################
"Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds"
