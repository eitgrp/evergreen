Function Get-PDFForgePDFCreator {
    <#
        .SYNOPSIS
            Get the current version and download URL for PDFForge PDFCreator.

        .NOTES
            Site: https://stealthpuppy.com
            Author: Aaron Parker
            Twitter: @stealthpuppy
    #>
    [OutputType([System.Management.Automation.PSObject])]
    [CmdletBinding(SupportsShouldProcess = $False)]
    param (
        [Parameter(Mandatory = $False, Position = 0)]
        [ValidateNotNull()]
        [System.Management.Automation.PSObject]
        $res = (Get-FunctionResource -AppName ("$($MyInvocation.MyCommand)".Split("-"))[1]),

        [Parameter(Mandatory = $False, Position = 1)]
        [ValidateNotNull()]
        [System.String] $Filter
    )

    # Get latest version and download latest release via SourceForge API
    # Convert the returned release data into a useable object with Version, URI etc.
    $params = @{
        Uri          = $res.Get.Update.Uri
        Download     = $res.Get.Download
        MatchVersion = $res.Get.MatchVersion
    }
    $object = Get-SourceForgeRepoRelease @params
    Write-Output -InputObject $object
}
