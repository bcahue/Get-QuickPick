<#
.SYNOPSIS
Generates a Quick Pick set of numbers for PowerBall.

.DESCRIPTION
The Get-QuickPick uses the Get-Random cmdlet to generate a random set of Quick Pick numbers
for as many times as desired.

.PARAMETER Times 
The amount of times the script will generate a Quick Pick. Default is 1.

.EXAMPLE
Get 50 Quick Picks, but exclude ones with your unlucky third ball number.
Get-QuickPick -Times 50 | Where-Object { $_.ThirdBall -ne 66 }

.EXAMPLE
To fruitlessly test if this function can simulate winning PowerBall numbers.
Lightning always strikes twice!
Get-QuickPick -Times 50000 | Where-Object { $_.Numbers() -eq "4 8 19 27 34 10" }

.EXAMPLE
To format the ticket numbers into a pretty table.
$format = @{Label="First Ball"; Expression={$_.FirstBall}; Align="right"}, `
@{Label="Second Ball"; Expression={$_.SecondBall}; Align="right"}, `
@{Label="Third Ball"; Expression={$_.ThirdBall}; Align="right"}, `
@{Label="Fourth Ball"; Expression={$_.FourthBall}; Align="right"}, `
@{Label="Fifth Ball"; Expression={$_.FifthBall}; Align="right"}, `
@{Label="Power Ball"; Expression={$_.PowerBall}; Align="right"}

$table = Get-QuickPick -Times 50

$table | Format-Table $format

.EXAMPLE
To format the ticket numbers without your unlucky ball picks into a pretty table.
$format = @{Label="First Ball"; Expression={$_.FirstBall}; Align="right"}, `
@{Label="Second Ball"; Expression={$_.SecondBall}; Align="right"}, `
@{Label="Third Ball"; Expression={$_.ThirdBall}; Align="right"}, `
@{Label="Fourth Ball"; Expression={$_.FourthBall}; Align="right"}, `
@{Label="Fifth Ball"; Expression={$_.FifthBall}; Align="right"}, `
@{Label="Power Ball"; Expression={$_.PowerBall}; Align="right"}

$table = Get-QuickPick -Times 50 | Where-Object {
    ($_.SecondBall -notin 66..69) -and ($_.FirstBall -ne 40)
}

$table | Format-Table $format

.NOTES
This function requires no explicit permissions besides an Unrestricted execution policy.

.LINK
https://github.com/bcahue/Get-QuickPick
#>

function Get-QuickPick {
    param(
    [Parameter(
        Mandatory=$false,
        Position = 0)]
    [uint16]$Times = 1
    )

    $tickets = @()

    for ($quickpicks = 0; $quickpicks -lt $Times; $quickpicks++) {
        $ffballs = @()

        $ffpick = 1..69
        $pbpick = 1..26

        $pbball = 0

        for ($i = 0; $i -lt 5; $i++) {
            $pick = Get-Random -InputObject $ffpick
            $ffpick = $ffpick | Where-Object { $_ -ne $pick }
            $ffballs += "$pick"
        }

        $pbball = Get-Random -InputObject $pbpick

        $ticket = [PSCustomObject][Ordered] @{
            FirstBall = $ffballs[0];
            SecondBall = $ffballs[1];
            ThirdBall = $ffballs[2];
            FourthBall = $ffballs[3];
            FifthBall = $ffballs[4];
            PowerBall = $pbball;
        }

        $ticket | Add-Member -PassThru ScriptMethod Numbers {
           ($this.FirstBall,
            $this.SecondBall,
            $this.ThirdBall,
            $this.FourthBall,
            $this.FifthBall,
            $this.PowerBall -join " ")
        } | Out-Null

        $tickets += $ticket
    }

    return $tickets
}