#!/bin/bash
# Sync global RACS from my-cursor repo to ~/.cursor/

echo "Syncing global Cursor configs..."

# Create directories if they don't exist
mkdir -p ~/.cursor/commands ~/.cursor/skills ~/.cursor/agents

# Sync commands
if [ -d "global/commands" ]; then
    cp -r global/commands/* ~/.cursor/commands/
    echo "✓ Commands synced"
fi

# Sync skills
if [ -d "global/skills" ] && [ "$(ls -A global/skills)" ]; then
    cp -r global/skills/* ~/.cursor/skills/
    echo "✓ Skills synced"
fi

# Sync agents
if [ -d "global/agents" ] && [ "$(ls -A global/agents)" ]; then
    cp -r global/agents/* ~/.cursor/agents/
    echo "✓ Agents synced"
fi

# Sync MCP config
if [ -f "global/mcp.json" ]; then
    cp global/mcp.json ~/.cursor/mcp.json
    echo "✓ MCP config synced"
fi

echo ""
echo "✓ Global configs synced successfully!"
echo "⚠️  Don't forget to manually update User Rules in Cursor Settings!"
echo "    (See global/user-rules.md for your User Rules)"
