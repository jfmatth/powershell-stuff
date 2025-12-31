function env {
    Get-ChildItem Env: | ForEach-Object { "$($_.Name)=$($_.Value)" }
}
Export-ModuleMember -Function env

function Get-PortProcess {
    param(
        [Parameter(Mandatory)]
        [int]$Port
    )

    $conn = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    if (-not $conn) {
        Write-Host "No process is listening on port $Port"
        return
    }

    $proc = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue

    [PSCustomObject]@{
        Port         = $Port
        State        = $conn.State
        PID          = $conn.OwningProcess
        ProcessName  = $proc.Name
        Path         = $proc.Path
    }

}
Export-ModuleMember -Function Get-PortProcess

function wget {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [string]$OutFile
    )

    if (-not $OutFile) {
        $OutFile = Split-Path -Leaf $Url
    }

    Invoke-WebRequest -Uri $Url -OutFile $OutFile

}
Export-ModuleMember -Function wget

function build {
    # build a podman image on Windows

    param(
        [string]$ImageName,
        [switch]$Push   
    )

    # Ensure script stops on errors
    $ErrorActionPreference = "Stop"

    $imagefile = "./IMAGE"

    if (Test-Path $imagefile) {
        # REPO EXISTS, use it's content for the variable
        $ImageName = Get-Content -Raw -Path $imagefile
    } elseif (-not $ImageName) {
        Write-Error "No Repository and File REPO doesn't exist"
        exit 1
    }

    if (-Not (Test-Path "./VERSION")) {
        Write-Error "VERSION file not found in current directory."
        exit 1
    }
    $version = Get-Content -Path "./VERSION" -Raw
    $version = $version.Trim()

    if ([string]::IsNullOrWhiteSpace($version)) {
        Write-Error "VERSION file is empty or invalid."
        exit 1
    }

    if ((podman machine inspect | ConvertFrom-Json).State -ne "Running") {
        podman machine start
    }

    Write-Host "Using version tag: $version"

    # Step 2: Build the main image from Dockerfile
    Write-Host "Building main image $ImageName"
    podman build `
        --file Dockerfile `
        --no-cache `
        --tag "$($imageName):$version" `
        --tag "$($ImageName):latest" `
        .

    if ($Push) {
        Write-Host "Pushing..."
        podman push "$($imageName):$version" 
        podman push "$($imageName):latest"
    }

    Write-Host "✅ Build complete. Images tagged as:"

}

Export-ModuleMember -Function build