[CmdletBinding()]
param (
    # How far back in days you want to search, this is in 24 hour increments from the time it executes
    [Parameter(Mandatory = $false)]
    [int]
    $Days
)

begin {
    function Test-IsElevated {
        $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $p = New-Object System.Security.Principal.WindowsPrincipal($id)
        if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
        { Write-Output $true }
        else
        { Write-Output $false }
    }

    function Delete-User {
        param (
            [string]$UserName
        )
        # Add code here to delete the user account
        Write-Output "Deleting user: $UserName"
        # Example command to delete user account
        # Remove-LocalUser -Name $UserName
    }

    # System accounts that we don't want
    $SystemUsers = @(
        "SYSTEM"
        "NETWORK SERVICE"
        "LOCAL SERVICE"
    )
    # Filter for only getting session start and stop events from Security event log
    $FilterHashtable = @{
        LogName = "Security";
        id      = 4634, 4624
    }
    # If Days was specified then add this parameter
    if ($Days) {
        $FilterHashtable.Add("EndTime", (Get-Date).AddDays(-$Days))
    }
    # Creating a hash table for parameter splatting
    $Splat = @{
        FilterHashtable = $FilterHashtable
    }
}

process {
    if (-not (Test-IsElevated)) {
        Write-Error -Message "Access Denied. Please run with Administrator privileges."
        exit 1
    }
    # Get windows events, filter out everything but logins and logouts(Session starts and ends)
    Get-WinEvent @Splat | ForEach-Object {
        # UserName in the two event types are in different places in the Properties array
        if ($_.Id -eq 4634) {
            # Events with ID 4634 the user name is the second item in the array. Arrays start at 0 in PowerShell.
            $User = $_.Properties[1].Value
        }
        else {
            # Events with ID 4634 the user name is the sixth item in the array. Arrays start at 0 in PowerShell.
            $User = $_.Properties[5].Value
        }

        # Filter out system accounts and computer logins(Active Directory related)
        # DWM-0  = Desktop Window Manager
        # UMFD-0 = User Mode Framework Driver
        if ($SystemUsers -notcontains $User -and $User -notlike "DWM-*" -and $User -notlike "UMFD-*" -and $User -notlike "*$") {
            # Write out to StandardOutput
            [PSCustomObject]@{
                Time  = $_.TimeCreated
                Event = if ($_.Id -eq 4634) { "SessionStop" } else { "SessionStart" }
                User  = $User
                ID    = $_.ID
            }

            # If it's a session start event and the session started more than specified days ago, delete the user
            if ($_.Id -eq 4624 -and $Days -and $_.TimeCreated -lt (Get-Date).AddDays(-$Days)) {
                Delete-User -UserName $User
            }
        }
        # Null $User just in case the next loop iteration doesn't set it, we can then see that the user name is missing
        $User = $null
    }
}
