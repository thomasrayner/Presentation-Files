Find-Module -Name AstHelper -Repository PSGallery | select *


Get-Command -Module AstHelper


# Open Simple-Function.ps1, store path below
$simple = 'C:\Users\thomas\OneDrive\Documents\MVP\git\Presentation-Files\PSSA Custom Rule Crash Course\Simple-Function.ps1'


Get-Command -Name Get-AstType | select -expand Definition

Get-AstType -ScriptPath $simple


Get-Command -Name Get-AstObject | select -expand Definition

Get-AstObject -ScriptPath $simple -Type CommandAst
Get-AstObject -ScriptPath $simple -Type ParameterAst
$param = Get-AstObject -ScriptPath $simple -Type ParameterAst

$param
$param.Name
$param.Name.VariablePath
$param.Name.VariablePath.UserPath

$param
$param.Extent 

# change the commented out parameter in Simple-Function.ps1

$param = Get-AstObject -ScriptPath $simple -Type ParameterAst

$param 
$param.Attributes
$param.Attributes.NamedArguments



# Switch to, examine testfile.ps1
$complicated = 'C:\Users\thomas\OneDrive\Documents\MVP\git\Presentation-Files\PSSA Custom Rule Crash Course\More-Complicated.ps1'

Invoke-ScriptAnalyzer -Path $complicated


Get-AstType -ScriptPath $complicated 

Get-AstObject -ScriptPath $complicated -Type AttributeAst | select -first 1
Get-AstObject -ScriptPath $complicated -Type ParamBlockAst | select -first 1  | fl
Get-AstObject -ScriptPath $complicated -Type FunctionDefinitionAst | select -first 1
Get-AstObject -ScriptPath $complicated -Type ParameterAst | select -first 1


$params = Get-AstObject -ScriptPath $complicated -Type ParameterAst
$params

$params[0]
$params[0].Attributes
$params[0].Attributes.NamedArguments
$params[0].Attributes.NamedArguments.ArgumentName # Can we just detect off this? Hint, look at Mandatory. Think about Param3.


# Is ValueFromPipeline even present?
$params[0].attributes.namedarguments.argumentname.tolower().indexof('valuefrompipeline')
$params[5]
$params[5].attributes.namedarguments.argumentname.tolower().indexof('valuefrompipeline')

$params[6]
$params[6].attributes.namedarguments.argumentname.tolower().indexof('parametersetname')


# Three scenarios: implicit true, explicit true, explicit false.
$params[0].attributes.namedarguments
$vfpIndex = $params[0].attributes.namedarguments.argumentname.tolower().indexof('valuefrompipeline')
$params[0].attributes.namedarguments[$vfpIndex]
$params[0].attributes.namedarguments.argument[$vfpIndex]
$params[0].attributes.namedarguments.argument[$vfpIndex].Extent
$params[0].attributes.namedarguments.argument[$vfpIndex].Extent.Text

$vfpIndex = $params[1].attributes.namedarguments.argumentname.tolower().indexof('valuefrompipeline')
$params[1].attributes.namedarguments[$vfpIndex]
$params[1].attributes.namedarguments.argument[$vfpIndex]
$params[1].attributes.namedarguments.argument[$vfpIndex].Extent
$params[1].attributes.namedarguments.argument[$vfpIndex].Extent.Text

$vfpIndex = $params[2].attributes.namedarguments.argumentname.tolower().indexof('valuefrompipeline')
$params[2].attributes.namedarguments[$vfpIndex]
$params[2].attributes.namedarguments.argument[$vfpIndex]
$params[2].attributes.namedarguments.argument[$vfpIndex].Extent
$params[2].attributes.namedarguments.argument[$vfpIndex].Extent.Text

# Same thing for ParameterSetName
$paramsetIndex = $params[7].attributes.namedarguments.argumentname.tolower().indexof('parametersetname')
$params[7].attributes.namedarguments[$paramsetIndex]
$params[7].attributes.namedarguments.argument[$paramsetIndex]
$params[7].attributes.namedarguments.argument[$paramsetIndex].Extent
$params[7].attributes.namedarguments.argument[$paramsetIndex].Extent.Text

$vfpIndex = $params[7].attributes.namedarguments.argumentname.tolower().indexof('valuefrompipeline') # Need this

$evaluate = [pscustomobject]@{ 
    'ParamaterName' = $params[7].Name.VariablePath.UserPath
    'ValueFromPipeline' = $params[7].attributes.namedarguments.argument[$vfpIndex].Extent.Text
    'ParamaterSetName' = $params[7].attributes.namedarguments.argument[$paramsetIndex].Extent.Text
}
$evaluate

# Can we make it into a PSSA rule yet?