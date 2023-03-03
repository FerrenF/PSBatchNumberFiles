

$dryRun = $true

function doLoop{
    $path = pwd
    $arr = Get-ChildItem $path | Where-Object { $_.PsIsContainer -eq $false }
    $iter = 0
    foreach( $file in $arr){

        $n = $file.Name;
        $mat = ($n -match $filter)
        if( $mat -eq $true ){
            $on = -join($iter, $file.Extension, ' <- ', $n);
            echo $on
            $iter++
        } 

        if($dryRun -eq $false){

            $targ = -join($file.Directory,'\', $iter, $file.Extension)
            Move-Item $file.FullName $targ
        }
    } 
}



function Rename-WithNumbers {
    param([string] $filter = ".")
    <#
     .Synopsis
      Renames files to a sequence of numbers.

     .DESCRIPTION
      Renames all of the files matching filter in the current working directory to a sequence of increasing numbers.

     .PARAMETER filter
      Regular expression filter to use. Default is all files, or '.'

      Set-Item
    #>
    doLoop
    $response = Read-Host -Prompt 'Continue with these changes? y/n'
    if($response.ToLower() -eq 'y'){
        $dryRun = $false
        doLoop
    }
}
Export-ModuleMember -Function Rename-WithNumbers
