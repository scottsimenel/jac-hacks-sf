# High-Level System Design Document

## 1. Architecture Overview & Jac Prominence (JacHammer Ecosystem)

The system is built with **Jac** as the core backend and multi-agent execution orchestrator, hosted, managed, and deployed via **JacHammer** ([https://jachammer.ai/](https://jachammer.ai/)). 

JacHammer acts as the cloud execution engine, managing stateful graphs, Jac agent walkers, database persistence, and BYOM / LLM model routing.

```mermaid
graph TD
    Client[Next.js Client Web App] -->|REST API / WebSockets| APIGateway[Next.js API Gateway / Proxy]
    APIGateway -->|Jac Cloud API| JacHammer[JacHammer Cloud Engine: jachammer.ai]

    subgraph JacHammer Managed Agent Runtime
        JacHammer --> QGraph[1. Adaptive Question Node Graph: Baseline Dataset]
        QGraph -->|MC Choices + Free-form Text| AnsNode[AnswerHistoryNode]
        
        AnsNode --> DeterministicCalc[2. Deterministic MBTI Calculator: EI, SN, TF, JP]
        DeterministicCalc -->|4-Letter MBTI Anchor| Synthesizer[3. Agent 2: Trait & Title Synthesizer]
        Synthesizer --> TraitNode[Trait, MBTI Base & Title Node]
        
        SessionNode[4. UserSessionNode: Post-Quiz Likeness Payload] -->|Passes Photo or Attributes| PromptEngine[5. Agent 3: Avatar Prompt Crafter]
        TraitNode --> PromptEngine
        
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

---

## 3. Jac Graph Model & Data Entities

### 3.1 Core Nodes & Sequence
1. `QuestionNode`: Stores static/dynamic questions from `mbti_questions_28.json`.
2. `AnswerNode`: Stores selected choices and free-form context.
3. `TraitArchetypeNode`: Stores calculated **MBTI Anchor** (e.g. `ENTJ`), dynamically generated title (e.g. *Main Character*, *Captain*), top 3-4 trait badges, and deep analysis breakdown.
4. `UserSessionNode`: Stores UUID `sessionId`, completion state, and **Post-Quiz Likeness Payload** (`photo_url: Option<String>` OR `manual_attributes: { skin_tone, hair_color, hair_length_style, gender_expression, accessories }`).
5. `AvatarArtifactNode`: Stores 3-layer prompt logs, seed, generation provider status, fallback status (`is_fallback: bool`), and rendered image URLs.

---

## 4. API Transport Contracts (Next.js $\leftrightarrow$ JacHammer Cloud)

1. **`POST /api/session/init`**: Initializes session & returns Q1 (zero upfront photo required).
2. **`POST /api/quiz/answer`**: Submits choice (1 or 2) + optional freeform text, returns next question OR `completed: true`.
3. **`POST /api/session/likeness`**: Submits post-quiz photo upload OR manual likeness attributes. Triggers Agent 3 (`AvatarWalker`).
4. **`GET /api/quiz/result/[sessionId]`**: Queries JacHammer persistence database for permalink payload.
5. **`POST /api/avatar/re-roll`**: Re-rolls avatar with style preset.

---

## 5. Development Workstreams

1. **Workstream 1: Jac Core & JacHammer Cloud (`backend/jac/`)**
   - Configure JacHammer project workspace and API environment keys.
   - Implement `IntakeWalker`, `TraitWalker`, and `AvatarWalker`.
2. **Workstream 2: Image Adapter & Circuit Breaker (`backend/services/avatar/`)**
   - Build 3-layer prompt generator + 10s circuit breaker + SVG vector fallback renderer.
3. **Workstream 3: Next.js Frontend & JacHammer Deployment (`frontend/`)**
   - Build quiz UI (`/test`), post-quiz avatar personalization modal, public permalinks (`/result/[sessionId]`), deep analysis view, and $9:16$ story card exporter.
   - Deploy Jac backend to JacHammer cloud and frontend to Vercel/Netlify.
