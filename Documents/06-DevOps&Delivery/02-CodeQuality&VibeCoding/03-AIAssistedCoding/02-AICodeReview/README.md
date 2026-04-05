# AI Code Review - Expert Curriculum

## Module 1: AI-Assisted Review Fundamentals
- [ ] AI review complements human review (doesn't replace it)
- [ ] What AI catches well: bugs, security issues, style violations, common mistakes
- [ ] What AI misses: business logic correctness, architectural decisions, team context
- [ ] AI review as first pass: fix AI-found issues before human review
- [ ] Reducing review fatigue: let AI handle the mechanical checks

## Module 2: AI Review Tools
- [ ] Claude Code: `/review` command for PR analysis
- [ ] GitHub Copilot Code Review: automated PR comments
- [ ] CodeRabbit: AI-powered PR review bot
- [ ] Sourcery: Python-focused AI review
- [ ] Amazon CodeGuru: AWS-native code review (Java, Python)
- [ ] SonarQube AI: AI-enhanced static analysis
- [ ] Comparing tools: accuracy, language support, integration, cost

## Module 3: Security Review with AI
- [ ] Prompt: "Review this code for OWASP Top 10 vulnerabilities"
- [ ] SQL injection detection
- [ ] XSS vulnerability detection
- [ ] Authentication and authorization flaws
- [ ] Secrets detection (API keys, passwords in code)
- [ ] Dependency vulnerability scanning
- [ ] SAST (Static Application Security Testing) with AI augmentation

## Module 4: Performance Review with AI
- [ ] Prompt: "Identify performance bottlenecks in this code"
- [ ] N+1 query detection
- [ ] Unnecessary object creation
- [ ] Inefficient algorithm detection (O(n^2) where O(n) is possible)
- [ ] Thread safety issues
- [ ] Resource leak detection (unclosed streams, connections)
- [ ] Database query optimization suggestions

## Module 5: Setting Up AI Review in CI/CD
- [ ] GitHub Actions: trigger AI review on PR creation
- [ ] PR comment integration: AI posts review comments on PR
- [ ] Configuring review rules and focus areas
- [ ] Custom prompts for project-specific guidelines
- [ ] Severity levels: blocking vs suggestion vs info
- [ ] False positive handling: feedback loop to improve accuracy
- [ ] Cost management: which PRs get AI review (size, risk)

## Module 6: Custom AI Review Guidelines
- [ ] Project-specific review rules in `.ai-review.yml` or CLAUDE.md
- [ ] Architecture rules: "All controllers must use DTOs, not entities"
- [ ] Naming conventions: "Repository methods must follow Spring Data naming"
- [ ] Testing rules: "Every public method must have a unit test"
- [ ] Security rules: "No `@RequestParam` without `@Valid`"
- [ ] Building institutional knowledge into AI review prompts

## Module 7: AI + Human Review Workflow
- [ ] Step 1: Developer runs AI review locally before pushing
- [ ] Step 2: CI triggers automated AI review on PR
- [ ] Step 3: Developer fixes AI-found issues
- [ ] Step 4: Human reviewer focuses on design, logic, architecture
- [ ] Step 5: Human reviewer validates AI suggestions
- [ ] Measuring effectiveness: bugs caught by AI vs human
- [ ] Continuous improvement: update AI rules based on missed issues

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Set up 2 AI review tools on a project, compare results |
| Module 3 | Run AI security review on a Spring Boot project, fix findings |
| Module 4 | AI performance review: find and fix 5 performance issues |
| Module 5 | Configure AI review in GitHub Actions for auto-review on every PR |
| Modules 6-7 | Write custom review rules for your project, measure AI vs human catch rate |

## Key Resources
- Claude Code documentation (review features)
- GitHub Copilot Code Review documentation
- CodeRabbit documentation
- OWASP Code Review Guide
