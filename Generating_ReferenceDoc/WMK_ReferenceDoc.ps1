







$source = Read-Host -Prompt 'Input Source Path '
$target = $source
$contentSource = Get-ChildItem -Path "$source\Artifacts.xlsx" -Recurse | Sort Name | Select -ExpandProperty BaseName

#$clientCI = Read-Host -Prompt 'Input TFS Folder Name '

    $data = @($source)

    $newData = $data | foreach {
 $array1 = $_.ToString().Split("\")
 $newArray1 = @()
 $i = ($array1.Count -1)
 $newArray1 += $array1[$i]
 $new_name = $newArray1 -join ""

 }
 $clientCI = $new_name 


#*********************************
$val1 = "Section A:: ARTIFACTS`n"
$val2 = "-------------------------------`r`n"  
$val3 = "Section B:: Deployment Manifest`n"
$val4 = "Section C:: Rollback Manifest`n"
$val5 = "`n"
$val6 = "MSI Deployment Instructions: "




#*********************************


 function CI-Folder { 
  process{
   foreach-object { 
                  
       $CI = "Artifacts.xlsx"

    [string]$filename = "$source\$CI"




       md -Path $target -Name "Reference Document"
       $out = Out-File "$target\Reference Document\$clientCI.txt"
       $file = "$target\Reference Document\$clientCI.txt"
       
       Add-Content -Path $file -Value $val1
       Add-Content -Path $file -Value $val2

  
       
    $objExcel=New-Object -ComObject Excel.Application
    $objExcel.Visible=$false
    $WorkBook=$objExcel.Workbooks.Open($filename)
    $worksheet = $WorkBook.sheets.Item(1)
    [int]$column = 1
    [int]$row = 2

# loop for each row of the excel file
    [int]$intRowMax = ($worksheet.UsedRange.Rows).count
    for($intRow = $row ; $intRow -le $intRowMax ; $intRow++)
    {
$info1 = $worksheet.cells.Item($intRow , 1).Text
$info2 = $worksheet.cells.Item($intRow , 2).Text

               if ($info1 -like '*.sql') {         
                                         Add-Content -Path $file -Value "`n$info1|$info2|$info2|SQL|"
                                             }

                  if ($info1 -like '*.sqp') {                                    
                                         Add-Content -Path $file -Value "`n$info1|$info2|$info2|SQP|"
                                        }                  

                  if ($info1 -like '*.msi'){
                                       Add-Content -Path $file -Value "`n$info1|$info2|$info2|MSI|" 
                                      }
                      
                  if ($info1 -like '*.xml') {
				                        Add-Content -Path $file -Value "`n$info1|$info2|$info2|XML|"
 
                                        }

                  if ($info1 -like '*.fmt') {
				                       Add-Content -Path $file -Value "`n$info1|$info2|$info2|FMT|" 
                                       }

                  if ($info1 -like '*.dll') {
				                        Add-Content -Path $file -Value "`n$info1|$info2|$info2|DLL|" 
                                       }

                  if ($info1 -like '*.exe') {
				                       Add-Content -Path $file -Value "`n$info1|$info2|$info2|EXE|"
                                      } 
                                         
                  if ($info1 -like '*.dtsx') {
				                       Add-Content -Path $file -Value "`n$info1|$info2|$info2|DTSX|"
                                       }   
                  if ($info1 -like '*.doc') {
				                       Add-Content -Path $file -Value "`n$info1|$info2|$info2|DOC|"
                                       }   

                  if ($info1 -notlike '*.sql' -and $info1 -notlike '*.sqp' -and $info1 -notlike '*.msi' -and $info1 -notlike '*.xml' -and $info1 -notlike '*.fmt' -and $info1 -notlike '*.dll' -and $info1 -notlike '*.exe' -and $info1 -notlike '*.dtsx' -and $info1 -notlike '*.doc') {
				                       Add-Content -Path $file -Value "`n$info1|$info2|$info2||"
                                       }                                                          


#Add-Content -Path $file -Value "`n$info1|$info2|$info2"
    } 
    $WorkBook.close()
    $objexcel.quit()


       Add-Content -Path $file -Value $val5
       Add-Content -Path $file -Value $val5
       Add-Content -Path $file -Value $val5

      $txtline = Get-Content -Path $file
   
       Foreach($line in $txtline){
       
           if([string]$line -like "*.msi*"){
             Write-Host $line
                   Add-Content -Path $file -Value $val6
                   Add-Content -Path $file -Value $val2
                   #$MsiInsruction = Read-Host -Prompt '**MSI FOUND, INPUT MSI Deployment Instructions: **'
                   #[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
                   #$MsiInsruction = [Microsoft.VisualBasic.Interaction]::InputBox("**MSI FOUND, INPUT MSI Deployment Instructions: **", "$env:MsiInsruction")



                       # This script is used in a blog post on the https://mohitgoyal.co/2017/04/16/read-multi-line-input-from-users-in-powershell/. Please
    # read the blog post for more information 
    
    function Read-MultiLineInputBoxDialog([string]$Message, [string]$WindowTitle, [string]$DefaultText)
    {
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName System.Windows.Forms
     
        # Create the Label.
        $label = New-Object System.Windows.Forms.Label
        $label.Location = New-Object System.Drawing.Size(10,10) 
        $label.Size = New-Object System.Drawing.Size(280,20)
        $label.AutoSize = $true
        $label.Text = $Message
     
        # Create the TextBox used to capture the user's text.
        $textBox = New-Object System.Windows.Forms.TextBox 
        $textBox.Location = New-Object System.Drawing.Size(10,40) 
        $textBox.Size = New-Object System.Drawing.Size(575,200)
        $textBox.AcceptsReturn = $true
        $textBox.AcceptsTab = $false
        $textBox.Multiline = $true
        $textBox.ScrollBars = 'Both'
        $textBox.Text = $DefaultText
     
        # Create the OK button.
        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Location = New-Object System.Drawing.Size(415,250)
        $okButton.Size = New-Object System.Drawing.Size(75,25)
        $okButton.Text = "OK"
        $okButton.Add_Click({ $form.Tag = $textBox.Text; $form.Close() })
     
        # Create the Cancel button.
        $cancelButton = New-Object System.Windows.Forms.Button
        $cancelButton.Location = New-Object System.Drawing.Size(510,250)
        $cancelButton.Size = New-Object System.Drawing.Size(75,25)
        $cancelButton.Text = "Cancel"
        $cancelButton.Add_Click({ $form.Tag = $null; $form.Close() })
     
        # Create the form.
        $form = New-Object System.Windows.Forms.Form 
        $form.Text = $WindowTitle
        $form.Size = New-Object System.Drawing.Size(610,320)
        $form.FormBorderStyle = 'FixedSingle'
        $form.StartPosition = "CenterScreen"
        $form.AutoSizeMode = 'GrowAndShrink'
        $form.Topmost = $True
        $form.AcceptButton = $okButton
        $form.CancelButton = $cancelButton
        $form.ShowInTaskbar = $true
     
        # Add all of the controls to the form.
        $form.Controls.Add($label)
        $form.Controls.Add($textBox)
        $form.Controls.Add($okButton)
        $form.Controls.Add($cancelButton)
     
        # Initialize and show the form.
        $form.Add_Shown({$form.Activate()})
        $form.ShowDialog() > $null   # Trash the text of the button that was clicked.
     
        # Return the text that the user entered.
        return $form.Tag
    }

    $multiLineText = Read-MultiLineInputBoxDialog -Message "**MSI FOUND, INPUT MSI Deployment Instructions: **" -WindowTitle "Multi Line Example"
    if ($multiLineText -eq $null) { Write-Host "You clicked Cancel" }
    else { Write-Host "You entered the following text: $multiLineText" }



                   Add-Content -Path $file -Value $multiLineText
                   Add-Content -Path $file -Value $val5
                   Add-Content -Path $file -Value $val5
                   Add-Content -Path $file -Value $val5
                   }
                   }
                                   
        


       #Get-Content $file | Where-Object { $_ -like "*.msi" } | Add-Content -Path $file -Value $val6 
      # Get-Content $file | Where-Object { $_ -like "*.msi" } | Add-Content -Path $file -Value $val2


       Add-Content -Path $file -Value $val3
       Add-Content -Path $file -Value $val2

       Add-Content -Path $file -Value $val5
       Add-Content -Path $file -Value $val5
       Add-Content -Path $file -Value $val5

       Add-Content -Path $file -Value $val4
       Add-Content -Path $file -Value $val2



     #Rename-Item $file $target\$CI.txt -PassThru
 
     #$CInew = "$target\$CI.txt"

     
       

    #$editRef | Edit-Reference | Set-Content  $CInew

 #$appendREF = Get-Content $CInew
 #$val1+$val2+$editRef |  Set-Content $CInew


}}}

$contentSource | CI-Folder

 