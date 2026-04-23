# Story Input Template

## Required Fields
- **summary**: Story title (e.g., "Implement OAuth2 authentication")
  - Min 10 chars, max 255 chars
  - Action-oriented, clear

## Optional Fields
- **user_type**: Role (e.g., "data analyst", "end user")
- **goal**: What user wants (I want to...)
- **benefit**: Value/benefit (So that...)
- **description**: Detailed explanation
- **acceptance_criteria**: Given-When-Then format (bullet list)
- **technical_requirements**: Tech specs (bullet list)
- **testing_strategy**: How to test
- **epic_link**: Link to epic (e.g., "DATA-12345")
  - **If not specified**: System will search active epics in DATA-BFRM
  - **Suggests closest match**: Based on story summary and epic names
  - **Shows list**: User can select from active epics or skip
- **story_points**: Estimation (1,2,3,5,8,13,21)
- **priority**: P0|P1|P2|P3|Unprioritized (default: P1)
- **component**: Component name (default: DATA-BFRM)
- **labels**: Comma-separated (default: "ai-generated,story")

## Example Input

```
summary: Implement real-time data ingestion layer
user_type: data engineer
goal: ingest data in real-time from multiple sources
benefit: downstream analytics can access fresh data within minutes
description: Build streaming ingestion using Kafka
acceptance_criteria:
  - Given: Multiple data sources
    When: Data is published
    Then: Ingested within 2 minutes
  - Given: Message arrives
    When: Schema validation runs
    Then: Invalid messages go to DLQ
technical_requirements:
  - Apache Kafka 3.x cluster
  - Schema Registry
  - Monitoring dashboards
epic_link: DATA-12345
story_points: 8
priority: P1
component: DATA-BFRM
```

## Command Format

```bash
create_story \
  "Implement real-time data ingestion layer" \
  "Build streaming ingestion using Kafka..." \
  "DATA-12345" \
  "P1" \
  "DATA-BFRM" \
  "8" \
  "ai-generated,kafka,streaming"
```
