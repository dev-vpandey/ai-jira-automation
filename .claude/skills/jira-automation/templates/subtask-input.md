# Subtask Input Template

## Required Fields
- **summary**: Task title (e.g., "Write unit tests for auth service")
  - Min 10 chars, max 255 chars
  - Specific, actionable

- **parent**: Parent story key (e.g., "DATA-12346")
  - Format: PROJECT-NUMBER

## Optional Fields
- **description**: What needs to be done
- **objective**: Specific goal of this task
- **implementation_steps**: Numbered steps (list)
- **definition_of_done**: Checklist items (list)
- **files**: Files to create/modify (list)
- **testing_requirements**: How to test
- **estimated_effort**: Time estimate
- **priority**: P0|P1|P2|P3|Unprioritized (default: P1)
- **component**: Component name (default: DATA-BFRM)
- **labels**: Comma-separated (default: "ai-generated,subtask")

## Example Input

```
summary: Set up Kafka cluster infrastructure
parent: DATA-12346
description: Deploy production Kafka cluster with 3 brokers
objective: Production-ready Kafka cluster for data ingestion
implementation_steps:
  1. Provision 3 EC2 instances
  2. Install Kafka 3.x
  3. Configure ZooKeeper ensemble
  4. Set up monitoring
  5. Run load tests
definition_of_done:
  - Kafka cluster running with 3 brokers
  - ZooKeeper ensemble operational
  - Monitoring dashboards configured
  - Load test passed (100k msgs/sec)
  - Documentation updated
files:
  - /infrastructure/kafka/terraform/main.tf
  - /infrastructure/kafka/config/server.properties
  - /docs/kafka-setup.md
estimated_effort: 2 days
priority: P1
component: DATA-BFRM
```

## Command Format

```bash
create_subtask \
  "Set up Kafka cluster infrastructure" \
  "Deploy production Kafka cluster..." \
  "DATA-12346" \
  "P1" \
  "DATA-BFRM" \
  "ai-generated,infrastructure"
```
