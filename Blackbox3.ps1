$Alphabet = @()
$AlphabetNumber = 0

for ($i = 97; $i -le 122; $i++) {
    $Alphabet += [char]$i
}

function New-Field {
    <#

    .SYNOPSIS

    This is a PowerShell function named Create-Field that creates a two-dimensional array of strings with a specified length and width, and then initializes the elements of the array with the value 1.



    .DESCRIPTION

    The function starts with a param block that defines two parameters, $length and $width, both of which are of type int. These parameters are marked as optional, and if they are not provided when the function is called, their default values are set to 10.

    The function has a Begin block that executes only once when the function is called, it creates two 2D arrays of strings, $a and $u with the size of $length and $width that were passed as an argument or the default values.

    The process block contains two nested for loops that iterate through the rows and columns of the array $a. The outer loop runs from 0 to the value of the $length variable, and the inner loop runs from 0 to the value of the $width variable. In each iteration, the current element of the array is set to the value 1 using the $a[$y,$i] =1 statement.

    Then, the function uses another two nested for loops to iterate through the array again and set the elements of the array to 0, but this time the loops only run through the array with an offset



    .EXAMPLE

    # Create a 10x10 array with default values

    $array = Create-Field



    In the first example, the function is called without any parameters, so the default values of 10 for both $length and $width will be used. The resulting array will have a size of 10x10.



    .EXAMPLE

    # Create a 15x20 array with specified values

    $array2 = Create-Field -length 15 -width 20



    In the second example, the function is called with specific values of 15 and 20 for $length and $width respectively. The resulting array will have a size of 15x20.



    .EXAMPLE

    # Create a 5x5 array with specified values

    $array3 = Create-Field -length 5 -width 5



    In the third example, the function is called with specific values of 5 and 5 for $length and $width respectively. The resulting array will have a size of 5x5.

    #>


    param(

        [int] [Parameter(Mandatory=$false)]$length = 10,
        [int] [Parameter(Mandatory=$false)]$width = 10,
        [bool] [Parameter(Mandatory=$false)]$SolutionField = $true,
        [int] [Parameter(Mandatory=$false)]$AtomNumber = 5

    )


    Begin{
        # .Set Variables

        $field = New-Object 'string[,]' $length, $width

    }



    process {

        for ($x = 0; $x -ne $length; $x++) {

            for ($y = 0; $y -ne $width; $y++) {

                $field[$x, $y] = 1

            }

        }

        for ($x = 1; $x -ne ($length - 1); $x++) {

            for ($y = 1; $y -ne ($width - 1); $y++) {

                $field[$x, $y] = 0

            }

        }



        #Random Atoms if it is a Solutionfield
        if ($SolutionField) {
            $RealAtomNumber = 0
            Do{

                $atomX = Get-Random -Minimum 1 -Maximum $length
                $atomY = Get-Random -Minimum 1 -Maximum $width
                if ($field[$atomX,$atomY] -eq 0) {
                    $field[$atomX,$atomY] = "X"
                    $RealAtomNumber+=1
                }

            }until ($AtomNumber -eq $RealAtomNumber) 
                
            }
                
        }
        end {
            return ,$field
    
        }
}

    
function Show-Field{
    param (

        [int] [Parameter(Mandatory=$false)]$length = 10,
        [int] [Parameter(Mandatory=$false)]$width = 10,
        [String[,]][Parameter(Mandatory=$true)]$field

    )
    $s = ""
        for ($y = 0;$y -ne $length; $y++){

            $s += "`n"

            for ($x = 0;$x -ne $width; $x++){

                $s += $field[$x, $y]
                $s += " "

            }

        }

        Write-Host $s
}

function Show-Field2{
    param (

        [int] [Parameter(Mandatory=$false)]$length = 10,
        [int] [Parameter(Mandatory=$false)]$width = 10,
        [String[,]][Parameter(Mandatory=$true)]$field

    )
    $y = 0
    Do{

        $x = 0
        $s += "`n"

        Do{

            $s += $field[$x, $y]
            $s += " "
            $x++

        }while ($x -ne 10)

        $y++

    }while ($y -ne 10)

    Write-Host $s

}

function Check-Success{
    param(

        [int] [Parameter(Mandatory=$false)]$length = 10,
        [int] [Parameter(Mandatory=$false)]$width = 10,
        [String[,]][Parameter(Mandatory=$true)]$field,
        [String[,]][Parameter(Mandatory=$true)]$field2

    )

    for ($x = 1;$x -ne ($length-1); $x++){
        for ($y = 1;$y -ne ($width-1); $y++){
            if($field[$x,$y] -ne $field2[$x,$y]){

            return $false

            }

        }
    }

    return $true

}

function Set-Atom{
    param(

        [int] [Parameter(Mandatory=$true)]$AtomX,
        [int] [Parameter(Mandatory=$true)]$AtomY,
        [String[,]][Parameter(Mandatory=$true)]$field

    )


    $field[$AtomX,$AtomY] = "X"

}

function Remove-Atom{
    param(

        [int] [Parameter(Mandatory=$true)]$AtomX,
        [int] [Parameter(Mandatory=$true)]$AtomY,
        [String[,]][Parameter(Mandatory=$true)]$field

    )


    $field[$AtomX,$AtomY] = 0

}

function Shoot-Laser {
    param (

        [int] [Parameter(Mandatory=$false)]$length = 10,
        [int] [Parameter(Mandatory=$false)]$width = 10,
        [int] [Parameter(Mandatory=$true)]$ShotX,
        [int] [Parameter(Mandatory=$true)]$ShotY,
        [String[,]] [Parameter(Mandatory=$true)]$SolutionField,
        [String[,]] [Parameter(Mandatory=$true)]$UserField

    )

    #find Direction
    if ($ShotX -eq 0) {
        $direction = "O"
    }elseif ($ShotX -eq ($length - 1)) {
        $direction = "W"
    }elseif ($ShotY -eq 0){
        $direction = "S"
    }elseif ($ShotY -eq ($width - 1)){
        $direction = "N"
    }else{
        Write-Host "Not a Valid Coordinate"
        Return
    }

    #Check if Response of Position is already known
    if($UserField[$ShotX,$ShotY] -ne "1"){
        Write-Host "The Response of the Position $ShotX / $ShotY is already known"
        Return
    }


    $StartX = $ShotX
    $StartY = $ShotY

    #Check for special Rules
    if ($direction -eq "O"){
        if($SolutionField[($ShotX+1),($ShotY)] -eq "X"){
            $UserField[$StartX,$StartY] = "H"
            $SolutionField[$StartX,$StartY] = "H"
            Return
        }elseif ($SolutionField[($ShotX+1),($ShotY-1)] -eq "X" -or $SolutionField[($ShotX+1),($ShotY+1)] -eq "X" ) {
            $UserField[$StartX,$StartY] = "R"
            $SolutionField[$StartX,$StartY] = "R"
            Return
        }else{
            $ShotX+=1
        }
    }elseif($direction -eq "W"){
        if($SolutionField[($ShotX-1),$ShotY] -eq "X"){
            $UserField[$StartX,$StartY] = "H"
            $SolutionField[$StartX,$StartY] = "H"
            Return
        }elseif ($SolutionField[($ShotX-1),($ShotY-1)] -eq "X" -or $SolutionField[($ShotX-1),($ShotY+1)] -eq "X") {
            $UserField[$StartX,$StartY] = "R"
            $SolutionField[$StartX,$StartY] = "R"
            Return
        }else{
            $ShotX-=1
        }

    }elseif($direction -eq "S"){
        if($SolutionField[$ShotX,($ShotY+1)] -eq "X"){
            $UserField[$StartX,$StartY] = "H"
            $SolutionField[$StartX,$StartY] = "H"
            Return
        }elseif ($SolutionField[($ShotX+1),($ShotY+1)] -eq "X" -or $SolutionField[($ShotX-1),($ShotY+1)] -eq "X") {
            $UserField[$StartX,$StartY] = "R"
            $SolutionField[$StartX,$StartY] = "R"
            Return
        }else{
            $ShotY+=1
        }

    }elseif($direction -eq "N"){
        if($SolutionField[$ShotX,($ShotY-1)] -eq "X"){
            $UserField[$StartX,$StartY] = "H"
            $SolutionField[$StartX,$StartY] = "H"
            Return
        }elseif ($SolutionField[($ShotX+1),($ShotY-1)] -eq "X" -or $SolutionField[($ShotX-1),($ShotY-1)] -eq "X") {
            $UserField[$StartX,$StartY] = "R"
            $SolutionField[$StartX,$StartY] = "R"
            Return
        }else{
            $ShotY-=1
        }
    }else{
        Write-Host "Something is wrong"
        Return
    }

   #Normal Rules (Algorithmus)
    Do{
        if ($direction -eq "O"){
            if($SolutionField[($ShotX+1),$ShotY] -eq "X"){
                $UserField[$StartX,$StartY] = "H"
                $SolutionField[$StartX,$StartY] = "H"
                Return
            }elseif (($SolutionField[($ShotX+1),($ShotY+1)] -eq "X") -And ($SolutionField[($ShotX+1),($ShotY-1)] -eq "X")) {
                $UserField[$StartX,$StartY] = "R"
                $SolutionField[$StartX,$StartY] = "R"
                Return
            }elseif ($SolutionField[($ShotX+1),($ShotY+1)] -eq "X" ) {
                $direction = "N"
                $ShotY-=1

            }elseif ( $SolutionField[($ShotX+1),($ShotY-1)] -eq "X") {
                $direction = "S"
                $ShotY+=1

            }else{
                $ShotX+=1
            }
        }elseif($direction -eq "W"){
            if($SolutionField[($ShotX-1),$ShotY] -eq "X"){
                $UserField[$StartX,$StartY] = "H"
                $SolutionField[$StartX,$StartY] = "H"
                Return
            }elseif ($SolutionField[($ShotX-1),($ShotY+1)] -eq "X" -And $SolutionField[($ShotX-1),($ShotY-1)] -eq "X") {
                $UserField[$StartX,$StartY] = "R"
                $SolutionField[$StartX,$StartY] = "R"
                Return
            }elseif ($SolutionField[($ShotX-1),($ShotY+1)] -eq "X" ) {
                $direction = "N"
                $ShotY-=1

            }elseif ( $SolutionField[($ShotX-1),($ShotY-1)] -eq "X") {
                $direction = "S"
                $ShotY+=1

            }else{
                $ShotX-=1
            }

        }elseif($direction -eq "S"){
            if($SolutionField[$ShotX,($ShotY+1)] -eq "X"){
                $UserField[$StartX,$StartY] = "H"
                $SolutionField[$StartX,$StartY] = "H"
                Return
            }elseif ($SolutionField[($ShotX+1),($ShotY+1)] -eq "X" -And $SolutionField[($ShotX-1),($ShotY+1)] -eq "X") {
                $UserField[$StartX,$StartY] = "R"
                $SolutionField[$StartX,$StartY] = "R"
                Return
            }elseif ($SolutionField[($ShotX+1),($ShotY+1)] -eq "X" ) {
                $direction = "W"
                $ShotX+=1

            }elseif ( $SolutionField[($ShotX-1),($ShotY+1)] -eq "X") {
                $direction = "O"
                $ShotX-=1

            }else{
                $ShotY+=1
            }

        }elseif($direction -eq "N"){
            if($SolutionField[$ShotX,($ShotY-1)] -eq "X"){
                $UserField[$StartX,$StartY] = "H"
                $SolutionField[$StartX,$StartY] = "H"
                Return
            }elseif ($SolutionField[($ShotX+1),($ShotY-1)] -eq "X" -And $SolutionField[($ShotX-1),($ShotY-1)] -eq "X") {
                $UserField[$StartX,$StartY] = "R"
                $SolutionField[$StartX,$StartY] = "R"
                Return
            }elseif ($SolutionField[($ShotX+1),($ShotY-1)] -eq "X" ) {
                $direction = "W"
                $ShotX-=1

            }elseif ( $SolutionField[($ShotX-1),($ShotY-1)] -eq "X") {
                $direction = "O"
                $ShotX+=1

            }else{
                $ShotY-=1
            }
        }else{
            Write-Host "Something is wrong"
            Return
        }

    }while($SolutionField[$ShotX,$ShotY] -eq 0)

    $SolutionField[($ShotX),($ShotY)] = $Alphabet[$AlphabetNumber]
    $SolutionField[($StartX),($StartY)] = $Alphabet[$AlphabetNumber]
    $UserField[($ShotX),($ShotY)] = $Alphabet[$AlphabetNumber]
    $UserField[($StartX),($StartY)] = $Alphabet[$AlphabetNumber]

    Return 1





}

#Main

$SolutionField = New-Field
$UserField = New-Field -SolutionField $false




Do{
    Write-Host "`nEnter a Option"
    $option = Read-Host
    switch ($option)
    {
        1 {"Here is your Field"

            Show-Field2 -field $UserField
        }
        2 {"Set an Atom`n"
            Write-Host "define the X coordinate:"
            $X = Read-Host
            Write-Host "define the Y coordinate:"
            $Y = Read-Host
            Set-Atom -field $UserField -AtomX $X -AtomY $Y


        }
        3 {"Remove an Atom`n"
            Write-Host "define the X coordinate:"
            $X = Read-Host
            Write-Host "define the Y coordinate:"
            $Y = Read-Host
            Remove-Atom -field $UserField -AtomX $X -AtomY $Y


        }
        4 {"Check if you have won the game`n"

            if (Check-Success -field $UserField -field2 $SolutionField ) {
                Write-Host "Congratulations you won!!!"
            }else {
                Write-Host "Sorry but you didn't win now"
            }
        }
        5 {"Shoot with the Laser"
            Write-Host "define the X coordinate:"
            $X = Read-Host
            Write-Host "define the Y coordinate:"
            $Y = Read-Host
            if((Shoot-Laser -SolutionField $SolutionField -UserField $UserField -ShotX $X -ShotY $Y) -eq 1){
                $AlphabetNumber+=1
            }



        }

        101 {"Here is the Solution Field"

            Show-Field -field $SolutionField
        }
        12 {"Exit"
            
        
        }
    }

}while($option -ne 11)