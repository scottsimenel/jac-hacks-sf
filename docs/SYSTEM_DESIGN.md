# High-Level System Design Document

## 1. Architecture Overview & Jac Prominence (JacHammer Ecosystem)

The system is built with **Jac** as the core backend and multi-agent execution orchestrator, hosted, managed, and deployed via **JacHammer** ([https://jachammer.ai/](https://jachammer.ai/)). 

JacHammer acts as the cloud execution engine, managing stateful graphs, Jac agent walkers, database persistence, and BYOM / LLM model routing.

```mermaid
graph TD
    Client[Next.js Client Web App] -->|REST API / WebSockets| APIGateway[Next.js API Gateway / Proxy]
    APIGateway -->|Jac Cloud API| JacHammer[JacHammer Cloud Engine: jachammer.ai]

    subgraph JacHammer Managed Agent Runtime
        JacHammer --> SessionNode[UserSessionNode: Photo OR Manual Attributes]
        
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
    
    RemoteImage --> DB[(JacHammer Cloud Persistence DB)]
    SVGAdapter --> DB
    DB -->|Public Permalink /result/:sessionId| Client
```

---

## 2. Platform Integration: JacHammer ([jachammer.ai](https://jachammer.ai/))

### 2.1 Role & Responsibilities
- **Development Environment**: Local & cloud-synced Jac development workspace, AST validation, and agent debugging.
- **Managed Agent Server**: Zero-devops serverless hosting of Jac stateful graphs, `IntakeWalker`, `TraitWalker`, and `AvatarWalker`.
- **BYOM / Model Router**: Integrated gateway routing LLM requests for generative abilities (trait synthesis, title generation, prompt crafting).
- **Database & State Storage**: Managed persistence engine storing completed `UserSessionNode` data for permalink rendering.

### 2.2 Component Integration: Baseline MBTI Engine
- **Question Dataset (`backend/data/mbti_questions_28.json`)**: 28 situational questions mapping to 4 dichotomy pairs (`EI`, `SN`, `TF`, `JP`).
- **Deterministic Scoring Calculator (`backend/jac/mbti_calculator.py`)**: Computes 4-letter MBTI baseline anchor code (`ENTJ`, `ENFP`, `INTP`, etc.).

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

## 4. API Transport Contracts (Next.js $\leftrightarrow$ JacHammer Cloud)

1. **`POST /api/session/init`**: Initializes session & returns Q1 via JacHammer endpoint.
2. **`POST /api/quiz/answer`**: Submits choice (1 or 2) + optional freeform text, returns next question OR `completed: true`.
3. **`GET /api/quiz/result/[sessionId]`**: Queries JacHammer persistence database for permalink payload.
4. **`POST /api/avatar/re-roll`**: Re-rolls avatar with style preset.

---

## 5. Development Workstreams

1. **Workstream 1: Jac Core & JacHammer Cloud (`backend/jac/`)**
   - Configure JacHammer project workspace and API environment keys.
   - Implement `IntakeWalker`, `TraitWalker`, and `AvatarWalker`.
2. **Workstream 2: Image Adapter & Circuit Breaker (`backend/services/avatar/`)**
   - Build 3-layer prompt generator + 10s circuit breaker + SVG vector fallback renderer.
3. **Workstream 3: Next.js Frontend & JacHammer Deployment (`frontend/`)**
   - Build quiz UI (`/test`), public permalinks (`/result/[sessionId]`), deep analysis view, and $9:16$ story card exporter.
   - Deploy Jac backend to JacHammer cloud and frontend to Vercel/Netlify.
