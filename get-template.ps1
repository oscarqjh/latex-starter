Param(
    [Parameter(Position=0)] [string] $TemplateName,
    [Parameter(Position=1)] [string] $DestinationDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Cross-platform PowerShell installer for LaTeX templates from this repo.
# Usage (Windows PowerShell):
#   iwr https://raw.githubusercontent.com/oscarqjh/latex-starter/main/get-template.ps1 -UseBasicParsing | iex
#   get-template.ps1 -TemplateName conference-paper -DestinationDir MyPaper
# Or one-liner to run directly:
#   iwr https://raw.githubusercontent.com/oscarqjh/latex-starter/main/get-template.ps1 -UseBasicParsing | iex; get-template -TemplateName conference-paper

function Write-Err([string] $Msg) { Write-Host "[get-template] $Msg" -ForegroundColor Red }

$OwnerRepo   = $env:OWNER_REPO; if ([string]::IsNullOrWhiteSpace($OwnerRepo)) { $OwnerRepo = 'oscarqjh/latex-starter' }
$Branch      = $env:BRANCH; if ([string]::IsNullOrWhiteSpace($Branch)) { $Branch = 'main' }
$TemplatesDir= $env:TEMPLATES_DIR; if ([string]::IsNullOrWhiteSpace($TemplatesDir)) { $TemplatesDir = 'templates' }

$ApiBase = "https://api.github.com/repos/$OwnerRepo"
$RawBase = "https://raw.githubusercontent.com/$OwnerRepo/$Branch"

function Invoke-Json([string] $Url) {
    $headers = @{ 'User-Agent' = 'get-template.ps1' }
    (Invoke-WebRequest -Uri $Url -Headers $headers -UseBasicParsing).Content | ConvertFrom-Json
}

function Get-TemplateNames() {
    $url = "$ApiBase/contents/${TemplatesDir}?ref=$Branch"
    $items = Invoke-Json $url
    $items | Where-Object { $_.type -eq 'dir' } | ForEach-Object { $_.name }
}

function Select-TemplateInteractive() {
    $names = @(Get-TemplateNames)
    if ($names.Count -eq 0) { Write-Err "No templates found under '$TemplatesDir' in $OwnerRepo@$Branch."; exit 1 }
    Write-Host "Available templates (from $OwnerRepo/$TemplatesDir):" -ForegroundColor Cyan
    for ($i=0; $i -lt $names.Count; $i++) { Write-Host ("  {0,2}) {1}" -f ($i+1), $names[$i]) }
    while ($true) {
        $choice = Read-Host 'Enter a number to select a template'
        if ($choice -match '^[0-9]+$') {
            $idx = [int]$choice - 1
            if ($idx -ge 0 -and $idx -lt $names.Count) { return $names[$idx] }
        }
        Write-Err "Invalid choice. Enter a number between 1 and $($names.Count)."
    }
}

function Get-Template-TreePaths([string] $Template) {
    $url = "$ApiBase/git/trees/$Branch?recursive=1"
    $tree = Invoke-Json $url
    $prefix = "$TemplatesDir/$Template/"
    $tree.tree | Where-Object { $_.type -eq 'blob' -and $_.path.StartsWith($prefix) } | ForEach-Object { $_.path }
}

function Download-Template([string] $Template, [string] $DestDir) {
    $paths = @(Get-Template-TreePaths -Template $Template)
    if ($paths.Count -eq 0) { Write-Err "No files found for template '$Template'."; exit 1 }
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
    $basePrefix = "$TemplatesDir/$Template/"
    foreach ($p in $paths) {
        $rel = $p.Substring($basePrefix.Length)
        $target = Join-Path $DestDir $rel
        $targetDir = Split-Path $target -Parent
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        $url = "$RawBase/$p"
        Write-Host "Downloading $url -> $target"
        Invoke-WebRequest -Uri $url -OutFile $target -UseBasicParsing
    }
    Write-Host "`nTemplate '$Template' downloaded to '$DestDir'." -ForegroundColor Green
    Write-Host "Next steps:`n  - Open '$DestDir' in your LaTeX editor`n  - Compile to produce a PDF"
}

function get-template {
    Param(
        [Parameter(Position=0)] [string] $Template,
        [Parameter(Position=1)] [string] $Dest
    )
    if ([string]::IsNullOrWhiteSpace($Template)) { $Template = Select-TemplateInteractive }
    if ([string]::IsNullOrWhiteSpace($Dest)) { $Dest = $Template }
    if ($Template -match '\\\\|/|\.\.') { Write-Err 'Invalid template name.'; exit 1 }
    Download-Template -Template $Template -DestDir $Dest
}

if ($MyInvocation.InvocationName -eq '.') {
    # Script was dot-sourced; export function only
    return
}

# If run directly, call the function with parameters
get-template -Template $TemplateName -Dest $DestinationDir


