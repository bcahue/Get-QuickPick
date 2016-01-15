# Get-QuickPick
A PowerShell script that simulates a PowerBall Quick Pick number set.

## Parameters
* `-Times [uint16]` The amount of tickets the script generates in one run.

## Examples
Get 50 Quick Picks, but exclude ones with your unlucky third ball number.

    Get-QuickPick -Times 50 | Where-Object { $_.ThirdBall -ne 66 }

To fruitlessly test if this function can simulate winning PowerBall numbers. Lightning always strikes twice!

    Get-QuickPick -Times 50000 | Where-Object { $_.Numbers() -eq "4 8 19 27 34 10" }

To format the ticket numbers into a pretty table.

    $format = @{Label="First Ball"; Expression={$_.FirstBall}; Align="right"}, `
    @{Label="Second Ball"; Expression={$_.SecondBall}; Align="right"}, `
    @{Label="Third Ball"; Expression={$_.ThirdBall}; Align="right"}, `
    @{Label="Fourth Ball"; Expression={$_.FourthBall}; Align="right"}, `
    @{Label="Fifth Ball"; Expression={$_.FifthBall}; Align="right"}, `
    @{Label="Power Ball"; Expression={$_.PowerBall}; Align="right"}

    $table = Get-QuickPick -Times 50

    $table | Format-Table $format
