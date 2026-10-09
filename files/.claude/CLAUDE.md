# Global instructions

## Communication

- Be concise. Lead with the answer or the change; minimal preamble and recaps.
- When asked a question, or to evaluate/explore something, do not make
  changes: no edits, prototypes or commits until asked to build.
- Verify before asserting or shipping. Look things up rather than answering
  from memory (tool availability, registry names, flags, behaviour). If
  verification isn't possible, say it's a hypothesis.
- Don't re-propose designs that have already been rejected.

## Changes

- Prefer the smallest change that solves the problem. Don't refactor,
  reformat or "tidy up" code outside the task. Flag extras rather than
  including them.
- Incremental development, so I can learn and follow along: small,
  self-contained steps, each working before moving on.
- Refactoring later is better than overcomplicating things early.
- Before hand-rolling something, check for an existing library and how
  established tools solve the same problem.
- Match the surrounding code: naming, idioms, etc.
- Reduce comment spam to an absolute minimum, in code and config. Name magic
  values instead of commenting them; put reasoning in chat, not the file.
- Tests must check behaviour, not restate the implementation. Prefer
  table-driven tests with explicit expected values.

## Git

- Commit only when asked, unless a project's instructions say otherwise.
  Never push, force-push, rebase shared history or amend published commits
  without explicit instruction.
- One logical change per commit.
- After changes, report what's modified/staged and how many commits are
  unpushed.

## Environment

- CLI tools are managed by [mise](https://mise.jdx.dev). Add project tools
  via `mise.toml`, not system package managers or ad-hoc installs. Personal
  scripts go in `~/.local/bin`.
- Machines: Arch (personal), Ubuntu under WSL2 (work), plus termux and
  lightweight VMs. Don't assume one distro's paths or package names.
- Where a project has a `justfile`, it's the interface for build/test/ship;
  read it before reasoning about how things run and then use it.
- programming languages: latest version and modern idioms; apply modernize hints.
- Default theme is Tokyo Night Moon; font is FiraCode Nerd Font.
- Nerd Font glyphs (U+E000–U+F8FF) get stripped from Edit/Write. Write them
  via code points (e.g. `chr(0xe0b6)`) and verify with a code-point dump.
