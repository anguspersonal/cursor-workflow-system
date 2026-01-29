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
    Write-Host "[OK] Commands synced" -ForegroundColor Green
}

# Sync skills
# Handles both nested skill repositories (e.g., solid-skills/skills/) and direct skills
if (Test-Path "global\skills") {
    $skillItems = Get-ChildItem -Path "global\skills" -Directory -ErrorAction SilentlyContinue
    if ($skillItems) {
        foreach ($item in $skillItems) {
            $nestedSkillsPath = Join-Path $item.FullName "skills"
            if (Test-Path $nestedSkillsPath) {
                # Nested repository structure (e.g., solid-skills/skills/)
                Copy-Item -Path "$nestedSkillsPath\*" -Destination "$cursorPath\skills\" -Recurse -Force
                Write-Host "[OK] Skills from $($item.Name) synced" -ForegroundColor Green
            } else {
                # Direct skill structure
                Copy-Item -Path $item.FullName -Destination "$cursorPath\skills\" -Recurse -Force
                Write-Host "[OK] Skill $($item.Name) synced" -ForegroundColor Green
            }
        }
    } else {
        Write-Host "[WARN] No skills found" -ForegroundColor Yellow
    }
}

# Sync agents
if (Test-Path "global\agents") {
    Copy-Item -Path "global\agents\*" -Destination "$cursorPath\agents\" -Recurse -Force
    Write-Host "[OK] Agents synced" -ForegroundColor Green
}

# Sync MCP config
if (Test-Path "global\mcp.json") {
    Copy-Item -Path "global\mcp.json" -Destination "$cursorPath\mcp.json" -Force
    Write-Host "[OK] MCP config synced" -ForegroundColor Green
}

Write-Host "`nGlobal configs synced successfully!" -ForegroundColor Green
Write-Host "Do not forget to manually update User Rules in Cursor Settings!" -ForegroundColor Yellow
Write-Host "(See global/user-rules.md for your User Rules)" -ForegroundColor Yellow
