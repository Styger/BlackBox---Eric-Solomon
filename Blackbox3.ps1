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

        [int] [Parameter(Mandatory=$false)]$width = 10

    )



    Begin{



        # .Set Variables

        $a = New-Object 'string[,]' $length, $width

    }



    process {



        for ($i = 0; $i -ne $length; $i++) {

            for ($y = 0; $y -ne $width; $y++) {

                $a[$y, $i] = 1

            }

        }

        for ($i = 1; $i -ne ($length - 1); $i++) {

            for ($y = 1; $y -ne ($width - 1); $y++) {

                $a[$y, $i] = 0

            }

        }



        #Random Atoms

        $atomX = Get-Random -Minimum 1 -Maximum 9

        $atomY = Get-Random -Minimum 1 -Maximum 9

        $a[$atomX, $atomY] = "X"

    }



    end {

        return ,$a

    }

}

function Show-Field{
    param (

        [int] [Parameter(Mandatory=$false)]$length = 10,
        [int] [Parameter(Mandatory=$false)]$width = 10,
        [String[,]][Parameter(Mandatory=$true)]$field

    )
        for ($i = 0;$i -ne $length; $i++){
            $s =""
            for ($y = 0;$y -ne $width; $y++){
                $s += $field[$i, $y]
                $s += " "
            }
            Write-Host $s
        }
}


$field = New-Field
Show-Field -field $field