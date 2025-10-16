# LaTeX Paper Starter Template

A general-purpose LaTeX template for conference paper or report submissions, based on the CEUR Workshop Proceedings format but adapted for broader use.

## Motivations

This template was developed to streamline the creation of academic reports and conference-style papers. LaTeX offers a cleaner and more professional presentation compared to tools like Google Docs or Microsoft Word. By providing a reusable and adaptable setup, this template enables students, researchers, and educators to efficiently produce well-formatted documents without repeating configuration tasks.

## Who is this for?

This template is aimed at anyone who needs to produce consistently formatted, professional-looking reports or short papers with minimal setup. Typical users include:

- Students preparing course assignments, lab reports, or project write-ups
- Researchers writing short conference papers or workshop submissions
- Educators creating handouts, assignment templates, or reproducible report formats
- Anyone who prefers LaTeX for cleaner typesetting and wants a ready-to-use starter template

Examples of typical uses: semester assignments, lab reports, project deliverables, short conference submissions, and quick technical notes.

## Quick start: download a template without git

You can fetch a template from this repo without cloning it. The scripts below list all available templates under `templates/` and let you interactively pick one (or pass a template name as an argument). Files are downloaded into a new directory named after your chosen template by default.

**macOS / Linux**:

To list available templates:

```bash
curl -fsSL https://raw.githubusercontent.com/oscarqjh/latex-starter/main/get-template.sh | bash -s --
```

Example - download `simple1` template into `MyPaper` folder:

```bash
curl -fsSL https://raw.githubusercontent.com/oscarqjh/latex-starter/main/get-template.sh | bash -s -- simple1 MyPaper
```

**Windows (PowerShell)**:

Interactive session:

```powershell
iwr https://raw.githubusercontent.com/oscarqjh/latex-starter/main/get-template.ps1 -UseBasicParsing | iex
```

Notes:

- The list of templates is read from the `templates/` directory in the repository.
- Environment overrides if you are using a fork:
  - `OWNER_REPO` (default `oscarqjh/latex-starter`)
  - `BRANCH` (default `main`)
  - `TEMPLATES_DIR` (default `templates`)

## Manual Download

Recommended (local):

- Install a local LaTeX distribution (e.g., MiKTeX, TeX Live). Instructions can be found in the documentation of LaTeX Workshop extentsion.
- Use Visual Studio Code with the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension for a smooth editing and build experience. Follow the extension's installation documentation and configure it to use your local TeX distribution.
- Open `/template` folder in VS Code, open `paper.tex`, and use the LaTeX Workshop build/compile commands (or the side-panel) to produce `paper.pdf`.

Helpful local compile commands (PowerShell / terminal):

```powershell
pdflatex paper.tex
bibtex paper
pdflatex paper.tex
pdflatex paper.tex
```

Alternative (online):

- If you prefer not to install a local TeX distribution, you can import all files in `/template` folder into Overleaf:
  1.  Create a new project on Overleaf and choose "Upload Project".
  2.  Upload the contents of `template` folder (all `.tex`, `.cls`, `.bib`, and `assets/` files). Overleaf will compile the project online.

## Available templates

- `simple1` — see `templates/simple1/README.md` for features, files, options, and usage.

## Example

- See `/template/paper.tex` for a complete example with template content that you can replace with your own research.
  The corresponding generated pdf is `/template/paper.pdf`.
- `/examples` contains some academic reports I wrote using this template.

## License

This template is based on the CEUR Workshop Proceedings class and is available under the LaTeX Project Public License (LPPL)."

## Contributing

If this template helped you, and you have ideas to improve the template, contributions are welcome! If you'd like to contribute, please follow these steps:

1. Open an issue to discuss major changes or feature requests before implementing them.
2. Fork the repository and create a feature branch for your changes.
3. Make your changes and test them locally by compiling `paper.tex` (see "How to use" for commands).
   - Recommended quick test (PowerShell):

```powershell
pdflatex paper.tex
bibtex paper
pdflatex paper.tex
pdflatex paper.tex
```

4. Commit your changes with clear messages and open a pull request against `main`.
5. Link your PR to the original issue (if one exists) and include a short description of what you changed and why.

Guidelines:

- Keep changes minimal and well-documented. If you modify `confart.cls`, explain why and include backward-compatible defaults when possible.
- If you add new packages or external dependencies, document them in the README.
- Add example content or tests where appropriate.
- Adding new templates are most welcomed!

Thanks for improving the template — community contributions make it better for everyone!
