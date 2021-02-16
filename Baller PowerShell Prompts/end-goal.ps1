$forePromptColor = 0

[System.Collections.Generic.List[ScriptBlock]]$global:PromptRight = @(
    # right aligned
    { "$foreground;${errorStatus}m{0}" -f $lArrow }
    { "$foreground;${forePromptColor}m$background;${errorStatus}m{0}" -f $(if (@(get-history).Count -gt 0) {(get-history)[-1] | % { "{0:c}" -f (new-timespan $_.StartExecutionTime $_.EndExecutionTime)}}else {'00:00:00.0000000'}) }
    
    { "$foreground;7m$background;${errorStatus}m{0}" -f $lArrow }
    { "$foreground;0m$background;7m{0}" -f $(get-date -format "hh:mm:ss tt") }
)

[System.Collections.Generic.List[ScriptBlock]]$global:PromptLeft = @(
    # left aligned
    { "$foreground;${forePromptColor}m$background;${global:platform}m{0}" -f $('{0:d4}' -f $MyInvocation.HistoryId) }
    { "$background;22m$foreground;${global:platform}m{0}" -f $($rArrow) }
    
    { "$background;22m$foreground;${forePromptColor}m{0}" -f $(if ($pushd = (Get-Location -Stack).count) { "$([char]187)" + $pushd }) }
    { "$foreground;22m$background;5m{0}" -f $rArrow }
    
    { "$background;5m$foreground;${forePromptColor}m{0}" -f $($pwd.Drive.Name) }
    { "$background;14m$foreground;5m{0}" -f $rArrow }
    
    { "$background;14m$foreground;${forePromptColor}m{0}$escape[0m" -f $(Split-Path $pwd -leaf) }
)
function global:prompt {
    $global:errorStatus = if ($?) {22}else {1}
    $global:platform = if ($isWindows) {11}else {117}
    $global:lArrow = [char]0xe0b2
    $global:rArrow = [char]0xe0b0
    $escape = "$([char]27)"
    $foreground = "$escape[38;5"
    $background = "$escape[48;5"
    $prompt = ''
        
    $gitTest = $(git config -l) -match 'branch\.'
    if (-not [string]::IsNullOrEmpty($gitTest)) {
        $branch = git symbolic-ref --short -q HEAD
        $aheadbehind = git status -sb
        $distance = ''
    
        if (-not [string]::IsNullOrEmpty($(git diff --staged))) { $branchbg = 3 }
        else { $branchbg = 5 }
    
        if (-not [string]::IsNullOrEmpty($(git status -s))) { $arrowfg = 3 }
        else { $arrowfg = 5 }
    
        if ($aheadbehind -match '\[\w+.*\w+\]$') {
            $ahead = [regex]::matches($aheadbehind, '(?<=ahead\s)\d+').value
            $behind = [regex]::matches($aheadbehind, '(?<=behind\s)\d+').value
    
            $distance = "$background;15m$foreground;${arrowfg}m{0}$escape[0m" -f $rArrow
            if ($ahead) {$distance += "$background;15m$foreground;${forePromptColor}m{0}$escape[0m" -f "a$ahead"}
            if ($behind) {$distance += "$background;15m$foreground;${forePromptColor}m{0}$escape[0m" -f "b$behind"}
            $distance += "$foreground;15m{0}$escape[0m" -f $rArrow
        }
        else {
            $distance = "$foreground;${arrowfg}m{0}$escape[0m" -f $rArrow
        }
    
        [System.Collections.Generic.List[ScriptBlock]]$gitPrompt = @(
            { "$background;${branchbg}m$foreground;14m{0}$escape[0m" -f $rArrow }
            { "$background;${branchbg}m$foreground;${forePromptColor}m{0}$escape[0m" -f $branch }
            { "{0}$escape[0m" -f $distance }
        )
        $prompt = -join @($global:PromptLeft + $gitPrompt + {" "}).Invoke()
    }
    else {
        $prompt = -join @($global:PromptLeft + { "$foreground;14m{0}$escape[0m" -f $rArrow } + {" "}).Invoke()
    }
    
    $rightPromptString = -join ($global:promptRight).Invoke()
    $offset = $global:host.UI.RawUI.BufferSize.Width - 28
    $returnedPrompt = -join @($prompt, "$escape[${offset}G", $rightPromptString, "$escape[0m" + "`n`r`> ")
    $returnedPrompt
}
