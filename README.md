# Hyper-Personalized Personality & Caricature Avatar Generator

An internet-native, multi-agentic web application built with **Jac** and managed/deployed via **JacHammer** ([https://jachammer.ai/](https://jachammer.ai/)) that quizzes users to discover their unhinged personality characteristics and generates personalized caricaturized avatars.

---

## 🚀 How to Run the Application Locally

### Prerequisites
- **Jac CLI** (`~/.local/bin/jac` or standard `jac`)
- **Bun** / **Node.js** (for client asset compilation)

### 1. Start the Full-Stack Dev Server
Run the following command from the project root:
```bash
jac start --dev main.jac
```

### 2. Access Points
Once started, the development server will serve:
- 🌐 **Web App Interface**: [http://localhost:8000/](http://localhost:8000/)
- ⚙️ **Jac API Server & Walkers**: [http://localhost:8001/](http://localhost:8001/)

### 3. QA & Automated Browser Inspection (`jac browse`)
You can use Jac's built-in headless browser tool to inspect accessibility trees or test user interactions:
```bash
# Open app in headless browser
jac browse open http://localhost:8000

# Inspect accessibility snapshot
jac browse snapshot

# Click interactive CTA button
jac browse click @e9

# Close browser session
jac browse close
```

---

## Project Structure & Specs

- [Product Requirements Document (PRD)](./docs/PRD.md)
- [High-Level System Design Document](./docs/SYSTEM_DESIGN.md)
- [App Development Strategy & Implementation Roadmap](./docs/DEVELOPMENT_STRATEGY.md)
- [Personality Trait & Title Synthesizer Spec (`Agent 2`)](./docs/TRAIT_SYNTHESIZER_SPEC.md)
- [Agent 2 Implementation Plan](./docs/IMPLEMENTATION_PLAN_AGENT_2.md)

---

## Multi-Agent Architecture (Jac)

1. **`IntakeWalker` (Agent 1)**: Manages adaptive quiz questions (Multiple Choice + Free-Form text).
2. **`TraitWalker` (Agent 2)**: Synthesizes responses into unhinged top titles, 3-4 primary trait badges, and deep psychological analysis.
3. **`AvatarWalker` (Agent 3)**: Fuses user likeness (photo upload OR manual skin/hair/gender attribute selector) with caricaturized archetype themes to generate avatars & $9:16$ story share posters.
