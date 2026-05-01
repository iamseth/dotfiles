# OpenCode Instructions

## Core behavior
- Keep changes minimal, correct, and easy to review.
- Preserve existing code style and project conventions.
- Do not broaden scope without a clear reason.
- Prefer finishing one small task cleanly over exploring multiple directions.

## Planning
- Before using tools, make a short plan with 3-6 steps.
- If the task is unclear, make the narrowest reasonable assumption and proceed.
- Do not repeatedly restate the plan after execution starts.

## Tool discipline
- Use the fewest tool calls needed.
- Prefer targeted lookup over broad exploration.
- Prefer ripgrep/glob to locate candidates, then read only the most relevant files.
- Do not read large files end-to-end unless necessary.
- Do not reread the same file unless it has changed or a specific unanswered question remains.
- After 2 unsuccessful search attempts, stop searching broadly and report what is missing.

## Editing discipline
- Make the smallest patch that solves the stated problem.
- Avoid refactors unless they are required to complete the task safely.
- Do not touch unrelated files.
- When possible, change one area and validate that area only.

## Validation
- Run the narrowest validation that gives confidence.
- Do not run broad test suites unless the change requires it.
- Prefer targeted tests, linters, or type checks for the changed files.

## Reviews
- Prefer findings-first responses for reviews.
- Call out bugs, regressions, risks, and missing tests clearly.
- If no issues are found, say so explicitly and mention any residual risk.

## Session efficiency
- If progress stalls or tool use becomes repetitive, stop and summarize the blocker instead of continuing to search.
- When a task is complete, end cleanly rather than continuing with extra suggestions or exploration.


## Misc
- Do not commit the `.tao` directory to Git. If this directory exists, always ignore it for Git history. It is local only.
