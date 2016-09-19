#region prep
if (-not (test-path 'c:\temp\demo'))
{
    new-item -itemtype directory -path 'c:\temp\demo'
}
push-location 'c:\temp\demo'

$demofiles = @('test1.txt','test2.txt','test3.txt')
$demofiles | foreach-object {
    if (-not (test-path $_))
        {
            new-item -path $_
        }
}
#endregion


#region select-object hashtables
get-childitem
get-childitem | select-object fullname,creationtime,lastwritetime
get-childitem | select-object fullname,creationtime,lastwritetime,@{l='Diff Btwn Write & Create';e={new-timespan $_.creationtime $_.lastwritetime}}
#endregion

#region get-member, get-command, get-type
get-cimclass -ClassName win32_operatingsystem
get-cimclass -ClassName win32_operatingsystem | get-member
get-command get-cimclass
get-command get-cimclass | select *

#you can see the definition of functions (but not cmdlets)
function invoke-test
{
    write-output 'did it'
}
invoke-test
get-command invoke-test | select *

$thing1 = 'This is an item'
$thing2 = @('This is another item','This is one more item')
$thing1; $thing2

$thing1 | gm
$thing2 | gm #LIES! It's an array and get-member is returning the info for the first item in the array

$thing1.gettype()
$thing2.gettype()

#why would I care?
$thing1 += ' with something added on'
$thing2 += ' with something added on'

$thing1; $thing2
#endregion

#region #<part of command>
#run on individual lines
write-output 'output'
write-verbose 'verbose' -verbose
write-warning 'warning'

#now demo the interesting part
#endregion

#region the rules for ft, fl and ogv
get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser
get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser,version

get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser | format-list
get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser,version | format-table
get-wmiobject -class win32_operatingsystem | select pscomputername,caption,osarch*,registereduser,version | out-gridview
#endregion

#region r and scb
clear-host; write-output 'omg this is a long command that i would not want to type again but i sure would like to reproduce the output!'
r

clear-host; write-output 'now this is another command that i would not want to type'
r

get-alias r

r | scb

get-alias scb
#endregion

#region splatting
get-childitem -path 'c:\temp\demo' -Exclude test2.txt

$gciparams = @{'path'='c:\temp\demo'; 'exclude'='test2.txt'}
get-childitem @gciparams

1..3 | foreach-object {
    get-childitem @gciparams -depth $_ 
} #returns all the same data, but the depth was actually different... it's just an example

#this is going to fail because I don't have AD in this demo
$adusers = @('thomas','angela','matt','aman')
$adparams = @{'properties'='memberof'; 'searchbase'='ou=someou,dc=lab,dc=workingsysadmin,dc=ca'}

$adusers | foreach-object {
    get-aduser @adparams -identity $_
}
#endregion

#region .split() vs -split, also trim
$splitstring = 'this is an interesting string with the letters s and t all over the place'

$splitstring.split('s')
$splitstring.split('t')

$splitstring.split('st')
$splitstring -split 'st'

$splitstring.trim('iecht') #.trim() also takes an array of chars
#endregion

#region get-random min and max
-join (1..10 | % { get-random -Minimum 1 -Maximum 10 })

-join (1..250 | % { get-random -Minimum 1 -Maximum 2 })

-join (1..250 | % { get-random -Minimum 1 -Maximum 3 })
#endregion

#region -whatif and -confirm, $psdefaultparam
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

#region erroractionpreference confirmpreference
$erroractionpreference
$erroractionpreference = 'stop'
$erroractionpreference = 'silentlycontinue'
$erroractionpreference = 'continue'

new-item 'test1.txt'
new-item 'test1.txt' -ErrorAction 'ignore'

$ConfirmPreference
$ConfirmPreference = 'none'
$ConfirmPreference = 'high'
#endregion

#region push and pop location
push-location c:\temp
push-location c:\temp\demo
push-location c:\windows
push-location c:\temp\demo

get-location -stack

pop-location
#endregion

#region begin, process and end in foreach-object
$adusers
$adusers | foreach-object { write-output "$_ is a nice person" }

$adusers | foreach-object -begin { write-output 'the third line is false' } `
                          -process { write-output "$_ is a nice person" } `
                          -end { write-output 'the first line might be false too' } 
#endregion