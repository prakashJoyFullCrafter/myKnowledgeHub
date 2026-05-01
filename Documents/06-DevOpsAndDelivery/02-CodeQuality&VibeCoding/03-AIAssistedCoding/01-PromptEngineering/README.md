# Prompt Engineering for Developers - Expert Curriculum

## Module 1: Prompt Fundamentals
- [ ] What makes a good prompt? Clear, specific, contextual
- [ ] Prompt structure: Role + Context + Task + Constraints + Output Format
- [ ] Zero-shot: direct question, no examples
- [ ] Few-shot: provide 2-3 examples of desired input/output
- [ ] System prompts: setting persona and behavior rules
- [ ] Temperature and creativity control

## Module 2: Code Generation Prompts
- [ ] Specify language, framework, version: "Java 21 with Spring Boot 3.2"
- [ ] Describe the interface first: "Create a method that takes X and returns Y"
- [ ] Provide constraints: "Use streams, no external libraries, handle null inputs"
- [ ] Ask for tests alongside code: "Write the implementation AND unit tests"
- [ ] Iterative refinement: generate → review → ask for improvements
- [ ] Generating boilerplate: entities, DTOs, mappers, CRUD endpoints
- [ ] Generating from spec: "Given this OpenAPI spec, generate the controller"

## Module 3: Code Explanation & Debugging
- [ ] "Explain this code line by line" - understanding unfamiliar code
- [ ] "What does this regex do?" - complex pattern explanation
- [ ] "Why might this code throw X exception?" - root cause analysis
- [ ] "Find bugs in this code" - AI-assisted code review
- [ ] Rubber duck debugging with AI: describe the problem, often find the answer
- [ ] Stack trace analysis: paste error, get explanation and fix

## Module 4: Refactoring & Improvement Prompts
- [ ] "Refactor this method to follow SOLID principles"
- [ ] "Convert this Java code to idiomatic Kotlin"
- [ ] "Reduce the cyclomatic complexity of this method"
- [ ] "Add proper error handling to this code"
- [ ] "Optimize this database query for performance"
- [ ] "Make this code thread-safe"
- [ ] Before/after comparison prompts

## Module 5: Architecture & Design Prompts
- [ ] "Design the database schema for an e-commerce system"
- [ ] "What design pattern fits this problem?"
- [ ] "Review this architecture decision: X vs Y"
- [ ] "Write an ADR for choosing Kafka over RabbitMQ"
- [ ] "Identify potential issues with this system design"
- [ ] System design interview practice with AI

## Module 6: AI Coding Tools
- [ ] Claude Code (CLI): inline code assistance, file editing, multi-file changes
- [ ] GitHub Copilot: autocomplete, chat, inline suggestions
- [ ] Cursor: AI-native editor with codebase context
- [ ] ChatGPT / Claude: conversational coding assistance
- [ ] Cody (Sourcegraph): codebase-aware AI
- [ ] Choosing the right tool for the right task
- [ ] Combining tools for maximum productivity

## Module 7: Effective AI Collaboration
- [ ] Verify all AI output: AI can hallucinate APIs, libraries, patterns
- [ ] Don't blindly copy-paste: understand before using
- [ ] Provide full context: relevant files, error messages, constraints
- [ ] Break complex tasks into smaller prompts
- [ ] Use AI for drafts, refine yourself
- [ ] Learning from AI suggestions: treat it as a teaching tool
- [ ] When NOT to use AI: security-critical code, novel algorithms, compliance code

## Module 8: Prompt Patterns & Templates
- [ ] **Persona pattern**: "You are a senior Java architect..."
- [ ] **Template pattern**: "Generate a Spring Boot controller using this template: ..."
- [ ] **Chain of thought**: "Think step by step about how to design..."
- [ ] **Flipped interaction**: "Ask me questions to understand my requirements before generating"
- [ ] **Criticism pattern**: "Review this code as if you were a strict senior reviewer"
- [ ] **Output format**: "Return as JSON / markdown table / Mermaid diagram"
- [ ] Building a personal prompt library

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Generate a complete CRUD REST API using prompts only |
| Module 3 | Debug 5 real production bugs using AI assistance |
| Module 4 | Refactor a legacy class using AI-guided refactoring |
| Module 5 | Design a system architecture collaboratively with AI |
| Modules 6-7 | Use 3 different AI tools for a week each, compare effectiveness |
| Module 8 | Build a prompt template library for your daily tasks |

## Key Resources
- Anthropic Prompt Engineering Guide
- OpenAI Prompt Engineering Guide
- Claude Code documentation
- GitHub Copilot documentation
