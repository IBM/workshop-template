# Advocacy Workshop

This is a template for workshops hosted on Gitbook. To view it online, go to:

<https://ibm-developer.gitbook.io/workshop-template/>

Create a new repo based off this template, and use the folowing folders as a guide:

```ini
- data (any data (CSV, JSON, etc files) to be used)
- notebooks (any Jupyter notebooks can go here)
- src (any application source code can go here)
- workshop (this is where the workshop is documented)
|_ .gitbook (images should go here)
|_ <folder-n> (these are exercises for the workshop)
  |_README.md (the steps for the exercise, in Markdown)
|_ README.md (this will appear on the gitbook home page)
|_ SUMMARY.md (this dictates the Table of Contents)
.gitbook.yaml (tells GitBook to only read the stuff in 'workshop')
.travis.yaml (runs markdownlint by default)
README.md (only used for GitHub.com)
```

## Tips and conventions

### Screenshots

Screenshots look better if they are full page.
Use [ImageMagick](https://imagemagick.org) to create a nice border around images with this command:

```bash
magick mogrify -bordercolor gray -border 2
```
