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
