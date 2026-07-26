# High-Level System Design Document

## 1. Architecture Overview & Jac Prominence

The system is built with **Jac** as the core backend and multi-agent execution orchestrator. Jac manages the entire stateful graph: user sessions, adaptive question trees, personality synthesis walkers, deep analysis generation, and avatar prompt assembly.

```mermaid
graph TD
    Client[Next.js Client Web App] -->|WebSocket / HTTP API| JacEngine[Jac Graph Execution Server]

    subgraph Jac Core Architecture
        JacEngine --> SessionNode[UserSessionNode: Photo OR Manual Attributes]
        
        SessionNode -->|Walker: IntakeWalker| QGraph[Adaptive Question Node Graph]
        QGraph -->|Collects MC + Free-form Answers| AnsNode[AnswerHistoryNode]
        
        AnsNode -->|Walker: TraitWalker| Synthesizer[LLM Trait & Title Agent]
        Synthesizer --> TraitNode[Trait & Archetype Node]
        Synthesizer --> DeepNode[Deep Analysis Node]
        
        TraitNode -->|Walker: AvatarWalker| PromptEngine[Likeness + Caricature Prompt Crafter]
        PromptEngine --> ImageAdapter[Image Gen API Adapter (Replicate/Fal/FLUX)]
    end
    
    ImageAdapter -->|Avatar Asset URL| Client
    DeepNode -->|Radar Graph & Report Data| Client
```

---

## 2. Jac Graph Model & Data Entities

### 2.1 Core Nodes
- `UserSessionNode`: Stores session token, completion state, current node pointer, and **Likeness Payload** (`photo_url: Option<String>` OR `manual_attributes: { skin_tone, hair_color, hair_length_style, gender_expression, accessories }`).
- `QuestionNode`: Stores static/dynamic question text, category model (Self, Emotion, Attitude, Action, Social), pre-set choice options, and adaptive branch pointers.
- `AnswerNode`: Captures user's selected choice and/or free-form text input.
- `TraitArchetypeNode`: Stores dynamically generated title (e.g. *Main Character*, *Low-Key Legend*), top 3-4 trait badges, and color theme metadata.
- `DeepAnalysisNode`: Stores 15-dimension raw scores, radar chart matrix data, strengths, flaws, and "Appearance vs. Reality" breakdown.
- `AvatarArtifactNode`: Stores prompt logs, seed, generation provider status, watermark status, and final rendered image URLs (1:1 aspect ratio and 9:16 story format).

### 2.2 Core Walkers (Jac Agents)
- `IntakeWalker`: Navigates the `QuestionNode` graph. Analyzes incoming answer state to select or dynamically spawn follow-up `QuestionNode`s tailored to previous responses.
- `TraitWalker`: Runs generative abilities over `AnswerNode` history. Computes score dimensions, generates the custom unhinged title, top trait badges, and deep analysis payload.
- `AvatarWalker`: Fuses visual likeness markers (either extracted from user photo OR parsed from manual attribute selectors like skin color, hair type, and gender) with `TraitArchetypeNode` traits into a structured prompt, dispatching calls to the abstracted image service adapter.

---

## 3. Image Generation Backend Abstraction Layer
To ensure low cost and easy MVP setup, the avatar generation is decoupled via an adapter interface:
- **Adapter Interface**: `generate_caricature(likeness_input: LikenessData, prompt: str, style_preset: str) -> str`
- **Supported Providers (Pluggable)**:
  - **Option A (MVP Recommended)**: Replicate API (FLUX.1 / InstantID / PuLID for photo face preservation OR text-conditioned FLUX for manual attribute prompts).
  - **Option B**: Fal.ai (Fast SDXL InstantID endpoints).
  - **Option C**: OpenAI DALL-E 3 / gpt-4o vision/text prompt pipeline fallback.

---

## 4. Shareable Poster & Virality Pipeline
- **Edge OG Image Generator**: Endpoint returning personalized meta images for links shared on social platforms.
- **Client-Side / Server-Side Canvas Renderer**: Renders 9:16 vertical poster combining avatar image, unhinged title, radar chart overlay, and referral QR code/link.

---

## 5. Development Workstreams

1. **Workstream 1: Jac Core & Multi-Agent Graph (`backend/jac/`)**
   - Implement nodes, edges, and walkers (`IntakeWalker`, `TraitWalker`, `AvatarWalker`).
   - Implement dynamic question generation logic using Jac's LLM capabilities.
2. **Workstream 2: Image Adapter & Avatar Prompting (`backend/services/avatar/`)**
   - Build pluggable image generation client with face preservation + attribute-based caricature styling.
3. **Workstream 3: Next.js Frontend & Social Sharing (`frontend/`)**
   - Build quiz interface (multiple choice + freeform text), likeness picker (photo vs attributes), progress tracking, results hub, deep analysis drawer, and 9:16 story card generator.
