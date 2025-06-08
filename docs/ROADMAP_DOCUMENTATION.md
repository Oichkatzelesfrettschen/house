# Documentation Roadmap

This file outlines a tentative plan for documenting the `house` codebase.  The repository currently lacks a comprehensive documentation system.  This roadmap summarizes future work needed to generate API references and design notes.

## Goals

- Integrate [Doxygen](https://www.doxygen.nl/) for C and Haskell bindings.
- Build HTML docs using [Sphinx](https://www.sphinx-doc.org/) for narrative guides.
- Avoid modifying original features while adding architecture notes.
- Create an `arch/x86_64_v1` directory as a placeholder for a future 64‑bit port.

## Tasks

1. **Set up tooling**
   - Ensure the `setup.sh` script installs `doxygen` and `python3-sphinx`.
   - Add `docs/Doxyfile` and `docs/conf.py` templates.
2. **Scan sources**
   - Identify undocumented functions under `kernel/`, `net/`, `support/`, and `tests/`.
   - Add `/** */` style comments with summaries, parameters, and return values.
3. **Generate docs**
   - Run `doxygen docs/Doxyfile` to produce API documentation.
   - Build Sphinx HTML docs with `sphinx-build docs docs/_build`.
4. **Architecture port**
   - Create `arch/x86_64_v1/` for a future port.  Copy existing IA32 files as a starting point.
   - Document assumptions and missing features.

This roadmap is intentionally high level; actual implementation depends on
upstream design decisions.
