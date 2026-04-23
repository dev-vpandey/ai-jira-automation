# Outputs Directory

This directory stores JSON audit trails when issues are created.

## Generated Files

When you run `src/jira-auto` commands, output files are created:

- `epic-<timestamp>.json` - Epic creation details
- `story-<timestamp>.json` - Story creation details  
- `subtask-<timestamp>.json` - Subtask creation details

## File Format

```json
{
  "issue_key": "DATA-12345",
  "issue_type": "Epic",
  "created_at": "2026-04-08 14:30:00",
  "summary": "...",
  "url": "https://jira.example.com/browse/DATA-12345"
}
```

## Note

Output files are `.gitignore`d to keep your repository clean. Only example/template outputs should be committed.
