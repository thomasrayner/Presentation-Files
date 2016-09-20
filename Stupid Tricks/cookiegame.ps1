if ($psversiontable.psversion.Major -lt 5)  { throw 'You need at least PowerShell v5.0 to play the Cookie Game' }

enum CookieLocation
{
   Forehead = 1
   Eyes = 2
   Nose = 3 
   Cheek = 4
   Chin = 5
   Mouth = 6
   Floor = 7
}

$cookieattrs = @{'brand'='Oreo';'stuffing'='double';'special'=$false}
$cookie = New-Object -TypeName pscustomobject -Property $cookieattrs
$cookie | Add-Member -MemberType NoteProperty -Name 'location' -value $([CookieLocation]::Forehead)

'Playing the COOKIE GAME with an {0} stuffed {1} brand cookie. Is it a golden or birthday cake or some other flavored {1} cookie: {2}.'  -f $cookie.stuffing, $cookie.brand, $cookie.special

function Roll-Cookie
{
    param($rolledcookie)
    $newlocation = get-random $([enum]::getvalues([type]'CookieLocation'))
    $rolledcookie.location = $newlocation
}

do
{
    Roll-Cookie $cookie
    'The {0} stuffed {1} brand cookie is now on your {2}' -f $cookie.stuffing, $cookie.brand, $cookie.location
    start-sleep 1
}
while ($cookie.location.value__ -lt 6)

if ($cookie.location.value__ -eq 6)
{
    'Game over! Cookie ended up in your mouth. Munch that thing like a winner. You earned it.'
}
else
{
    'You lost. The cookie hit the floor. Now take this time to let your failure sink in before you try again. Try not to waste the next cookie.'
}