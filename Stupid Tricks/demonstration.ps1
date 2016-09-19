#region 00. prep
if (-not (test-path 'c:\temp\demo'))
{
    new-item -itemtype directory -path 'c:\temp\demo'
}
push-location 'c:\temp\demo'

remove-item '.\*' -force -Recurse

@('test1.txt','test2.txt','test3.txt') | foreach-object { new-item -path $_ -ErrorAction 'silentlycontinue' }
#endregion



#region 01. select-object hashtables
get-childitem
get-childitem | select-object *
get-childitem | select-object fullname,creationtime,lastwritetime

get-childitem | select-object fullname,creationtime,lastwritetime,@{l='Diff Btwn Write & Create';e={new-timespan $_.creationtime $_.lastwritetime}}

write-output 'some change' | out-file 'test2.txt'

get-childitem | select-object fullname,creationtime,lastwritetime,@{l='Diff Btwn Write & Create';e={new-timespan $_.creationtime $_.lastwritetime}}
#endregion

#region 02. get-member, get-command, get-type
get-cimclass -ClassName win32_operatingsystem
get-cimclass -ClassName win32_operatingsystem | get-member
get-command get-cimclass
get-command get-cimclass | select *
get-command get-cimclass | select -ExpandProperty parameters

#you can see the definition of functions (but not cmdlets)
function invoke-test
{
    write-output 'did it'
}

invoke-test

get-command invoke-test | select *

(get-command invoke-test).definition

$thing1 = 'This is an item'
$thing2 = @('This is another item','This is one more item')
$thing1; $thing2

$thing1 | gm
$thing2 | gm #LIES!

$thing3 = @([int]21,[string]'hello',[pscustomobject]'goodbye')
$thing3 | gm

$thing1.gettype()
$thing2.gettype()

#why would I care?
$thing1 += ' with something added on'
$thing2 += ' with something added on'

$thing1; $thing2
#endregion

#region 03. #<part of command>
#run on individual lines
write-output 'output'
write-verbose 'verbose' -verbose
write-warning 'warning'

#now demo the interesting part
#endregion

#region 04. the rules for ft, fl and ogv
get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser
get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser,version

get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser | format-list
get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser,version | format-table
get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser,version | out-gridview

get-childitem | select name,last* | ogv
#endregion

#region 05. r and scb
clear-host

write-output 'omg this is a long command that i would not want to type again but i sure would like to reproduce the output!'
r

write-output 'now this is another command that i would not want to type'
r

get-alias r

get-history | sort -Descending | select -first 10

r #number

r | scb

get-alias scb
#endregion

#region 06. splatting
new-item -ItemType File -Path 'c:\temp\demo' -name 'test4.txt'

$newitemparams = @{'itemtype'='file'; 'path'='c:\temp\demo'; 'name'='test5.txt'}
new-item @newitemparams

$newitemparams = @{'itemtype'='file'; 'path'='c:\temp\demo'}
6..10 | foreach-object { new-item @newitemparams -name "test$_.txt" }

#this is going to fail because I don't have AD in this demo
$adusers = @('thomas','angela','matt','aman')
$adparams = @{'properties'='memberof'; 'searchbase'='ou=someou,dc=lab,dc=workingsysadmin,dc=ca'}

$adusers | foreach-object {
    get-aduser @adparams -identity $_
}
#endregion

#region 07. .split() vs -split, also trim
$splitstring = 'this is an interesting string with the letters s and t all over the place'

$splitstring.split('s')
$splitstring.split('t')

$splitstring.split('st')
$splitstring -split 'st'

$splitstring.trim('iecht') #.trim() also works this way
#endregion

#region 08. get-random min and max
-join (1..10 | % { get-random -Minimum 1 -Maximum 10 })

-join (1..250 | % { get-random -Minimum 1 -Maximum 10 })

-join (1..250 | % { get-random -Minimum 1 -Maximum 2 })

-join (1..250 | % { get-random -Minimum 1 -Maximum 3 })
#endregion

#region 09. -whatif and -confirm, $psdefaultparam
new-item 'are you sure.txt' -confirm
new-item 'are you sure for real.txt' -whatif

$PSDefaultParameterValues.add('new-item:confirm',$true)
$PSDefaultParameterValues

new-item 'are you sure you dont want to confirm.txt'

$PSDefaultParameterValues.clear()

$PSDefaultParameterValues.add('*:whatif',$true)
$PSDefaultParameterValues

get-childitem
new-item 'not going to happen.txt'
new-item 'not going to happen.txt' -whatif:$false

$PSDefaultParameterValues.clear()
#endregion

#region 10. erroractionpreference confirmpreference
$erroractionpreference
$erroractionpreference = 'stop'
$erroractionpreference = 'silentlycontinue'
$erroractionpreference = 'continue'

new-item 'test1.txt'
new-item 'test1.txt' -ErrorAction 'ignore'

$?

$ConfirmPreference
$ConfirmPreference = 'none'
$ConfirmPreference = 'high'
#endregion

#region 11. push and pop location
push-location c:\temp
push-location c:\temp\demo
push-location c:\windows
push-location c:\temp\demo

get-location -stack

pop-location
#endregion

#region 12. begin, process and end in foreach-object
$adusers
$adusers | foreach-object { write-output "$_ is a nice person" }

$adusers | foreach-object -begin { write-output 'the third line is false' } `
                          -process { write-output "$_ is a nice person" } `
                          -end { write-output 'the first line might be false too' } 
#endregion

#region 13. $false and '' are not equal
$false -eq ''
'' -eq $false
$true -eq ''
'' -eq $true
$false -eq $null
$true -eq $null
$null -eq $true
$null -eq $false
'' -eq $null
$null -eq ''

$couldbeempty = ''
[string]::IsNullOrEmpty($couldbeempty)
[string]::IsNullOrWhiteSpace($couldbeempty)
$couldbeempty -eq $false
$couldbeempty -eq $true

$couldbeempty = '      '
[string]::IsNullOrEmpty($couldbeempty)
[string]::IsNullOrWhiteSpace($couldbeempty)
$couldbeempty -eq $false
$couldbeempty -eq $true
#endregion

#region 17. wrap stuff in $()
$getOS = get-wmiobject win32_operatingsystem | select caption,version
$getOS
$getOS.caption
$getOS.version

write-output "The caption is $getOS.caption and the version is $getOS.version"

write-output "The caption is $($getOS.caption) and the version is $($getOS.version)"

write-output "Today's is $((get-date).dayofweek) and it's currently $(get-date -format hh:mm:ss)"
#endregion

#region 14. nullable parameters
function write-datetime
{
    param
    (
        [datetime]$datetime,
        [string]$name
    )
    write-output "$name checked in at $datetime"
}

$namesdates = @{
    'thomas'=$(get-date).addhours(-2);
    'angela'=$(get-date).addhours(-2);
    'matthew'=$(get-date).adddays(-2);
    'aman'=$(get-date).addhours(-1)
}

foreach ($checkin in $namesdates.GetEnumerator())
{
    write-datetime -name $checkin.key -datetime $checkin.value
}

$namesdates = @{
    'thomas'=$(get-date).addhours(-2);
    'angela'=$(get-date).addhours(-2);
    'matthew'=$null;
    'aman'=$(get-date).addhours(-1)
}

$namesdates['thomas']
$namesdates['matthew']
$datesnames['nope']

foreach ($checkin in $namesdates.GetEnumerator())
{
    write-datetime -name $checkin.key -datetime $checkin.value
}

#what if we just use some conditional logic?
function write-datetime
{
    param
    (
        [datetime]$datetime,
        [string]$name
    )
    write-output "$name checked in at $(if ($datetime) {$datetime} else {'error receiving data'})"
}

foreach ($checkin in $namesdates.GetEnumerator())
{
    write-datetime -name $checkin.key -datetime $checkin.value
}

#nope, the issue occurs before we even try to execute the write-output line
function write-datetime
{
    param
    (
        [nullable[datetime]]$datetime,
        [string]$name
    )
    write-output "$name checked in at $(if ($datetime) {$datetime} else {'error receiving data'})"
}

foreach ($checkin in $namesdates.GetEnumerator())
{
    write-datetime -name $checkin.key -datetime $checkin.value
}
#endregion

#region 15. write-host vs write-output
write-host 'something'
write-output 'something'

write-host 'something' -ForegroundColor green -BackgroundColor darkYellow -nonewline; write-host ' else' -ForegroundColor red -BackgroundColor black

write-output "I can't do that"

$outputfromhost = write-host 'something'
$outputfromhost
$outputfromoutput = write-output 'something'
$outputfromoutput
#endregion

#region 16. take the first dir from a list (breaking out of a foreach loop)
$possibleinstalls = @('c:\nope\thing.txt','c:\temp\demo\test1.txt','c:\temp\demo\test2.txt')
$possibleinstalls | foreach-object { if (test-path $_) { $_; break } }
#endregion

#region 18. split a string on a lookahead or lookbehind
$somefilename = (gi 'test1.txt').FullName
$somefilename

$somefilename -split '\\' #don't forget to escape the backslash
$somefilename -split '\.'

$somefilename -split '(?=\\)'
$somefilename -split '(?=\.)'

$somefilename -split '(?<=\\)'
$somefilename -split '(?<=\.)'
#endregion