#region Come on man
throw "You're not supposed to hit F5"
#endregion


# Ever done something like this?
$arrayOfStuff = @( 'somethingone', 'somethingtwo', 'noway' )
$arrayofStuff | Where-Object { $_ -match 'something' }

# How about this?
'somethingone' -match 'something'
'somethingone' -match 'pickles'

'Here is a simple string.' -replace 'simple string', 'string that got something replaced'



# Quantifiers
'something.txt' -match 's*omething.txt'
'something.txt' -match 'q*omething.txt'
'omething.txt' -match 'q*omething.txt'

'something.txt' -match 's+omething.txt'
'something.txt' -match 'q+omething.txt'
'omething.txt' -match 's+omething.txt'
'omething.txt' -match 'q+omething.txt'

'something.txt' -match 's?omething.txt'
'something.txt' -match 'q?omething.txt'
'omething.txt' -match 's?omething.txt'
'omething.txt' -match 'q?omething.txt'


# Special characters
'something' -match 'some.hing'

@"
This is some multi
line text
"@ -match '\n'
'no new line' -match '\n'

'123' -match '\d'
'no numbers here' -match '\d'

'123' -match '\D'
'no numbers here' -match '\D'

'hello123' -match '\w'
'hello123' -match '\W'
'---' -match '\w'
'---' -match '\W'

'whitespace is here' -match '\s'
'butnothere' -match '\s'

'     ' -match '\S'

'\\path\with\slashes' -match '\slashes'
'\\path\with lashes' -match '\slashes'
'\\path\with\slashes' -match '\\slashes'

# More than just these, like ^ and $, \b
'some value' -match 'value$'
'some value again' -match 'value$'


# Brackets
'something123' -match '\d{3}'
'something123' -match '\d{10}'
'something123' -match '\d{2,4}'
'something123' -match '\d{2,}'

'hello123hello123hello123' -match '(hello123){3}'

'hello123hello123 something else' -match '(hello123){1,4}\s?something'
'hello123hello123something else' -match '(hello123){1,4}\s?something'
'hello123hello999 something else' -match '(hello123){1,4}\s?something'

'192.168.1.1' -match '(\d{1,3}\.){3}\d{1,3}'
'1,200,859' -match '(\d{1,3}\.){3}\d{1,3}'

'something' -match '[fgh]$'
'something' -match '[f-q]$'
'something' -match '[h-q]$'

'something' -match '[^qrs]$'
'something' -match '[^gh]$'



# Getting the matched value
'domain\username' -replace '\w+\\',''
'domain\username' -replace '.*\\',''

[regex]::Matches('domain\username', '\w+$')
[regex]::Matches('domain\username', '\w+$').Value

[regex]::Matches('domain\username', '[^\\]+$').Value

