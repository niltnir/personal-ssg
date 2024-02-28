title: Olympiad Solutions are Up!
date: 2024-02-27 11:50
tags: math, olympiad, tech
---

## Math Updates

### New Content

After some months of working on new problems and doing write-ups (both on paper
and digitally), I present you the [Olympiad corner](/math/oly)!

Before you dive in, be sure to read through [this section](/math#olympiad) on
my math page.

The initial batch of problems range across the four areas (A, C, N, G) pretty
evenly, with some problems coming from multiple areas. There are twenty-five
problems in total, and the difficulty is on the easier side compared to harder
Olympiads. The selection consists of problems I've solved which I found
interesting, cute, instructional, prototypical, and/or anything in between.

Hopefully, the number of problems on this list will grow over time, and as I
gain more experience, the difficulty and diversity will also broaden.

Unfortunately, I do not have geometry diagrams yet, so you'll have to make do
without them for now... sorry :(

### Math Tech... more like Math TeX!

I decided to go with [KaTeX](https://katex.org/) for math rendering. The syntax
is pretty much the same as LaTeX and it *just works*. The nice thing about
KaTeX is that it adheres to the single responsibility principle: it only
renders math. The mess of formatting then becomes the responsibility of the
client.  Although this sounds like a nuisance, on the flip side, it means that
the client gets full control over the page layout. You may miss theorem
numbering and proof environments, but that comes with it the hidden assumption
that the document is static. The dynamic web, however, has a whole host of
tools that allows you to present math in unconventional ways. KaTeX simply
gets out of the way and allows you to do just that.

For Olympiad solutions, my write-ups are stored and organized using a tool
called [VON](https://github.com/vEnhance/von). It maintains modular chunks of
math that I can freely cut and paste wherever I want. This gives me a single
source of truth for any math I write digitally. Want to add a problem to an
article or book? Go to the source and add `\voninclude{PROBLEM_SOURCE}`. Want
to retrieve a problem statement for an app or site?  Run a subprocess with

```bash
von show "PROBLEM_SOURCE" -b 0
```

Then, all I need to do is update VON, and the changes become reflected
everywhere!

For my build process, I have a simple shell script that pulls Olympiad data
from VON, converts LaTeX to KaTeX readable`(sidenote "The syntax that KaTeX
expects is a bit different from traditional TeX/LaTeX (no dollar signs,
environments wrapped in display mode), but good ol' PCRE's got my back.")` form,
and writes the output to temporary files. This is then read by my static site
generator to be integrated with anything added through markdown (including
custom extensions).

`(inject '(hr))`

## Nice-To-Haves and Things-To-Fix

Aside from the major update, before I forget, I'll mention a few minor things I
want add or fix for the site. This may or may not happen any time soon...

1. Add a custom 404 page
2. Fix the URL slugs for the generated Atom feeds
3. Make the ID/URL generation for image galleries consistent across builds
4. Add syntax highlighting for code blocks?

`(inject '(hr))`

## Nano Life Updates/Plans

A few months ago, I decided to order a programmable mechanical keyboard, and
now that I have it, I feel a lot faster compared to when I was only using my
laptop keyboard. This is especially true after having done twenty-five
write-ups.  `(sidenote "Although this may just be placebo...")`

Besides that, for the next few months, I'll probably get back into software. I
have things I want to hack for Zedigo(改). If things go well, maybe an MVP will
be on the horizon?
