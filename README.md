# slide-converter

Simple bash utility to convert PDF slides and documents to markdown format.
Such allows for adding additional notes to these materials using your
favorite editor as opposed to be limited to Adobe Acrobat, PowerPoint, etc.

NOTE: The transition from PDF to markdown is lossy in the sense that the text
content is not preserved. Instead, the result created is intended to serve as
a template where the original content (pages/slides) are displayed as images.
Although this isn't necessarily ideal, it was the simplest idea to implement
for the time being so that I could get back to work.

Functional Interface

- $1: name/path to the source PDF file
- $2 name of the target note (no extension)

Successful execution of the script will result in the creation of a
subdirectory named similarly to the specified output base filename in
addition to a myriad of shell output. Contained within that directory is the
converted note file in the form of a markdown document and another
subdirectory titled 'attachments' which contains the original documents
content in the form of JPEGs.

## Assumptions

I assume you intend to execute this program on either a Linux or MacOS machine.
No support for Windows is provided at this time.

## Dependencies

The dependencies listed below must be installed and available on the `$PATH`
beforehand.

- [ImageMagick CLI](https://imagemagick.org/)
- Poppler Tools / Plugin: Should come by default with a full installation of
  [TexLive](https://www.tug.org/texlive/) (MacTex on MacOS).
- [pandoc](https://pandoc.org/)

## Visualizing Results
Once you've converted your PDF file into a note document, the results can be
visualized using a myriad of tools. Some examples are given in a non-exhaustive
list below.

- [vscode](https://code.visualstudio.com/docs/languages/markdown)
- [grip](https://github.com/joeyespo/grip)
- [obsidian](https://obsidian.md/)



## Issues

```bash

convert-im6.q16: attempt to perform an operation not allowed by the security policy `PDF' @ error/constitute.c/IsCoderAuthorized/421.

```
This results from a security configuration recommendation that is applied on
various Linux systems. I've yet to see the error pop up on a MacOS machine
(script runs without issues). See this [forum
post](https://bugs.archlinux.org/task/60580) for the solution.
