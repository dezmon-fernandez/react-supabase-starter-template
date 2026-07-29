---
description: Prime agent with codebase understanding
---

# Prime: Load Project Context

## Objective

Build comprehensive understanding of the codebase by analyzing structure, documentation, and key files.

## Process

### 1. Analyze Project Structure

List all tracked files:
!`git ls-files`

Show directory structure:
!`tree -L 3 -I 'node_modules|__pycache__|.git|dist|build'`

### 2. Read Core Documentation

- **Read the PRD (`.agents/PRD.md`) — the project's source of truth** (vision, MVP scope, architecture, success criteria, risks). If it's missing, note the user should run `/create-prd`.
- Read CLAUDE.md or similar global rules file
- Read README files at project root and major directories
- Read any architecture documentation

**Artifact index — the domain-doc map** (read each when its trigger fires; pull the relevant ones now during priming, the rest on demand):

| Artifact | Read when… |
|---|---|
| `.agents/PRD.md` | the spec / source of truth — before any feature work. |
| `[STACK-SPECIFIC: the schema source of truth, e.g. migrations/*.sql — drop this row if the stack has none]` | you need table shapes, columns, or constraints. |
| `[PROJECT-SPECIFIC: a domain standard, e.g. .agents/documentation/<topic>.md]` | `[PROJECT-SPECIFIC: its trigger, e.g. working in that domain's slices.]` |
| `[PROJECT-SPECIFIC: a workflow or reference doc the project relies on]` | `[PROJECT-SPECIFIC: its trigger.]` |

### 3. Identify Key Files

Based on the structure, identify and read:
- Main entry points (main.py, index.ts, app.py, etc.)
- Core configuration files (pyproject.toml, package.json, tsconfig.json)
- Key model/schema definitions
- Important service or controller files

### 4. Understand Current State

Check recent activity:
!`git log -10 --oneline`

Check current branch and status:
!`git status`

## Output Report

Provide a concise summary covering:

### Project Overview
- Purpose and type of application
- Primary technologies and frameworks
- Current version/state

### Architecture
- Overall structure and organization
- Key architectural patterns identified
- Important directories and their purposes

### Tech Stack
- Languages and versions
- Frameworks and major libraries
- Build tools and package managers
- Testing frameworks

### Core Principles
- Code style and conventions observed
- Documentation standards
- Testing approach

### Current State
- Active branch
- Recent changes or development focus
- Any immediate observations or concerns

**Make this summary easy to scan - use bullet points and clear headers.**
