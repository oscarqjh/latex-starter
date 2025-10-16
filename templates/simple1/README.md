# simple1 template

## Features

- Clean, professional conference paper layout
- Support for multiple authors and affiliations
- Configurable headers and conference information
- Two-column layout support
- Proper bibliography formatting
- PDF/A compliance support
- Easy customization

## Files

- `confart.cls` - The main document class file (conference article)
- `paper.tex` - Template document with example content
- `references.bib` - Bibliography file
- `/assets` - Folder to keep figures/images used in the paper

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

## Note

You may remove this file safely after downloading the template.
