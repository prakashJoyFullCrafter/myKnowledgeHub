# Code Review - Expert Curriculum

## Module 1: Code Review Purpose & Value
- [ ] Primary goals: correctness, readability, maintainability, knowledge sharing
- [ ] Secondary goals: mentoring, team consistency, catching bugs early
- [ ] Code review catches ~60% of defects (studies show)
- [ ] Knowledge distribution: no single point of failure in the team
- [ ] Code review as communication, not gatekeeping

## Module 2: What to Review
- [ ] **Correctness**: does the code do what it's supposed to?
- [ ] **Edge cases**: null inputs, empty collections, boundary values, concurrency
- [ ] **Error handling**: proper exceptions, no swallowed errors, meaningful messages
- [ ] **Security**: input validation, SQL injection, XSS, secrets in code, OWASP
- [ ] **Performance**: N+1 queries, unnecessary allocations, O(n^2) in hot paths
- [ ] **Naming**: clear, consistent, domain-aligned
- [ ] **Tests**: are they present? do they test behavior? are they maintainable?
- [ ] **Design**: SOLID violations, wrong abstraction level, unnecessary complexity
- [ ] **API**: backward compatibility, REST conventions, response consistency
- [ ] **Configuration**: hardcoded values, missing env-specific config

## Module 3: How to Review
- [ ] Start with the big picture: read PR description, understand the "why"
- [ ] Review the test first: tests reveal intent
- [ ] Then review the implementation against the tests
- [ ] Limit review size: < 400 lines per PR (studies show quality drops above this)
- [ ] Timebox: 60-90 minutes max per session
- [ ] Use a checklist (customize per project)
- [ ] Annotate with line-specific comments
- [ ] Use "blocking" vs "non-blocking" vs "nit" labels for comment severity

## Module 4: Giving Feedback
- [ ] Be kind: critique the code, not the person
- [ ] Explain WHY: "This could cause N+1 queries because..." not just "fix this"
- [ ] Ask questions: "What happens if X is null here?" (leads them to discover the issue)
- [ ] Suggest alternatives: provide a code snippet when possible
- [ ] Praise good code: "Nice use of the strategy pattern here"
- [ ] Use conventional comments: `suggestion:`, `nit:`, `question:`, `issue:`, `thought:`
- [ ] Don't nitpick: automate formatting/style with linters

## Module 5: Receiving Feedback
- [ ] Don't take it personally: the review is about the code, not you
- [ ] Be grateful: reviewers spend time to help improve your code
- [ ] Ask for clarification when feedback is unclear
- [ ] Don't be defensive: consider the feedback objectively
- [ ] Learn from every review: patterns of feedback reveal growth areas
- [ ] Respond to every comment: resolved, accepted, or discussed

## Module 6: Automating Code Quality
- [ ] Linting: Checkstyle, ktlint, ESLint (enforce style automatically)
- [ ] Static analysis: SonarQube, SpotBugs, PMD, Error Prone
- [ ] Security scanning: Snyk, OWASP Dependency-Check, Trivy
- [ ] Formatting: Spotless, Prettier (format on save / pre-commit)
- [ ] Pre-commit hooks: run checks before commit (lint, format, test)
- [ ] CI checks: run all automated checks on every PR
- [ ] What to automate vs what needs human review

## Module 7: Code Review Process
- [ ] PR template: summary, what changed, how to test, checklist
- [ ] Branch strategy: feature branch → PR → review → merge
- [ ] Required approvals: 1-2 reviewers depending on team size
- [ ] CODEOWNERS: auto-assign reviewers by file path
- [ ] Review SLA: respond within 4 hours (business hours)
- [ ] Stale PR policy: close after 7 days of inactivity
- [ ] Measuring: review turnaround time, PR size, review comments per PR

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Create a review checklist for your project |
| Modules 3-4 | Review 5 real PRs using the checklist and feedback guidelines |
| Module 5 | Reflect on last 10 reviews you received — what patterns emerge? |
| Module 6 | Set up SonarQube + Checkstyle + pre-commit hooks on a project |
| Module 7 | Implement PR template + CODEOWNERS + CI checks |

## Key Resources
- **Google Engineering Practices: Code Review** (google.github.io)
- **Effective Code Reviews** - Trisha Gee (talks & articles)
- Conventional Comments (conventionalcomments.org)
- SmartBear Study: Best Practices for Code Review
