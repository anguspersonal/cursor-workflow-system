# Sync global RACS from my-cursor repo to ~/.cursor/

Write-Host "Syncing global Cursor configs..." -ForegroundColor Cyan

# Create directories if they don't exist
$cursorPath = Join-Path $env:USERPROFILE ".cursor"
New-Item -ItemType Directory -Force -Path "$cursorPath\commands" | Out-Null
New-Item -ItemType Directory -Force -Path "$cursorPath\skills" | Out-Null
New-Item -ItemType Directory -Force -Path "$cursorPath\agents" | Out-Null

# Sync commands
if (Test-Path "global\commands") {
    Copy-Item -Path "global\commands\*" -Destination "$cursorPath\commands\" -Recurse -Force
    Write-Host "✓ Commands synced" -ForegroundColor Green
}

# Sync skills
if (Test-Path "global\skills") {
    Copy-Item -Path "global\skills\*" -Destination "$cursorPath\skills\" -Recurse -Force
    Write-Host "✓ Skills synced" -ForegroundColor Green
}

# Sync agents
if (Test-Path "global\agents") {
    Copy-Item -Path "global\agents\*" -Destination "$cursorPath\agents\" -Recurse -Force
    Write-Host "✓ Agents synced" -ForegroundColor Green
}

# Sync MCP config
if (Test-Path "global\mcp.json") {
    Copy-Item -Path "global\mcp.json" -Destination "$cursorPath\mcp.json" -Force
    Write-Host "✓ MCP config synced" -ForegroundColor Green
}

Write-Host "`nGlobal configs synced successfully!" -ForegroundColor Green
Write-Host "Don't forget to manually update User Rules in Cursor Settings!" -ForegroundColor Yellow
Write-Host "(See global/user-rules.md for your User Rules)" -ForegroundColor Yellow
