# Plan Parsing Guide

## How to Extract Issues from Implementation Plans

### 1. Identify Issue Types

**Epics** - High-level initiatives:
- Keywords: "Epic:", "Initiative:", "Project:", "Phase:", top-level `#` headers
- Characteristics: Broad scope, multiple months, multiple teams
- Example: "Epic: Data Pipeline Modernization"

**Stories** - Features/Requirements:
- Keywords: "Story:", "Feature:", "Requirement:", `##` headers under epics
- Characteristics: 1-2 week work, single team, user-facing value
- Example: "Story: Implement real-time data ingestion"

**Subtasks** - Implementation Tasks:
- Keywords: "Task:", "TODO:", bullet points under stories, `###` headers
- Characteristics: 1-3 days work, specific technical tasks
- Example: "Set up Kafka cluster infrastructure"

### 2. Extraction Patterns

```markdown
# Epic Title
Overview: ...
Goals: ...

## Story 1
Description: ...
Acceptance Criteria: ...

### Subtask 1.1
Implementation: ...

### Subtask 1.2
Implementation: ...

## Story 2
...
```

Maps to:
```
Epic (from # header)
├── Story 1 (from ## header)
│   ├── Subtask 1.1 (from ### header)
│   └── Subtask 1.2
└── Story 2
```

### 3. Field Extraction

**From Epic Section:**
- Title → summary
- First paragraph → overview
- "Business Value:" → business_value
- "Goals:" list → goals
- "Success Criteria:" list → success_criteria

**From Story Section:**
- Title → summary
- "As a... I want... So that..." → user_story (user_type, goal, benefit)
- "Acceptance Criteria:" → acceptance_criteria
- "Technical Requirements:" → technical_requirements

**From Subtask Section:**
- Title → summary
- Description → description
- Numbered list → implementation_steps
- Checklist → definition_of_done

### 4. Creation Order

1. **Create Epics First**
   - Extract all epic-level sections
   - Create each epic
   - Store epic keys (e.g., DATA-123)

2. **Create Stories Second**
   - Extract story sections under each epic
   - Link to parent epic using epic_link
   - Store story keys (e.g., DATA-124, DATA-125)

3. **Create Subtasks Last**
   - Extract subtask sections under each story
   - Link to parent story using parent field
   - Store subtask keys

### 5. Linking Strategy

```
Epic: DATA-123
├── Story: DATA-124 (epic_link: DATA-123)
│   ├── Subtask: DATA-126 (parent: DATA-124)
│   └── Subtask: DATA-127 (parent: DATA-124)
└── Story: DATA-125 (epic_link: DATA-123)
    ├── Subtask: DATA-128 (parent: DATA-125)
    └── Subtask: DATA-129 (parent: DATA-125)
```

### 6. Example Plan Structure

```markdown
# Implementation Plan: AI Recommendation Engine

## Epic: AI-Powered Recommendations

### Overview
Build ML-based recommendation system

### Business Value
- Increase CTR by 25%
- Revenue impact: $2M annually

### Goals
1. Improve accuracy
2. Reduce latency
3. Scale to 10x

---

## Story 1: Implement Recommendation Algorithm

**As a** product manager
**I want** personalized recommendations
**So that** users see relevant products

**Acceptance Criteria:**
- Given user history, when requesting recommendations, then return personalized results
- Algorithm achieves >20% CTR improvement

**Technical Requirements:**
- Python ML service
- Feature store integration
- Real-time inference

### Subtask 1.1: Train ML Model
- Collect training data
- Feature engineering
- Model training and validation

### Subtask 1.2: Build Inference Service
- REST API endpoint
- Model serving infrastructure
- Monitoring setup

---

## Story 2: Create API Endpoints

[Story details...]

### Subtask 2.1: ...
### Subtask 2.2: ...
```

### 7. Extraction Result

From above plan, extract:

**Epic:**
```
epic_name: AI-REC-ENGINE
summary: AI-Powered Recommendations
overview: Build ML-based recommendation system
business_value: Increase CTR by 25%, revenue impact $2M annually
goals: Improve accuracy, reduce latency, scale to 10x
```

**Story 1:**
```
summary: Implement Recommendation Algorithm
user_type: product manager
goal: personalized recommendations
benefit: users see relevant products
acceptance_criteria: [extracted from AC section]
technical_requirements: [extracted from TR section]
epic_link: [epic key from previous step]
```

**Subtasks under Story 1:**
```
Subtask 1.1:
  summary: Train ML Model
  parent: [story 1 key]
  steps: Collect training data, Feature engineering, Model training
  
Subtask 1.2:
  summary: Build Inference Service
  parent: [story 1 key]
  steps: REST API endpoint, Model serving, Monitoring
```

### 8. Best Practices

- ✅ Preserve hierarchy from plan structure
- ✅ Extract all relevant details from sections
- ✅ Create issues in dependency order
- ✅ Link everything properly
- ✅ Use descriptive, action-oriented titles
- ✅ Include all acceptance criteria and DoD items
- ❌ Don't create duplicate issues
- ❌ Don't skip linking steps
- ❌ Don't lose context from plan
