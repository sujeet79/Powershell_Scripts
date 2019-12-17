#--------------------------------------------------------------------------------------------------------------------------------------------------
$Folder= "C:\TfsOutput"




function append-consolidate1 { 
  process{
   foreach-object { 

   $validChild = $_
   $validTxt = "$Folder\$validRoot\$validChild\logs\Differences.txt"
   #$validTxtContent = Get-Content $validTxt

   [int]$logLen = (Get-Content $validTxt).Length
  

   If ($logLen -gt 3 )
     {
       $x = Get-Content "$Folder\$validRoot\Validation_List.txt"
       Write-Host "=======> $logLen"
       Write-Host "=======> $validChild"
       Set-Content "$Folder\$validRoot\Validation_List.txt" –value $x, $validChild
     }
     

        

}}}





$whichval = Get-ChildItem -Path $Folder  | Where-Object {$_.PSIsContainer }

function append-consolidate { 
  process{
   foreach-object { 

      $validRoot = $_

      out-file $Folder\$validRoot\Validation_List.txt

      
      Add-Content -Path "$Folder\$validRoot\Validation_List.txt" -Value "Validation Failed for below CI Version Folders! PLEASE CHECK "
      Add-Content -Path "$Folder\$validRoot\Validation_List.txt" -Value "-----------------------------------------------"
      Add-Content -Path "$Folder\$validRoot\Validation_List.txt" -Value " "

      $whichval1 = Get-ChildItem -Path $Folder\$validRoot | Where-Object {$_.PSIsContainer }
      
      ################----------------- CALLING (FUNCTION-1) ---------------------############################### 
      $whichval1 | append-consolidate1

   }}}

   $whichval | append-consolidate