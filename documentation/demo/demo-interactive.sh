#!/bin/bash

# ============================================================================
# JIRA Automation - Interactive Demo Script
# ============================================================================
# This script provides an interactive guided demo of the JIRA automation system
# Shows all features with real examples and minimal user input
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Demo configuration
DEMO_MODE=${DEMO_MODE:-true}
CREATE_REAL_ISSUES=${CREATE_REAL_ISSUES:-false}
# Load shell utilities for cross-shell compatibility
source "$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)/../../src/scripts/lib/shell-utils.sh"
SCRIPT_DIR=$(get_script_dir)
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Source libraries if creating real issues
if [ "$CREATE_REAL_ISSUES" = true ]; then
    source "$SCRIPT_DIR/lib/jira-api.sh" 2>/dev/null || true
fi

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo ""
    echo -e "${BOLD}${CYAN}============================================================================${NC}"
    echo -e "${BOLD}${WHITE}$1${NC}"
    echo -e "${BOLD}${CYAN}============================================================================${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${PURPLE}▶ $1${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_step() {
    echo -e "${BOLD}${WHITE}$1${NC}"
}

print_code() {
    echo -e "${YELLOW}$1${NC}"
}

print_result() {
    echo -e "${GREEN}$1${NC}"
}

pause() {
    if [ "$DEMO_MODE" = true ]; then
        echo ""
        echo -e "${BOLD}${CYAN}Press Enter to continue...${NC}"
        read
    else
        sleep 1
    fi
}

simulate_typing() {
    local text="$1"
    local delay="${2:-0.03}"

    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

show_mock_epic_creation() {
    local epic_name="$1"
    local summary="$2"
    local priority="${3:-P1}"
    local epic_key="DATA-$(shuf -i 67800-67899 -n 1)"

    echo ""
    print_step "Creating epic in JIRA..."
    sleep 1

    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${BOLD}Epic Details${NC}                                              ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} Epic Name:     ${WHITE}$epic_name${NC}"
    echo -e "${CYAN}│${NC} Summary:       ${WHITE}$summary${NC}"
    echo -e "${CYAN}│${NC} Priority:      ${WHITE}$priority${NC}"
    echo -e "${CYAN}│${NC} Component:     ${WHITE}DATA-BFRM${NC}"
    echo -e "${CYAN}│${NC} Project:       ${WHITE}DATA${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"

    sleep 1
    print_success "Epic created: $epic_key"
    echo -e "${CYAN}URL: https://jira.ops.expertcity.com/browse/$epic_key${NC}"
    echo ""

    echo "$epic_key"
}

show_mock_story_creation() {
    local summary="$1"
    local epic_key="$2"
    local points="${3:-5}"
    local priority="${4:-P1}"
    local story_key="DATA-$(shuf -i 67900-67999 -n 1)"

    echo ""
    print_step "Creating story in JIRA..."
    sleep 1

    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${BOLD}Story Details${NC}                                            ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} Summary:       ${WHITE}$summary${NC}"
    echo -e "${CYAN}│${NC} Epic Link:     ${WHITE}$epic_key${NC}"
    echo -e "${CYAN}│${NC} Story Points:  ${WHITE}$points${NC}"
    echo -e "${CYAN}│${NC} Priority:      ${WHITE}$priority${NC}"
    echo -e "${CYAN}│${NC} Component:     ${WHITE}DATA-BFRM${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"

    sleep 1
    print_success "Story created: $story_key"
    echo -e "${CYAN}   Linked to epic: $epic_key${NC}"
    echo -e "${CYAN}   URL: https://jira.ops.expertcity.com/browse/$story_key${NC}"
    echo ""

    echo "$story_key"
}

show_mock_subtask_creation() {
    local summary="$1"
    local parent_key="$2"
    local priority="${3:-P1}"
    local subtask_key="DATA-$(shuf -i 68000-68099 -n 1)"

    echo ""
    print_step "Creating subtask in JIRA..."
    sleep 1

    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${BOLD}Subtask Details${NC}                                          ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} Summary:       ${WHITE}$summary${NC}"
    echo -e "${CYAN}│${NC} Parent Story:  ${WHITE}$parent_key${NC}"
    echo -e "${CYAN}│${NC} Priority:      ${WHITE}$priority${NC}"
    echo -e "${CYAN}│${NC} Component:     ${WHITE}DATA-BFRM${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NC}"

    sleep 1
    print_success "Subtask created: $subtask_key"
    echo -e "${CYAN}   Under parent: $parent_key${NC}"
    echo -e "${CYAN}   URL: https://jira.ops.expertcity.com/browse/$subtask_key${NC}"
    echo ""

    echo "$subtask_key"
}

show_epic_search_simulation() {
    local search_context="$1"

    echo ""
    print_step "🔍 Searching for relevant epics in DATA-BFRM..."
    sleep 1

    echo -e "${CYAN}Query: project=DATA AND type=Epic AND component=DATA-BFRM AND status IN ('To Do','In Progress')${NC}"
    sleep 1

    echo ""
    print_info "Found 3 epic(s):"
    echo ""
    echo -e "${WHITE}  1${NC}  DATA-67800 - Data Pipeline Modernization Initiative ${CYAN}[To Do]${NC}"
    echo -e "${WHITE}  2${NC}  DATA-66186 - Delta Table Retention & Vacuum Strategy ${CYAN}[To Do]${NC}"
    echo -e "${WHITE}  3${NC}  DATA-66100 - Real-time Data Platform Phase 2 ${CYAN}[In Progress]${NC}"
    echo ""

    sleep 1
    print_step "🤖 Analyzing relevance based on: \"$search_context\""
    sleep 1

    echo -e "${GREEN}   ✓ DATA-67800 matches keywords: pipeline, real-time${NC}"
    echo -e "${YELLOW}   ~ DATA-66186 partial match: data${NC}"
    echo -e "${YELLOW}   ~ DATA-66100 partial match: platform${NC}"
    echo ""

    print_success "Best match: DATA-67800 (Data Pipeline Modernization Initiative)"
    echo ""
}

# ============================================================================
# Demo Sections
# ============================================================================

demo_intro() {
    clear
    print_header "🎬 JIRA AUTOMATION - INTERACTIVE DEMO"

    cat << EOF
${BOLD}${WHITE}Welcome to the JIRA Automation System Demo!${NC}

This interactive demo will walk you through:

  ${GREEN}✓${NC} System architecture and components
  ${GREEN}✓${NC} Creating epics with professional templates
  ${GREEN}✓${NC} Intelligent epic search and suggestion
  ${GREEN}✓${NC} Creating stories with automatic linking
  ${GREEN}✓${NC} Creating subtasks with implementation details
  ${GREEN}✓${NC} Bulk creation from implementation plans

${BOLD}Demo Mode:${NC} ${CYAN}$DEMO_MODE${NC} (simulated issue creation)
${BOLD}Duration:${NC} ${CYAN}~10 minutes${NC}

EOF
    pause
}

demo_architecture() {
    print_section "📐 SYSTEM ARCHITECTURE"

    cat << EOF
${BOLD}The system is built on 3 layers:${NC}

${PURPLE}┌─────────────────────────────────────────────────────────────┐${NC}
${PURPLE}│${NC} ${BOLD}LAYER 1: USER INTERFACES${NC}                               ${PURPLE}│${NC}
${PURPLE}├─────────────────────────────────────────────────────────────┤${NC}
${PURPLE}│${NC}  • Natural Language (Claude Code Skill)                   ${PURPLE}│${NC}
${PURPLE}│${NC}  • Shell Commands (jira-epic, jira-story, jira-subtask)  ${PURPLE}│${NC}
${PURPLE}│${NC}  • Programmatic API (create_epic(), create_story())      ${PURPLE}│${NC}
${PURPLE}└─────────────────────────────────────────────────────────────┘${NC}
                             ${CYAN}│${NC}
                             ${CYAN}▼${NC}
${YELLOW}┌─────────────────────────────────────────────────────────────┐${NC}
${YELLOW}│${NC} ${BOLD}LAYER 2: WORKFLOW ORCHESTRATION${NC}                       ${YELLOW}│${NC}
${YELLOW}├─────────────────────────────────────────────────────────────┤${NC}
${YELLOW}│${NC}  • Interactive Prompts (collect user input)              ${YELLOW}│${NC}
${YELLOW}│${NC}  • Epic Search & Suggestion ${BOLD}(the magic!)${NC}               ${YELLOW}│${NC}
${YELLOW}│${NC}  • Template Processing (JIRA wiki markup)                ${YELLOW}│${NC}
${YELLOW}│${NC}  • Validation (check formats, required fields)           ${YELLOW}│${NC}
${YELLOW}│${NC}  • Preview & Confirmation                                ${YELLOW}│${NC}
${YELLOW}└─────────────────────────────────────────────────────────────┘${NC}
                             ${CYAN}│${NC}
                             ${CYAN}▼${NC}
${GREEN}┌─────────────────────────────────────────────────────────────┐${NC}
${GREEN}│${NC} ${BOLD}LAYER 3: JIRA INTEGRATION${NC}                             ${GREEN}│${NC}
${GREEN}├─────────────────────────────────────────────────────────────┤${NC}
${GREEN}│${NC}  • JIRA REST API (/rest/api/2/issue)                     ${GREEN}│${NC}
${GREEN}│${NC}  • Field Mapping (custom field IDs)                      ${GREEN}│${NC}
${GREEN}│${NC}  • Issue Creation (epic → story → subtask hierarchy)     ${GREEN}│${NC}
${GREEN}│${NC}  • Automatic Linking                                     ${GREEN}│${NC}
${GREEN}└─────────────────────────────────────────────────────────────┘${NC}

${BOLD}Diagram:${NC} See ${CYAN}docs/diagrams/architecture.png${NC}

EOF
    pause
}

demo_epic_creation() {
    print_section "🎯 DEMO 1: CREATE AN EPIC"

    cat << EOF
${BOLD}Scenario:${NC} We're starting a Data Pipeline Modernization project

${BOLD}What we'll create:${NC}
  • Epic with comprehensive business context
  • Professional JIRA wiki markup formatting
  • All required fields filled

${BOLD}Time:${NC} ~2 minutes (vs 15 minutes manual)

EOF
    pause

    print_step "📝 Epic Details:"
    echo ""
    echo "  Epic Name:       ${WHITE}DATA-PIPE-MOD${NC}"
    echo "  Summary:         ${WHITE}Data Pipeline Modernization Initiative${NC}"
    echo "  Priority:        ${WHITE}P1${NC}"
    echo "  Component:       ${WHITE}DATA-BFRM${NC}"
    echo ""
    echo "  Overview:        ${WHITE}Modernize legacy data pipeline to support real-time${NC}"
    echo "                   ${WHITE}processing and reduce latency from hours to minutes${NC}"
    echo ""
    echo "  Business Value:  ${WHITE}• 40% cost reduction${NC}"
    echo "                   ${WHITE}• 95% faster processing (4h → 15min)${NC}"
    echo "                   ${WHITE}• 10x scalability improvement${NC}"
    echo ""
    pause

    # Simulate creation
    DEMO_EPIC_KEY=$(show_mock_epic_creation \
        "DATA-PIPE-MOD" \
        "Data Pipeline Modernization Initiative" \
        "P1")

    print_info "Epic formatted with professional template:"
    echo ""
    echo -e "${YELLOW}h1. 📋 Overview${NC}"
    echo -e "${YELLOW}Modernize legacy data pipeline infrastructure...${NC}"
    echo ""
    echo -e "${YELLOW}h1. 💼 Business Value${NC}"
    echo -e "${YELLOW}* Cost Reduction: Reduce infrastructure costs by 40%${NC}"
    echo -e "${YELLOW}* Performance: Decrease processing time from 4h to 15min${NC}"
    echo ""
    echo -e "${YELLOW}h1. 🎯 Goals & Objectives${NC}"
    echo -e "${YELLOW}* Migrate from batch to real-time streaming${NC}"
    echo -e "${YELLOW}* Implement automated data quality validation${NC}"
    echo ""

    pause
}

demo_epic_search() {
    print_section "✨ DEMO 2: INTELLIGENT EPIC SEARCH"

    cat << EOF
${BOLD}The Secret Sauce:${NC} Automatic epic suggestion!

${BOLD}Problem:${NC}
  When creating a story, you need to link it to an epic.
  But who remembers epic keys? DATA-12345? DATA-67890?

${BOLD}Solution:${NC}
  The system searches for relevant epics and suggests the best match!

${BOLD}How it works:${NC}
  1. Detect: No epic link provided
  2. Search: Query JIRA for active epics in component
  3. Analyze: Match story keywords with epic summaries
  4. Rank: Score by relevance + recency
  5. Suggest: Show top matches
  6. Confirm: User selects

EOF
    pause

    show_epic_search_simulation "Kafka real-time ingestion pipeline"

    print_info "Diagram: See ${CYAN}docs/diagrams/story-epic-suggestion.png${NC}"

    pause
}

demo_story_creation() {
    print_section "📖 DEMO 3: CREATE A STORY WITH EPIC LINKING"

    cat << EOF
${BOLD}Scenario:${NC} Create a story for implementing Kafka ingestion

${BOLD}What's special:${NC}
  • Story follows user story format (As a... I want... So that...)
  • Automatically suggests relevant epic
  • Includes acceptance criteria, technical requirements
  • Professional template formatting

EOF
    pause

    print_step "📝 Story Details:"
    echo ""
    echo "  Summary:         ${WHITE}Implement Real-Time Data Ingestion Layer${NC}"
    echo "  User Type:       ${WHITE}data engineer${NC}"
    echo "  Goal:            ${WHITE}ingest data in real-time from multiple sources${NC}"
    echo "  Benefit:         ${WHITE}downstream analytics can access fresh data${NC}"
    echo "  Story Points:    ${WHITE}8${NC}"
    echo "  Priority:        ${WHITE}P1${NC}"
    echo ""
    pause

    # Show epic search
    show_epic_search_simulation "real-time data ingestion Kafka"

    print_step "💡 Linking to suggested epic: DATA-67800"
    pause

    # Simulate creation
    DEMO_STORY_KEY=$(show_mock_story_creation \
        "Implement Real-Time Data Ingestion Layer" \
        "$DEMO_EPIC_KEY" \
        "8" \
        "P1")

    print_info "Story template includes:"
    echo ""
    echo -e "${YELLOW}h1. 📖 User Story${NC}"
    echo -e "${YELLOW}*As a* data engineer${NC}"
    echo -e "${YELLOW}*I want* to ingest data in real-time${NC}"
    echo -e "${YELLOW}*So that* downstream analytics can access fresh data${NC}"
    echo ""
    echo -e "${YELLOW}h1. ✅ Acceptance Criteria${NC}"
    echo -e "${YELLOW}* Kafka cluster deployed with 3 brokers${NC}"
    echo -e "${YELLOW}* Throughput supports 100k events/second${NC}"
    echo -e "${YELLOW}* End-to-end latency under 2 minutes${NC}"
    echo ""

    pause
}

demo_subtask_creation() {
    print_section "📋 DEMO 4: CREATE A SUBTASK"

    cat << EOF
${BOLD}Scenario:${NC} Break down the story into implementation tasks

${BOLD}Subtask format:${NC}
  • Clear objective
  • Step-by-step implementation
  • Definition of Done checklist

EOF
    pause

    print_step "📝 Subtask Details:"
    echo ""
    echo "  Summary:         ${WHITE}Set up Kafka cluster infrastructure${NC}"
    echo "  Parent Story:    ${WHITE}$DEMO_STORY_KEY${NC}"
    echo "  Priority:        ${WHITE}P1${NC}"
    echo ""
    echo "  Implementation:"
    echo "    ${WHITE}1. Provision 3 EC2 instances for brokers${NC}"
    echo "    ${WHITE}2. Install and configure Kafka 3.x${NC}"
    echo "    ${WHITE}3. Set up ZooKeeper ensemble${NC}"
    echo "    ${WHITE}4. Configure broker settings${NC}"
    echo "    ${WHITE}5. Test connectivity and failover${NC}"
    echo ""
    pause

    # Simulate creation
    DEMO_SUBTASK_KEY=$(show_mock_subtask_creation \
        "Set up Kafka cluster infrastructure" \
        "$DEMO_STORY_KEY" \
        "P1")

    print_info "Subtask template includes Definition of Done:"
    echo ""
    echo -e "${YELLOW}h1. ✅ Definition of Done${NC}"
    echo -e "${YELLOW}* [ ] 3-broker cluster operational${NC}"
    echo -e "${YELLOW}* [ ] ZooKeeper ensemble healthy${NC}"
    echo -e "${YELLOW}* [ ] SSL/SASL authentication working${NC}"
    echo -e "${YELLOW}* [ ] Monitoring dashboards created${NC}"
    echo -e "${YELLOW}* [ ] Runbook documented${NC}"
    echo ""

    pause
}

demo_bulk_creation() {
    print_section "🚀 DEMO 5: BULK CREATION FROM PLAN"

    cat << EOF
${BOLD}The Power Move:${NC} Transform entire implementation plans into JIRA!

${BOLD}Scenario:${NC}
  You have a comprehensive implementation plan with:
    • 1 Epic
    • 5 Stories
    • 20 Subtasks

${BOLD}Traditional approach:${NC}
  • Manual creation: ~3 hours
  • Error-prone, tedious, repetitive

${BOLD}AI-powered approach:${NC}
  • Paste plan into Claude Code
  • AI parses structure
  • Creates all issues with proper linking
  • Time: ~10 minutes

${BOLD}Example:${NC} See ${CYAN}examples/sample-implementation-plan.md${NC}

EOF
    pause

    print_step "📄 Parsing implementation plan..."
    sleep 1
    echo ""
    print_result "Detected structure:"
    echo "  • 1 Epic:     ${WHITE}Data Pipeline Modernization${NC}"
    echo "  • 5 Stories:  ${WHITE}Ingestion, Quality, Processing, Storage, Analytics${NC}"
    echo "  • 20 Subtasks: ${WHITE}Implementation tasks${NC}"
    echo ""
    pause

    print_step "🔨 Creating issues in hierarchy..."
    echo ""

    # Epic
    echo -e "${CYAN}[1/26]${NC} Creating epic..."
    sleep 0.5
    local epic_key="DATA-67800"
    print_result "      ✅ Epic: $epic_key - Data Pipeline Modernization"
    echo ""

    # Stories
    local story_keys=()
    for i in {1..5}; do
        echo -e "${CYAN}[$((i+1))/26]${NC} Creating story $i..."
        sleep 0.3
        local story_key="DATA-$((67800+i))"
        story_keys+=("$story_key")
        print_result "      ✅ Story: $story_key (→ $epic_key)"
    done
    echo ""

    # Subtasks
    for i in {1..20}; do
        local story_idx=$(( (i-1) / 4 ))
        local story_key="${story_keys[$story_idx]}"
        echo -e "${CYAN}[$((i+6))/26]${NC} Creating subtask $i..."
        sleep 0.2
        local subtask_key="DATA-$((67806+i))"
        print_result "      ✅ Subtask: $subtask_key (→ ${story_key})"
    done
    echo ""

    pause

    print_header "🎉 SUMMARY"

    cat << EOF
${BOLD}${GREEN}✅ Created 26 issues in ~10 minutes${NC}

${BOLD}Hierarchy:${NC}
  Epic:     DATA-67800
    ├─ Story: DATA-67801 (8 points)
    │  ├─ Subtask: DATA-67807
    │  ├─ Subtask: DATA-67808
    │  ├─ Subtask: DATA-67809
    │  └─ Subtask: DATA-67810
    ├─ Story: DATA-67802 (5 points)
    │  ├─ Subtask: DATA-67811
    │  ├─ Subtask: DATA-67812
    │  ├─ Subtask: DATA-67813
    │  └─ Subtask: DATA-67814
    └─ [... 3 more stories with subtasks ...]

${BOLD}All issues:${NC}
  • Professionally formatted with JIRA wiki markup
  • Properly linked (Epic → Story → Subtask)
  • Follow DATA project standards (P1, DATA-BFRM)
  • Include comprehensive details

${BOLD}Time saved:${NC} ${GREEN}~2.5 hours${NC}

EOF
    pause
}

demo_features_recap() {
    print_section "🌟 KEY FEATURES RECAP"

    cat << EOF
${BOLD}1. Multiple Interfaces${NC}
   ${GREEN}✓${NC} Natural Language: "Create an epic for X"
   ${GREEN}✓${NC} Shell Commands: jira-epic, jira-story, jira-subtask
   ${GREEN}✓${NC} Programmatic API: create_epic(), create_story()

${BOLD}2. Intelligent Epic Linking${NC}
   ${GREEN}✓${NC} Automatic search for relevant epics
   ${GREEN}✓${NC} Keyword matching + recency scoring
   ${GREEN}✓${NC} Component-aware (DATA-BFRM)
   ${GREEN}✓${NC} Status filtering (active epics only)

${BOLD}3. Professional Templates${NC}
   ${GREEN}✓${NC} JIRA wiki markup formatting
   ${GREEN}✓${NC} Comprehensive sections (Overview, Goals, Value, etc.)
   ${GREEN}✓${NC} User story format (As a... I want... So that...)
   ${GREEN}✓${NC} Definition of Done checklists

${BOLD}4. Project Standards${NC}
   ${GREEN}✓${NC} Priorities: P0, P1, P2, P3, Unprioritized
   ${GREEN}✓${NC} Component: DATA-BFRM (default)
   ${GREEN}✓${NC} Custom fields: Epic Name, Epic Link, Story Points
   ${GREEN}✓${NC} Labels: ai-generated, custom tags

${BOLD}5. Validation & Error Handling${NC}
   ${GREEN}✓${NC} Field format validation
   ${GREEN}✓${NC} Required field checking
   ${GREEN}✓${NC} Epic key verification
   ${GREEN}✓${NC} Helpful error messages

${BOLD}6. Bulk Operations${NC}
   ${GREEN}✓${NC} Parse implementation plans
   ${GREEN}✓${NC} Create complete hierarchies
   ${GREEN}✓${NC} Automatic linking
   ${GREEN}✓${NC} 95% time savings

EOF
    pause
}

demo_time_savings() {
    print_section "⏱️  TIME & QUALITY COMPARISON"

    cat << EOF
${BOLD}Time Savings:${NC}

┌────────────────┬─────────────┬─────────────┬──────────┐
│ ${BOLD}Task${NC}           │ ${BOLD}Manual${NC}      │ ${BOLD}Automated${NC}   │ ${BOLD}Savings${NC}  │
├────────────────┼─────────────┼─────────────┼──────────┤
│ 1 Epic         │ 15 min      │ 30 sec      │ ${GREEN}96%${NC}      │
│ 1 Story        │ 10 min      │ 45 sec      │ ${GREEN}92%${NC}      │
│ 1 Subtask      │ 5 min       │ 20 sec      │ ${GREEN}93%${NC}      │
│ 20 Issues      │ 3 hours     │ 10 min      │ ${GREEN}94%${NC}      │
└────────────────┴─────────────┴─────────────┴──────────┘

${BOLD}Quality Improvements:${NC}

  ${GREEN}✓${NC} ${BOLD}Consistency:${NC}   All issues follow same template structure
  ${GREEN}✓${NC} ${BOLD}Completeness:${NC}  No missing sections or fields
  ${GREEN}✓${NC} ${BOLD}Formatting:${NC}    Professional JIRA wiki markup
  ${GREEN}✓${NC} ${BOLD}Linking:${NC}       Automatic epic → story → subtask hierarchy
  ${GREEN}✓${NC} ${BOLD}Standards:${NC}     DATA project conventions enforced

${BOLD}ROI Example:${NC}

  Team of 5 engineers, each planning 1 sprint/month:
  • Manual: 5 × 3 hours = 15 hours/month
  • Automated: 5 × 10 min = 50 min/month
  • ${GREEN}Saved: 14 hours/month = 168 hours/year${NC}

EOF
    pause
}

demo_try_yourself() {
    print_section "🎮 TRY IT YOURSELF"

    cat << EOF
${BOLD}Ready to try it?${NC}

${BOLD}Quick Start:${NC}

  1. ${CYAN}Test connection:${NC}
     ${YELLOW}jira-test${NC}

  2. ${CYAN}Create your first epic:${NC}
     ${YELLOW}jira-epic${NC}

  3. ${CYAN}Create a story with epic suggestion:${NC}
     ${YELLOW}jira-story${NC}

  4. ${CYAN}Add a subtask:${NC}
     ${YELLOW}jira-subtask${NC}

${BOLD}Natural Language (in Claude Code):${NC}

  ${YELLOW}"Create an epic for [your project description]"${NC}
  ${YELLOW}"Create a story for [feature description]"${NC}
  ${YELLOW}"Add subtask to DATA-xxxxx for [task description]"${NC}

${BOLD}Documentation:${NC}

  • ${CYAN}Complete Demo:${NC}        DEMO.md
  • ${CYAN}User Guide:${NC}           docs/JIRA-SKILL-GUIDE.md
  • ${CYAN}Quick Start:${NC}          QUICKSTART.md
  • ${CYAN}Quick Reference:${NC}      docs/QUICK-REFERENCE.md
  • ${CYAN}README:${NC}               README.md

${BOLD}Diagrams:${NC}

  • ${CYAN}Architecture:${NC}         docs/diagrams/architecture.png
  • ${CYAN}Data Flow:${NC}            docs/diagrams/data-flow.png
  • ${CYAN}Epic Workflow:${NC}        docs/diagrams/epic-workflow.png
  • ${CYAN}Epic Suggestion:${NC}      docs/diagrams/story-epic-suggestion.png

EOF
    pause
}

demo_conclusion() {
    clear
    print_header "🎉 DEMO COMPLETE!"

    cat << EOF
${BOLD}${GREEN}Thank you for watching the JIRA Automation Demo!${NC}

${BOLD}What you learned:${NC}

  ${GREEN}✓${NC} 3-layer architecture (UI → Orchestration → Integration)
  ${GREEN}✓${NC} Multiple interfaces (Natural language, CLI, API)
  ${GREEN}✓${NC} Intelligent epic search and suggestion
  ${GREEN}✓${NC} Professional template formatting
  ${GREEN}✓${NC} Bulk creation from implementation plans
  ${GREEN}✓${NC} 95% time savings with quality improvements

${BOLD}Next steps:${NC}

  1. ${CYAN}Read the documentation:${NC}
     cat DEMO.md
     cat docs/JIRA-SKILL-GUIDE.md

  2. ${CYAN}View the diagrams:${NC}
     open docs/diagrams/architecture.png

  3. ${CYAN}Try the commands:${NC}
     jira-test
     jira-epic

  4. ${CYAN}Use natural language:${NC}
     "Create an epic for [your project]"

${BOLD}Questions?${NC}

  • Run: ${YELLOW}jira-auto help${NC}
  • Read: ${YELLOW}docs/${NC}
  • Ask Claude: ${YELLOW}"Help me create a JIRA epic"${NC}

${BOLD}${GREEN}Ready to automate your JIRA workflow? Let's go! 🚀${NC}

EOF

    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ============================================================================
# Main Demo Flow
# ============================================================================

main() {
    demo_intro
    demo_architecture
    demo_epic_creation
    demo_epic_search
    demo_story_creation
    demo_subtask_creation
    demo_bulk_creation
    demo_features_recap
    demo_time_savings
    demo_try_yourself
    demo_conclusion
}

# Run demo
main
