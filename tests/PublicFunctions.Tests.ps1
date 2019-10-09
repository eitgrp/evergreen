<#
    .SYNOPSIS
        Public Pester function tests.
#>
[OutputType()]
Param ()

# Set variables
If (Test-Path "env:APPVEYOR_BUILD_FOLDER") {
    # AppVeyor Testing
    $projectRoot = Resolve-Path -Path $env:APPVEYOR_BUILD_FOLDER
    $module = $env:Module
}
Else {
    # Local Testing 
    $projectRoot = Resolve-Path -Path (((Get-Item (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)).Parent).FullName)
    $module = Split-Path -Path $projectRoot -Leaf
}
$moduleParent = Join-Path -Path $projectRoot -ChildPath $module
$manifestPath = Join-Path -Path $moduleParent -ChildPath "$module.psd1"
# $modulePath = Join-Path -Path $moduleParent -ChildPath "$module.psm1"

# Import module
Write-Host ""
Write-Host "Importing module." -ForegroundColor Cyan
Import-Module $manifestPath -Force

# Read module resource strings for testing
. "$moduleParent\Private\Test-PSCore.ps1"
. "$moduleParent\Private\Get-ModuleResource.ps1"
. "$moduleParent\Private\ConvertTo-Hashtable.ps1"
$ResourceStrings = Get-ModuleResource -Path "$moduleParent\Evergreen.json"

InModuleScope Evergreen {
    Describe -Tag "AppVeyor" -Name "Test" {

            Context "Validate" {
                It "Returns an array" {
                    ($Output | Measure-Object).Count | Should -BeGreaterThan 0
                }
                It "Returns the expected output" {
                    $Output | Should -BeOfType ((Get-Command Command).OutputType.Type.Name)
                }
            }
    }
}
