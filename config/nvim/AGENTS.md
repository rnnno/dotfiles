# Repository Guidelines

## Project Structure & Module Organization
This directory contains Neovim configuration managed as Lua modules.

- `init.lua`: entry point; loads core modules.
- `lua/core/`: startup fundamentals (`options.lua`, `keymaps.lua`, `autocmd.lua`, `lazy.lua`).
- `lua/plugins/`: plugin specs consumed by `lazy.nvim` (one file per concern).
- `lua/lsp/`: native Neovim LSP setup (`init.lua` aggregates per-server files).

## Architecture & Load Flow
1. `init.lua` loads `core.keymaps`, `core.options`, `core.autocmd`, then `core.lazy`.
2. `core.lazy` bootstraps `lazy.nvim` and imports `plugins`.
3. `plugins/lsp.lua` wires `nvim-lspconfig` + `mason` and enables `require('lsp')` servers.
4. `lsp/init.lua` discovers `lua/lsp/*.lua` (except `init`/`util`) and applies common capabilities/handlers.

When adding a language server, create `lua/lsp/<server>.lua`; discovery is automatic.
`<server>` must match a valid `nvim-lspconfig`/`mason-lspconfig` server ID because the filename is used for `ensure_installed` and `vim.lsp.enable`.
Discovery uses `vim.api.nvim_get_runtime_file(..., true)`, so scope is full `runtimepath`, not only this repository.

### JS/TS and Deno Split
- `ts_ls` and `eslint` do not attach when a Deno root is detected.
- `denols` attaches only when a Deno root is detected.
- If TS/ESLint does not start in a Deno project, treat it as intended behavior.

## Build, Test, and Development Commands
Use headless Neovim commands for verification:

- `nvim --headless "+Lazy! restore" +qa`: install/sync plugins to the lockfile state.
- `nvim --headless +qa`: startup smoke test. In sandbox/CI, write-permission warnings may appear even with valid config.

## Coding Style & Naming Conventions
- Language: Lua (`.lua`), 2-space indentation, no tabs.
- Keep files single-responsibility; name by feature or server (`statusline.lua`, `ts_ls.lua`).
- Prefer small tables/functions and explicit `require(...)` paths.
- Follow existing style (`local` first, single-quoted strings, module `return` table).
- For new/edited keymaps, always pass an `opts` table to `vim.keymap.set(...)` with at least `noremap` and `silent`.
- Add `desc` for user-facing mappings; omit only for low-level compatibility mappings.
- Avoid broad refactors unless needed; keep diffs minimal and reviewable.

## Testing Guidelines
1. Start Neovim and confirm no startup errors.
2. Execute the changed workflow yourself (keymaps, plugin UI, LSP actions).
3. For LSP changes, open a target filetype and verify attach/completion/diagnostics directly.

## Environment Prerequisites
- Neovim: `0.11+` (uses `vim.lsp.config` and `vim.lsp.enable`).
- Git: required for `lazy.nvim` bootstrap and plugin fetches.
- Deno: required for Denops/DDC plugins.

## Commit & Pull Request Guidelines
- Commit format: `<type>: <summary>` where type is `feat|fix|refactor|docs|chore`; keep one logical change per commit.
- PRs should include purpose, changed paths, validation commands, and screenshots only for UI-visible changes.
