# Global instructions

- Be concise. Lead with the answer or the change; minimal preamble and recaps.
- Prefer the smallest change that solves the problem. Don't refactor,
  reformat or "tidy up" code outside the task.
- Match the surrounding code: naming, idioms, etc
- Reduce comment spam to an absolute minimum
- When asked a question, do not make changes
- Commit only when asked. Never push, force-push, rebase shared history or
  amend published commits without explicit instruction.
- One logical change per commit.
- CLI tools are managed by [mise](https://mise.jdx.dev). Add project tools
  via `mise.toml`, not system package managers or ad-hoc installs.
- Machines run Arch (personal) and Ubuntu (work); don't assume one distro's
  paths or package names.
- Incremental development, so I can learn and follow along
- Refactoring later is better than overcomplicating things early
