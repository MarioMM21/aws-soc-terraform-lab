# bulk_users.ps1 — creates 100 users in lab.local
Import-Module ActiveDirectory

$password = ConvertTo-SecureString "Password1!" -AsPlainText -Force
$ou = "OU=LabUsers,DC=lab,DC=local"

$departments = @("IT","HR","Finance","Sales","Operations")

1..100 | ForEach-Object {
    $num      = $_.ToString("000")
    $first    = "User"
    $last     = "Lab$num"
    $username = "user.lab$num"
    $dept     = $departments[($_ % 5)]

    New-ADUser `
        -GivenName       $first `
        -Surname         $last `
        -Name            "$first $last" `
        -SamAccountName  $username `
        -UserPrincipalName "$username@lab.local" `
        -Path            $ou `
        -Department      $dept `
        -AccountPassword $password `
        -Enabled         $true `
        -PasswordNeverExpires $true
}

Write-Host "Done. 100 users created in OU=LabUsers"