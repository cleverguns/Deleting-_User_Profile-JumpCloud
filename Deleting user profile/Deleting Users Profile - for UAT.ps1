# Define the number of days thresholdsss
$ThresholdDays = 14
# Calculate the threshold date
$ThresholdDate = (Get-Date).AddDays(-$ThresholdDays)
# Get a list of all user profiles on the system
$UserProfiles = Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false }  # Exclude special profiles like "admin" and "default"
# Initialize an array to store user profiles to delete
$ProfilesToDelete = @()
# Iterate through each user profile and determine whether to delete it
foreach ($profile in $UserProfiles) {
    $lastLogon = $profile.LastUseTime
    # Check if the user profile hasn't been used in the threshold period
    if ($lastLogon -lt $ThresholdDate) {
        $ProfilesToDelete += $profile
    }
}
# Output the results
if ($ProfilesToDelete.Count -gt 0) {
    Write-Output "User profiles to be deleted:"
    $ProfilesToDelete | ForEach-Object { $_.LocalPath }
    Write-Output ""
    # Delete user profiles
    foreach ($profile in $ProfilesToDelete) {
        $profileDir = $profile.LocalPath
        try {
            if (Test-Path $profileDir) {
                Remove-Item -Path $profileDir -Force -Recurse -ErrorAction Stop
                Write-Output "Deleted user profile: $profileDir"
                # Introduce a short delay to ensure the deletion has completed
                Start-Sleep -Seconds 3
                # Check if the user profile directory still exists
                if (-not (Test-Path $profileDir)) {
                    Write-Output "User profile directory $profileDir successfully deleted."
                } else {
                    Write-Output "Failed to delete user profile directory $profileDir."
                }
            } else {
                Write-Output "User profile directory $profileDir not found."
            }
        } catch {
            Write-Error "Error deleting user profile: $profileDir. Error: $_"
        }
    }
    Write-Output "User profiles deleted."
} else {
    Write-Output "No user profiles to delete."
}

<#
with actual deletion

#>
