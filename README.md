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

## Features

- Clean, professional conference paper layout
- Support for multiple authors and affiliations
- Configurable headers and conference information
- Two-column layout support
- Proper bibliography formatting
- PDF/A compliance support
- Easy customization

## Files

- `/template/confart.cls` - The main document class file (conference article)
- `/template/paper.tex` - Template document with example content
- `/template/references.bib` - Bibliography file
- `/template//assets` - Folder to keep figures/images used in the paper

## Usage

1. Use `confart` as your document class:

   ```latex
   \documentclass[hf]{confart}
   ```

2. Set your conference header (optional):

   ```latex
   \setConferenceHeader{Your Conference Name}
   ```

3. Configure your paper details:
   ```latex
   \title{Your Paper Title}
   \author[1]{Your Name}[email=your.email@domain.com]
   \address[1]{Your Institution, Address}
   \conference{Conference Information}
   ```

## Options

- `twocolumn` - Enable two-column layout
- `hf` - Enable header and footer

## Customization

The template provides several commands for customization:

- `\setConferenceHeader{text}` - Set the conference name in header
- `\conference{info}` - Set conference information
- `\AuthorSetup{options}` - Configure author formatting
- `\AddressSetup{options}` - Configure address formatting

## Example

- See `/template/paper.tex` for a complete example with template content that you can replace with your own research.
  The corresponding generated pdf is `/template/paper.pdf`.
- `/examples` contains some academic reports I wrote using this template.

## How to use

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

Thanks for improving the template — community contributions make it better for everyone!
