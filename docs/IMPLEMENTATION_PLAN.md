# Implementation Plan — Full-Stack Jac Web App & User Journey Scaffold

Build the complete full-stack web application user journey (`/`, `/test`, `/result/[sessionId]`) using the **Jac Web App Framework** (`jac create --kind web-app`), **Jac-shadcn** UI components, and Jac node/walker state management. The user journey will be scaffolded and verified first, followed by hooking in the LLM generative abilities and image adapter.

## Strategy Rationale & Jac Prominence
Scaffolding the full-stack Jac web app first ensures:
- **Maximum Jac Prominence**: Uses Jac native project structure, Jac client-server communication, and Jac node graph state management throughout the app.
- **Instant Visual Validation**: Test UI transitions, 28-question pagination, post-quiz likeness collection modal, and story poster exporter natively within Jac.
- **Direct Jac Walker Integration**: Frontend client triggers Jac walkers (`IntakeWalker`, `TraitWalker`, `AvatarWalker`) directly.

---

## User Review Required

> [!IMPORTANT]
> **Jac Tech Stack**:
> - **Framework**: Jac Web App (`jac create --kind web-app`) powered by Jac client primitives & Jac-shadcn.
> - **Backend Graph**: `backend/jac/main.jac` (`UserSessionNode`, `QuestionNode`, `TraitArchetypeNode`, `AvatarArtifactNode`).
> - **Page Routes**:
>   - `/` (Landing Page with dynamic avatar gallery, sarcastic hero pitch, and instant "Start Test" CTA).
>   - `/test` (Step 1: 28-question pagination + free-form text input; Step 2: Post-quiz Avatar Personalization modal; Step 3: Progressive Agent Loader screen).
>   - `/result/[sessionId]` (Public Permalinks displaying MBTI anchor, unhinged title, avatar poster, 3-4 trait badges, expandable deep analysis drawer, and 9:16 story card exporter).

---

## Proposed Changes

### 1. Jac Project Initialization (`web-app` kind)

Execute standard Jac project creation in non-interactive mode:
```bash
~/.local/bin/jac create --kind web-app --force
```

### 2. Jac Multi-Agent Graph & Walkers (`backend/jac/main.jac`)

#### [MODIFY] [backend/jac/main.jac](file:///Users/scottsimenel/Development/jac-hacks/backend/jac/main.jac)
- Add web-session entry points and RPC walkers (`InitSessionWalker`, `SubmitAnswerWalker`, `SubmitLikenessWalker`, `FetchResultWalker`).
- Integrate `mbti_questions_28.json` dataset loading directly into Jac `QuestionNode` graph initialization.

### 3. Frontend Client & Page Journey (`client/` / `frontend/`)

#### [NEW] [client/src/pages/LandingPage.tsx](file:///Users/scottsimenel/Development/jac-hacks/client/src/pages/LandingPage.tsx)
- Hero section with sarcastic tagline, dynamic avatar preview carousel, disclaimer, and instant "Start Test" CTA button.

#### [NEW] [client/src/pages/QuizPage.tsx](file:///Users/scottsimenel/Development/jac-hacks/client/src/pages/QuizPage.tsx)
- Interactive multi-step journey:
  - **Step 1 (Quiz Questions)**: 28 situational questions from `mbti_questions_28.json` with dual choices + free-form text input option.
  - **Step 2 (Post-Quiz Personalization Modal)**: Photo Upload (with crop/image preview) OR Manual Physical Attributes (skin tone, hair color/style/length, gender expression, accessories).
  - **Step 3 (Agent Loader)**: Progressive status loader (*"Agent 1 analyzed traits..."* $\rightarrow$ *"Agent 2 generated title..."* $\rightarrow$ *"Agent 3 rendering avatar..."*).

#### [NEW] [client/src/pages/ResultPage.tsx](file:///Users/scottsimenel/Development/jac-hacks/client/src/pages/ResultPage.tsx)
- Public Permalink Hub (`/result/[sessionId]`):
  - Caricaturized avatar poster display (with SVG vector fallback preview).
  - Calculated MBTI anchor, unhinged custom title, top 3-4 trait badges.
  - Expandable "Deep Analysis" drawer (5-model matrix radar chart, strengths/flaws, roasted summary).
  - One-click $9:16$ vertical Instagram/TikTok Story Card generator and Native Web Share sheet.

---

## Verification Plan

### Automated Verification
- Verify Jac project compilation: `~/.local/bin/jac check backend/jac/main.jac`.
- Verify Jac project build & client asset generation: `~/.local/bin/jac build`.

### Manual UI & Graph Verification
- **Landing Page (`/`)**: Verify hero animations, CTA click transitions to `/test`.
- **Quiz Progression (`/test`)**: Complete quiz questions 1 to 28, test back button, verify progress bar updates, test free-form text input.
- **Post-Quiz Personalization Modal**: Verify toggle between Photo Upload (image preview) and Manual Attributes (skin tone, hair color/style, accessories).
- **Interactive Agent Loader**: Verify progressive status updates.
- **Results Hub (`/result/[sessionId]`)**: Verify avatar display, trait badges, radar chart drawer expansion, and 9:16 story card export.
