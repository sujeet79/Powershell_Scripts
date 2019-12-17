$source = "C:\PvcsInput"














###################--------------------- (FUNCTION-2) STARTS ---------------------############################### 


 function CI-Folder { 
  process{
   foreach-object { 

       ###################--------------------- FILES_IN_CI_DOC.TXT ---------------------############################### 
       $out = out-file $target\Files_In_CI_Doc.txt
       $file = "$target\Files_In_CI_Doc.txt"

       ###################--------------------- PATH_IN_CI_DOC.TXT ---------------------############################### 
       $outPath = out-file $target\Path_In_CI_Doc.txt -Encoding ascii
       $filePath = "$target\Path_In_CI_Doc.txt"

       ###################--------------------- PATH_IN_CI_DOC.TXT ---------------------############################### 
        out-file $target\Path_Val_Output.txt   
        $path_log = "$target\Path_Val_Output.txt"



        ###################--------------------- READING THE Path_Of_Files_In_Folder--------------------###############################


        Get-ChildItem -Path "$source\$conOne\$content" -Recurse -Attributes !Directory -Exclude  *.txt | Sort FullName | Select -ExpandProperty fullname | Out-File $target\Path_In_Folder.txt
        $Path_In_Folder = "$target\Path_In_Folder.txt"
        $FilePathFolder =  Get-Content $target\Path_In_Folder.txt

        [string]$sourceString = "$source\$conOne"
        [string]$contentString = $content

         function Trim-Path { 
           process{
             foreach-object {
               
                $_.Replace("$sourceString\$contentString\","")          
          }}}
  
        $FilePathFolder | Trim-Path | Set-Content  "$target\Path_In_Folder.txt"
        
        $copiedfiles1 = Get-Content "$target\Path_In_Folder.txt"

          function append-path1 { 
            process{
              foreach-object {
                             $_.Replace(“\”,"/") 
               } }}

       $copiedfiles1 | append-path1  | Set-Content  "$target\Path_In_Folder.txt" 
                

               

       $CI = $_

       Write-Host "CI Document: $CI.doc"

       ###################--------------------- READING THE CI DOCUMENT---------------------###############################

       [string]$filename = "$source\$conOne\$content\Documentation\$CI.doc"
       $wd = New-Object -ComObject Word.Application
       $wd.Visible = $true
       $doc = $wd.Documents.Open($filename, $false, $true)


       
       #Add-Content -Path $file -Value "$CI.doc"

       foreach ($table in $doc.Tables)
       {
          [string]$colcount = $table.Cell(1,1).Range.Text
         
         
         if ($colcount -match "File Names")
           {
             [int]$countnum = $table.Rows.Count
             #$emptyrow = 0


             For ($i = 3; $i -le $table.Rows.Count; $i++)
          
                  { 
                   [string]$printToFileTextVersion = $table.Cell($i,2).Range.Text 

                    if("$printToFileTextVersion" -notmatch "RETIRED") 
                     {

                       [string]$printToFileText = $table.Cell($i,1).Range.Text 
                         
                        Add-Content -Path $file -Value "`n$printToFileText"

                        [string]$printToFileTextPath = $table.Cell($i,3).Range.Text 
                        [int]$rowLen = $printToFileTextPath.Length

                    

                         if($rowLen -gt 2){
                              if($printToFileText -like '*.doc' -or $printToFileText -like '*.docx'){
                                        $printToFileTextNew =  $printToFileText.subString(0,$printToFileText.length-2)
                                        $printToFileTextPathNew=  $printToFileTextPath.subString(0,$printToFileTextPath.length-3)
                                        Add-Content -Path $filePath -Value "`n$printToFileTextPathNew/$printToFileTextNew" -Encoding ascii
                                        }
                                else{ 
                                        $printToFileTextNew =  $printToFileText.subString(0,$printToFileText.length-2)
                                        $printToFileTextPathNew=  $printToFileTextPath.subString(0,$printToFileTextPath.length-2)
                                        Add-Content -Path $filePath -Value "`n$printToFileTextPathNew/$printToFileTextNew" -Encoding ascii
                          
                                     } 
                       } 
                     }
                  }



          $CIPath1 = Get-Content "$filePath"

          function CIPath { 
            process{
              foreach-object {
                             $_.Replace(“\”,"/") 
               } }}

       $CIPath1 | CIPath  | Set-Content  "$filePath" 
                
     }

  }
 
      $doc.Close()
      $wd.Quit()

        
           #========DELETE EMPTY LINES From File_Path_From_CI.TXT ==================

         $Newtext = (Get-Content -Path $filePath -Raw) -replace "(?s)`r`n\s*$"
         [system.io.file]::WriteAllText("$filePath",$Newtext)

         $Newtext = (Get-Content -Path $Path_In_Folder -Raw) -replace "(?s)`r`n\s*$"
         [system.io.file]::WriteAllText("$Path_In_Folder",$Newtext)

     
     
     
     ###################--------------------- Comparing FILES_IN_CI_DOC With FILES_IN_FOLDER ---------------------###############################


     
         $File1 =  Get-Content $file
         $File2 =  Get-Content $FileInFolder
         ForEach ($Line in $File1)
          {
               If ($File2 -contains $Line)
                 {
                  Write-Output "$Line is present in the Folder"

                  }
               If ($File2 -notcontains $Line)
                 {
                  Add-Content -Path $valLog  -Value $Line
                 }
          }

( Get-Content "$target\Validation_Output.txt" ) | Where { $_.Trim(" `t") } | Set-Content $target\Validation_Output.txt



     ###################--------------------- Comparing Path_In_CI_Doc  With  Path_In_FOLDER ---------------------###############################



         $File1path =  Get-Content $target\Path_In_CI_Doc.txt
         $File2path =  Get-Content $Path_In_Folder
         ForEach ($Line1 in $File1path)
          {
               If ($File2path -contains $Line1)
                 {
                  Write-Output "$Line1  File_Path IN CI DOC Matches Path IN FOLDER"

                  }
               If ($File2path -notcontains $Line1)
                 {
                     Add-Content -Path $path_log  -Value $Line1

                  }
           }





( Get-Content "$target\Path_Val_Output.txt" ) | Where { $_.Trim(" `t") } | Set-Content "$target\Path_Val_Output.txt"


###################--------------------- REMOVING UNICODE CHARS,EMPTY LINES FROM VALIDATION_OUTPUT FILE ---------------------###############################
          
     $reference1 = Get-Content $target\Validation_Output.txt

function append-UnicodeEdit{
  process{
   foreach-object { 

   $contentUni = $_
   [string]$UniVar = $contentUni
   [string]$UniReplaceVar = ""
   
   [int]$contentUniLen = $contentUni.length

   if($contentUniLen -le 2){
         #write-Host $contentUni.length
             $contentUni.Replace("$UniVar","$UniReplaceVar")
             }
   else {
          #write-Host $contentUni 
          $contentUni.Replace("$UniVar","$UniVar")
          #Add-Content -Path $target\Validation_Output.txt -Value $contentUni 
          }                    

}}}
$reference1 | append-UnicodeEdit | Set-Content $target\Validation_Output.txt


( Get-Content "$target\Validation_Output.txt" ) | Where { $_.Trim(" `t") } | Set-Content $target\Validation_Output.txt





}
}
}



###################--------------------- START POINT OF EXECUTION(Function-1)---------------------###############################



function append-TFS { 
  process{
   foreach-object { 

       $content = $_

       $target = "$source\$conOne\$content"
       ###################--------------------- FILES_IN_FOLDER.TXT ---------------------###############################
       Get-ChildItem -Path $source\$conOne\$content -Recurse  -Attributes !Directory | Sort FullName | Select -ExpandProperty Name |  Out-File $source\$conOne\$content\Files_In_Folder.txt
       $FileInFolder = "$source\$conOne\$content\Files_In_Folder.txt"


        ###################--------------------- CHECKING IF CI DOC IS PRESENT/NOT---------------------###############################

       #$directoryInfo = Get-ChildItem "$source\$conOne\$content\Documentation"  | Measure-Object
       $directoryInfo = Get-ChildItem "$source\$conOne\$content\Documentation" -Attributes !Directory
     
        
        if($directoryInfo.count -eq 0){  
           out-file $target\Validation_Output.txt   
           Add-Content -Path $target\Validation_Output.txt -Value "CI DOCUMENT NOT FOUND! PLEASE CHECK" 
           Write-Host  "CI DOCUMENT NOT FOUND! PLEASE CHECK"
           Write-Host  "CI DOCUMENT NOT FOUND! PLEASE CHECK"
           Write-Host  "CI DOCUMENT NOT FOUND! PLEASE CHECK"
           Write-Host  "CI DOCUMENT NOT FOUND! PLEASE CHECK"
           } 
         
        else{
              out-file $target\Validation_Output.txt
              
              $valLog = "$target\Validation_Output.txt"

              ###############-------------- CALLING (FUNCTION-2) ---------------------###########################
              $contentSource = Get-ChildItem -Path "$source\$conOne\$content" -Recurse -Include *.doc, *.docx  | Sort Name | Select -ExpandProperty BaseName
              $contentSource | CI-Folder
              }  
}}}



###################--------------------- START POINT OF EXECUTION(Function-0)---------------------###############################

$contentPVCS0 = Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer }

###################--------------------- (Function-0)---------------------###############################
function append-TFS0 { 
  process{
   foreach-object { 

      $conOne= $_
      $contentPVCS = Get-ChildItem -Path $source\$conOne | Where-Object {$_.PSIsContainer }
      
      ################----------------- CALLING (FUNCTION-1) ---------------------############################### 
      $contentPVCS | append-TFS

   }}}

   $contentPVCS0 | append-TFS0




function append-TFS1 { 
  process{
   foreach-object { 

       $contentfinal2 = $_

       $targetfinal = "$source\$confinal\$contentfinal2"



       #========DELETE EMPTY LINES==================

         $Newtext = (Get-Content -Path $targetfinal\Validation_Output.txt -Raw) -replace "(?s)`r`n\s*$"
         [system.io.file]::WriteAllText("$targetfinal\Validation_Output.txt",$Newtext)

         $Newtext = (Get-Content -Path $targetfinal\Path_Val_Output.txt -Raw) -replace "(?s)`r`n\s*$"
         [system.io.file]::WriteAllText("$targetfinal\Path_Val_Output.txt",$Newtext)




$TES = (Get-Content $targetfinal\Validation_Output.txt).Length
 
  ################----------------- SUCCESS! IF ALL FILES IN CI DOC ARE PRESENT IN FOLDER ---------------------############################### 

   If ($TES -eq 0 )
     {
        write-host "SUCCESS! ALL FILES IN CI DOCUMENT ARE PRESENT"

        Add-Content -Path "$targetfinal\Validation_Output.txt" -Value "File_Validation_SUCCESS!! ALL FILES IN CI DOCUMENT ARE PRESENT`n"
        Add-Content -Path "$targetfinal\Validation_Output.txt" -Value "`n"
      }


  ################----------------- FAIL! IF SOME FILES IN CI DOC ARE NOT PRESENT IN FOLDER ---------------------###############################

   else{
        write-host "Check Output! Some Files Of CI DOC Are Not Present in  Folder"

        $a = "File_Validation_FAILED!! BELOW Files Are Not PRESENT IN the FOLDER"
        $b = "------------------------------------------------------"
        $c = " "
        $d = "`n"    
        $x = Get-Content $targetfinal\Validation_Output.txt
    
        $countLine = 0

          ForEach ($line in $x)
            {
               $countLine = $countLine+1
            }
         
        Set-Content $targetfinal\Validation_Output.txt –value $a, $b, $c, $x, $d, $d
      }






       ################----------------- SUCCESS_PATH ! IF ALL File_Path IN CI DOC Matches Path IN FOLDER ---------------------############################### 

   #$directoryInfo1 = Get-ChildItem "$source\$confinal\$contentfinal2\Documentation" | Measure-Object
   $directoryInfo1 = Get-ChildItem "$source\$confinal\$contentfinal2\Documentation" -Attributes !Directory
   

        
           if($directoryInfo1.count -ne 0){  

            $TES1 = (Get-Content "$targetfinal\Path_Val_Output.txt").Length
  
               If ($TES1 -eq 0 )
                  {
                    write-host "Path_Validation_SUCCESS!! ALL File_Path IN CI DOC Matches Path IN FOLDER "

                    Add-Content -Path "$targetfinal\Validation_Output.txt" -Value "Path_Validation_SUCCESS!! ALL File_Path IN CI DOC Matches Path IN FOLDER"
                  }
         

             ################----------------- FAIL_PATH! IF Some File_Path IN CI DOC DONOT Match Path IN FOLDER -- ---------------------###############################

               else{
       

                   $a1 = "Path_Validation_FAILED !! BELOW Files Are Not Present At RIGHT_PATH In FOLDER"
                   $b1 = "------------------------------------------------------"
                   $c1 = " "
                   $d1 = "`n"
                   $x0 = Get-Content $targetfinal\Validation_Output.txt
                   $x1 = Get-Content $targetfinal\Path_Val_Output.txt
         
                   Set-Content $targetfinal\Validation_Output.txt –value  $x0, $d1, $d1, $a1, $b1, $c1, $x1
                 }
           }

       else{

            Add-Content -Path "$targetfinal\Validation_Output.txt" -Value "CI DOC NOT FOUND! PLEASE CHECK"
           }


###################--------------------- DELETING THE GENERATED FILES_IN_CI_DOC & FILES_IN_FOLDER .TXT ---------------------###############################

Remove-Item –path $targetfinal\Files_In_Folder.txt
Remove-Item –path $targetfinal\Files_In_CI_Doc.txt
Remove-Item –path $targetfinal\Path_In_CI_Doc.txt
Remove-Item –path $targetfinal\Path_In_Folder.txt
Remove-Item –path $targetfinal\Path_Val_Output.txt


}}}



$contentfinal0 = Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer }

function append-final0 { 
  process{
   foreach-object { 

      $confinal = $_
      $contentfinal1 = Get-ChildItem -Path $source\$confinal | Where-Object {$_.PSIsContainer }
      
      ################----------------- CALLING (FUNCTION-1) ---------------------############################### 
      $contentfinal1 | append-TFS1

   }}}

   $contentfinal0 | append-final0




#--------------------------------------------------------------------------------------------------------------------------------------------------





function append-consolidate1 { 
  process{
   foreach-object { 

   $validChild = $_
   $validTxt = "$source\$validRoot\$validChild\Validation_Output.txt"
   $validTxtContent = Get-Content $validTxt


        
     if($validTxtContent -contains "File_Validation_SUCCESS!! ALL FILES IN CI DOCUMENT ARE PRESENT" -and $validTxtContent -contains "Path_Validation_SUCCESS!! ALL File_Path IN CI DOC Matches Path IN FOLDER" )
                  {
                    write-host " All Success!!!!"
                  }
  
    #If ($validTxtContent -notcontains "File_Validation_SUCCESS!! ALL FILES IN CI DOCUMENT ARE PRESENT" -and $validTxtContent -notcontains "Path_Validation_SUCCESS!! ALL File_Path IN CI DOC Matches Path IN FOLDER" )
     else
                  {
                  # Add-Content -Path "$source\$validRoot\Validation_List.txt" -Value "$validChild"
                    $validVal0 = Get-Content "$source\$validRoot\Validation_List.txt"
                       [string]$validVal1 = "$validChild"
                 }
        
         
      Set-Content "$source\$validRoot\Validation_List.txt" –value $validVal0, $validVal1
      
  

}}}





$whichval = Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer }

function append-consolidate { 
  process{
   foreach-object { 

      $validRoot = $_

      out-file $source\$validRoot\Validation_List.txt

      
      Add-Content -Path "$source\$validRoot\Validation_List.txt" -Value "Validation Failed for below CI Version Folders "
      Add-Content -Path "$source\$validRoot\Validation_List.txt" -Value "-----------------------------------------------"
      Add-Content -Path "$source\$validRoot\Validation_List.txt" -Value " "

      $whichval1 = Get-ChildItem -Path $source\$validRoot | Where-Object {$_.PSIsContainer }
      
      ################----------------- CALLING (FUNCTION-1) ---------------------############################### 
      $whichval1 | append-consolidate1

   }}}

   $whichval | append-consolidate