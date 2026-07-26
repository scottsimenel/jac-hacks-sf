# High-Level System Design Document

## 1. Architecture Overview & Jac Prominence

The system is built with **Jac** as the core backend and multi-agent execution orchestrator. Jac manages the entire stateful graph: user sessions, adaptive question trees, personality synthesis walkers, deep analysis generation, and avatar prompt assembly.

```mermaid
graph TD
    Client[Next.js Client Web App] -->|REST API / WebSockets| APIGateway[Next.js API Gateway / Proxy]
    APIGateway -->|Jac Service Protocol| JacEngine[Jac Graph Execution Server]

    subgraph Jac Core Architecture
        JacEngine --> SessionNode[UserSessionNode: Photo OR Manual Attributes]
        
        SessionNode -->|Walker: IntakeWalker| QGraph[Adaptive Question Node Graph]
        QGraph -->|Sanitized Answers (8-12 Qs)| AnsNode[AnswerHistoryNode]
        
        AnsNode -->|Walker: TraitWalker| Synthesizer[LLM Trait & Title Agent]
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

## 2. Jac Graph Model & Data Entities

### 2.1 Core Nodes
- `UserSessionNode`: Stores UUID `sessionId`, creation timestamp, completion flag, current question index (8–12), and **Likeness Payload** (`photo_url: Option<String>` OR `manual_attributes: { skin_tone, hair_color, hair_length_style, gender_expression, accessories }`).
- `QuestionNode`: Stores static/dynamic question text, category model (Self, Emotion, Attitude, Action, Social), pre-set choice options, and adaptive branch pointers.
- `AnswerNode`: Captures user's selected choice and/or sanitized free-form text input (max 280 chars).
- `TraitArchetypeNode`: Stores **MBTI Base Archetype** (e.g. Commander, Campaigner, Architect), dynamically generated title (e.g. *Main Character*, *Low-Key Legend*), top 3-4 trait badges, and color theme metadata.
- `DeepAnalysisNode`: Stores 15-dimension raw scores, radar chart matrix data, strengths, flaws, and "Appearance vs. Reality" breakdown.
- `AvatarArtifactNode`: Stores 3-layer prompt logs, seed, generation provider status, watermark status, fallback status (`is_fallback: bool`), and rendered image URLs (1:1 aspect ratio and 9:16 story format).

### 2.2 Core Walkers (Jac Agents)
- `IntakeWalker`: Navigates the `QuestionNode` graph. Enforces hard question bounds (**Min 8, Max 12 questions**) and early stop evaluation (> 85% variance separation).
- `TraitWalker`: Runs generative abilities over sanitized `AnswerNode` history. Computes MBTI baseline anchor, score dimensions, custom title, top trait badges, and deep analysis payload.
- `AvatarWalker`: Constructs the **3-Layer Prompt Stack**:
  1. **Layer 1 (MBTI Character Foundation)**: Visual style of baseline MBTI archetype template (e.g. Commander gear, Campaigner palette).
  2. **Layer 2 (Specialized Trait & Title Overlay)**: Props and background elements derived from dynamic title (e.g. pirate captain hat on ship deck).
  3. **Layer 3 (User Likeness Fusion)**: Physical user attributes (from selfie reference OR manual skin/hair/gender/accessory selectors).
  - *Hierarchy*: Physical user attributes override conflicting trait overlays.

---

## 3. API Transport Contracts (Next.js $\leftrightarrow$ Jac Server)

### 3.1 REST Endpoints

1. **`POST /api/session/init`**
   - **Request**: `{ likeness_type: "photo" | "attributes", payload: {...} }`
   - **Response**: `{ sessionId: "uuid-123", initialQuestion: QuestionPayload }`

2. **`POST /api/quiz/answer`**
   - **Request**: `{ sessionId: "uuid-123", questionId: "q-4", choiceIndex?: number, freeformText?: string }`
   - **Response**: `{ completed: false, nextQuestion: QuestionPayload }` OR `{ completed: true, progressPercent: 100 }`

3. **`GET /api/quiz/result/[sessionId]`** *(Public Permalink)*
   - **Response**: `{ title: "Captain", mbtiBase: "ENTJ", topTraits: [...], deepAnalysis: {...}, avatarUrl: "...", isFallback: false }`

4. **`POST /api/avatar/re-roll`**
   - **Request**: `{ sessionId: "uuid-123", stylePreset?: string }`
   - **Response**: `{ newAvatarUrl: "...", seed: 98765 }`

---

## 4. Image Generation & Fallback Subsystem

- **Timeout Constraint**: Capped at **10.0 seconds**.
- **Adapter Interface**: `generate_caricature(mbti_base, trait_modifiers, likeness_input) -> ImageResult`
- **Fallback Circuit Breaker**:
  - If external generator throws timeout/API error, `AvatarWalker` routes to `SVGAdapter`.
  - `SVGAdapter` returns a crisp, vector-styled SVG poster combining the MBTI character base color palette with dynamic text overlays.

---

## 5. Development Workstreams

1. **Workstream 1: Jac Core & Multi-Agent Graph (`backend/jac/`)**
   - Implement nodes, edges, and walkers (`IntakeWalker`, `TraitWalker`, `AvatarWalker`).
   - Implement moderation layer and 8–12 question bounds.
2. **Workstream 2: Image Adapter & Fallback Engine (`backend/services/avatar/`)**
   - Build pluggable image generation client + 10s circuit breaker + SVG vector fallback renderer.
3. **Workstream 3: Next.js Frontend & Permalinks (`frontend/`)**
   - Build quiz UI, public permalink route `/result/[sessionId]`, deep analysis view, and 9:16 story poster generator.
