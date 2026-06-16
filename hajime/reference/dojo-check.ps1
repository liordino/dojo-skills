# dojo-check — PowerShell variant of the canonical template (hajime SKILL.md section 3).
# Same contract, same proof artifact. Swap ONLY the three stack commands.
# Bash remains canonical; keep this in sync when the canonical contract changes.
$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force -Path .dojo | Out-Null
Remove-Item .dojo/check-output.log -ErrorAction Ignore

function Run([string]$cmd) {
  Invoke-Expression $cmd 2>&1 | Tee-Object -FilePath .dojo/check-output.log -Append
  if ($LASTEXITCODE -ne 0) { exit 1 }
}

Run 'cargo build'
Run 'cargo clippy -- -D warnings'
Run 'cargo test'

# Reached only if every check passed:
$sha = (Get-FileHash .dojo/check-output.log -Algorithm SHA256).Hash.ToLower()
@(
  "ts=$([DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'))"
  "exit=0"
  "output_sha256=$sha"
) | Set-Content .dojo/check-proof
