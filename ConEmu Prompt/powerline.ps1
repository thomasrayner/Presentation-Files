$add = @'
import-module powerline

$global:PowerLinePrompt = 1,
    # two lines
    @(
        # on the first line, two columns -- the first one is null (empty), the second is right-justified
        $null,
        @(
            @{ text = { New-PowerLineBlock (Get-Elapsed) -ErrorBackgroundColor DarkRed -ErrorForegroundColor White -ForegroundColor Black -BackgroundColor DarkGray } }
            @{ bg = "Gray";     fg = "Black"; text = { Get-Date -f "T" } }
        )
    ),
    (
        @{ bg = "Blue";     fg = "White"; text = { $MyInvocation.HistoryId } },
        @{ bg = "Cyan";     fg = "White"; text = { [PowerLine.Prompt]::Gear * $NestedPromptLevel } },
        @{ bg = "Cyan";     fg = "White"; text = { if($pushd = (Get-Location -Stack).count) { "$([char]187)" + $pushd } } },
        @{ bg = "DarkBlue"; fg = "White"; text = { $pwd.Drive.Name } },
        @{ bg = "DarkBlue"; fg = "White"; text = { Split-Path $pwd -leaf } }
    )

Set-PowerLinePrompt -CurrentDirectory -PowerLineFont
'@
$add | out-file -append -FilePath $profile 