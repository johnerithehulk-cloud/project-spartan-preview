# Project Spartan: Windows deployment (review-first)
# Run from the folder containing index.html and icons/.
# Requires Git and GitHub CLI, authenticated with 'gh auth login'.
$ErrorActionPreference = 'Stop'
$repo = 'johnerithehulk-cloud/project-spartan-preview'
$files = @('index.html','manifest.webmanifest','sw.js','.nojekyll','icons/icon-192.png','icons/icon-512.png')
$source = (Get-Location).Path
foreach ($file in $files) {
  if (-not (Test-Path -LiteralPath (Join-Path $source $file) -PathType Leaf)) {
    throw "Missing required file: $file"
  }
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Git is required.' }
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw 'GitHub CLI is required.' }
& gh auth status
if ($LASTEXITCODE -ne 0) { throw 'Sign in locally with gh auth login. Never paste credentials into chat.' }
$temp = Join-Path ([System.IO.Path]::GetTempPath()) ('spartan-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $temp | Out-Null
try {
  $clone = Join-Path $temp 'repo'
  & gh repo clone $repo $clone
  if ($LASTEXITCODE -ne 0) { throw 'Clone failed.' }
  Push-Location $clone
  try {
    $status = & git status --porcelain
    if ($LASTEXITCODE -ne 0 -or $status) { throw 'Repository is not clean.' }
    foreach ($file in $files) {
      $destination = Join-Path $clone $file
      $parent = Split-Path $destination -Parent
      New-Item -ItemType Directory -Path $parent -Force | Out-Null
      Copy-Item -LiteralPath (Join-Path $source $file) -Destination $destination -Force
    }
    & git add -- $files
    if ($LASTEXITCODE -ne 0) { throw 'Staging failed.' }
    & git diff --cached --check
    if ($LASTEXITCODE -ne 0) { throw 'Whitespace or patch errors found.' }
    & git diff --cached --stat
    & git diff --cached --name-only
    $answer = Read-Host 'Upload only these public app files? Type DEPLOY'
    if ($answer -cne 'DEPLOY') { Write-Host 'Canceled. Nothing pushed.'; return }
    & git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) { Write-Host 'Already up to date. Nothing to commit.'; return }
    & git commit -m 'Deploy Project Spartan v5.7 public PWA'
    if ($LASTEXITCODE -ne 0) { throw 'Commit failed.' }
    & git push
    if ($LASTEXITCODE -ne 0) { throw 'Push failed. No deployment claimed.' }
    Write-Host 'Push succeeded. Enable GitHub Pages in Settings > Pages and test on iPhone.'
  } finally { Pop-Location }
} finally { Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue }
