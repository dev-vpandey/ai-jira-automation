# Epic Input Template

## Required Fields
- **epic_name**: Short identifier (e.g., "AI-REC-ENGINE")
  - Format: UPPERCASE-WITH-HYPHENS
  - Max 50 chars
  
- **summary**: Epic title (e.g., "AI-Powered Recommendation Engine")
  - Min 10 chars, max 255 chars
  - Start with capital letter

## Optional Fields
- **overview**: High-level description
- **business_value**: Why this matters, ROI, impact
- **goals**: What you want to achieve (bullet list)
- **success_criteria**: Measurable outcomes (bullet list)
- **scope_in**: What's included
- **scope_out**: What's excluded
- **dependencies**: Prerequisites or blockers
- **timeline**: Start/end dates, duration
- **stakeholders**: Product owner, tech lead, etc.
- **priority**: P0|P1|P2|P3|Unprioritized (default: P1)
  - P0 = Critical/Blocker
  - P1 = High (default)
  - P2 = Medium
  - P3 = Low
- **component**: Component name (default: DATA-BFRM)
  - DATA-BFRM = Bangalore Framework (default)
  - DATA-INFRA = Infrastructure
  - DATA-PIPE = Data Pipeline
  - DATA-QUAL = Data Quality
- **labels**: Comma-separated (default: "ai-generated,epic")

## Example Input

```
epic_name: AI-REC-ENGINE
summary: AI-Powered Recommendation Engine
overview: Build ML-based recommendation system to improve product suggestions
business_value: Increase CTR by 25%, revenue impact $2M annually
goals: 
  - Improve recommendation accuracy
  - Reduce latency to <100ms
  - Scale to 10x traffic
success_criteria:
  - 25% increase in CTR
  - <100ms p95 latency
  - Handle 1M+ requests/day
priority: P1
component: DATA-BFRM
```

## Command Format

```bash
create_epic \
  "AI-Powered Recommendation Engine" \
  "AI-REC-ENGINE" \
  "Build ML-based recommendation system..." \
  "P1" \
  "DATA-BFRM" \
  "ai-generated,ml,recommendation"
```
