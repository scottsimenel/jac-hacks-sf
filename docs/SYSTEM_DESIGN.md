# High-Level System Design Document

## 1. Architecture Overview & Jac Prominence

The system is built with **Jac** as the core backend and multi-agent execution orchestrator. Jac manages the entire stateful graph: user sessions, adaptive question trees, deterministic MBTI scoring, personality synthesis walkers, deep analysis generation, and avatar prompt assembly.

```mermaid
graph TD
    Client[Next.js Client Web App] -->|REST API / WebSockets| APIGateway[Next.js API Gateway / Proxy]
    APIGateway -->|Jac Service Protocol| JacEngine[Jac Graph Execution Server]

    subgraph Jac Core Architecture
        JacEngine --> SessionNode[UserSessionNode: Photo OR Manual Attributes]
        
        SessionNode -->|Walker: IntakeWalker| QGraph[Adaptive Question Node Graph: Baseline Dataset]
        QGraph -->|MC Choices + Free-form Text| AnsNode[AnswerHistoryNode]
        
        AnsNode --> DeterministicCalc[Deterministic MBTI Calculator: EI, SN, TF, JP]
        DeterministicCalc -->|4-Letter MBTI Anchor| Synthesizer[Agent 2: Trait & Title Synthesizer]
        Synthesizer --> TraitNode[Trait, MBTI Base & Title Node]
        Synthesizer --> DeepNode[Deep Analysis Node]
        
        TraitNode -->|Walker: AvatarWalker| PromptEngine[3-Layer Avatar Prompt Crafter]
        PromptEngine --> ImageAdapter{Image Gen Service}
    end
    
    ImageAdapter -->|Success (<10s)| RemoteImage[Rendered Avatar URL]
    ImageAdapter -->|Timeout / Error| SVGAdapter[Stylized SVG Fallback Renderer]
    
    RemoteImage --> DB[(Jac Persistence DB)]
    SVGAdapter --> DB
    DB -->|Public Permalink /result/:sessionId| Client
```

---

## 2. Component Integration: Baseline MBTI Engine

### 2.1 Question Dataset (`backend/data/mbti_questions_28.json`)
- **Structure**: 28 situational questions mapping to 4 dichotomy pairs (`EI`, `SN`, `TF`, `JP`).
- **Options**: Dual-choice (Option 1 vs Option 2) + free-form user context field.

### 2.2 Deterministic Scoring Calculator (`backend/jac/mbti_calculator.py`)
- **Input**: List of answers `[{ dimension: "EI", choice: 1 }, ...]`
- **Logic**: Increments dimension counters and enforces official Myers-Briggs tie-breaking rules (`I`, `N`, `F`, `P` on exact ties).
- **Output**: `{ type: "ENTJ", scores: { E: 5, I: 2, S: 1, N: 6, T: 4, F: 3, J: 5, P: 2 } }`

---

## 3. Jac Graph Model & Data Entities

### 3.1 Core Nodes
- `UserSessionNode`: Stores UUID `sessionId`, completion state, and **Likeness Payload** (`photo_url: Option<String>` OR `manual_attributes`).
- `QuestionNode`: Stores question prompt from `mbti_questions_28.json`, options, and dichotomy label (`EI`, `SN`, `TF`, `JP`).
- `AnswerNode`: Stores selected choice index (1 or 2) and sanitized free-form text input (max 280 chars).
- `TraitArchetypeNode`: Stores calculated **MBTI Anchor** (e.g. `ENTJ`), dynamically generated title (e.g. *Main Character*, *Captain*), top 3-4 trait badges, and color theme metadata.
- `DeepAnalysisNode`: Stores 15-dimension raw scores, radar chart matrix data, strengths, flaws, and "Appearance vs. Reality" breakdown.
- `AvatarArtifactNode`: Stores 3-layer prompt logs, seed, generation provider status, fallback status (`is_fallback: bool`), and rendered image URLs.

---

## 4. API Transport Contracts (Next.js $\leftrightarrow$ Jac Server)

1. **`POST /api/session/init`**: Initializes session & returns Q1.
2. **`POST /api/quiz/answer`**: Submits choice (1 or 2) + optional freeform text, returns next question OR `completed: true`.
3. **`GET /api/quiz/result/[sessionId]`**: Returns MBTI baseline anchor, unhinged title, radar data, and avatar image URL.
4. **`POST /api/avatar/re-roll`**: Re-rolls avatar with style preset.

---

## 5. Development Workstreams

1. **Workstream 1: Jac Core & MBTI Engine (`backend/jac/`)**
   - Integrate `mbti_questions_28.json` and `mbti_calculator.py`.
   - Implement `IntakeWalker`, `TraitWalker`, and `AvatarWalker`.
2. **Workstream 2: Image Adapter & Circuit Breaker (`backend/services/avatar/`)**
   - Build 3-layer prompt generator + 10s circuit breaker + SVG vector fallback renderer.
3. **Workstream 3: Next.js Frontend (`frontend/`)**
   - Build quiz UI (`/test`), public permalinks (`/result/[sessionId]`), deep analysis view, and $9:16$ story card exporter.
