# Hyper-Personalized Personality & Caricature Avatar Generator

An internet-native, multi-agentic web application built with **Jac** and managed/deployed via **JacHammer** ([https://jachammer.ai/](https://jachammer.ai/)) that quizzes users to discover their unhinged personality characteristics and generates personalized caricaturized avatars.

## Project Structure & Specs

- [Product Requirements Document (PRD)](./docs/PRD.md)
- [High-Level System Design Document](./docs/SYSTEM_DESIGN.md)
- [App Development Strategy & Implementation Roadmap](./docs/DEVELOPMENT_STRATEGY.md)
- [Personality Trait & Title Synthesizer Spec (`Agent 2`)](./docs/TRAIT_SYNTHESIZER_SPEC.md)

## Multi-Agent Architecture (Jac)

1. **`IntakeWalker` (Agent 1)**: Manages adaptive quiz questions (Multiple Choice + Free-Form text).
2. **`TraitWalker` (Agent 2)**: Synthesizes responses into unhinged top titles, 3-4 primary trait badges, and deep psychological analysis.
3. **`AvatarWalker` (Agent 3)**: Fuses user likeness (photo upload OR manual skin/hair/gender attribute selector) with caricaturized archetype themes to generate avatars & $9:16$ story share posters.
