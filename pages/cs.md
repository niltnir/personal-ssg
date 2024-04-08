title: Computing & Software
---

# Computing & Software

Yes, you read that right, 'CS' stands for computing & software`(sidenote "As
Abelson and Sussman remark in the introduction to SICP, 'computer science' is a
misnomer in the sense that the field is not a science and has almost nothing to
do with computers… with the exception of low-level software, robotics, machine
learning, etc.")`.

Here is where I get to nerd out about, say, interpreters.

I will link information about all things CS including fun hacks. Since
theoretical CS is just an overgrown branch of math, topics may occasionally
[cross boundaries](/math).

`(inject '(hr))`

## [Software Projects](/cs/software.html)

Currently, most of the software projects I work on are web-based. As a result,
I am forced to write a lot of Javascript for the front end. After years of
agony, I have discovered many ways to get around this issue.

1. Most static sites do not require Javascript
2. Most web apps do not require involved Javascript (HTMX)
3. DSLs (Elm, Clojurescript, Purescript, etc.)
4. Language wrappers/FFI (CLOG Framework JS Interop API)
5. WASM???

My current take is to resort to Javascript if and only if I need a lot of
control over some unique piece of interactive interface (e.g., a drawing canvas).
Even then, depending on the complexity of the interface, I will probably
rely on technologies such as Svelte and Typescript.

Aside from the web, I eventually want to dip my toes into more low-level stuff.
In particular, open source firmware, drivers, and OS kernels might be fun to
poke around.`(sidenote "There's also Rust I guess.")`

Anyways, stick around—there's more to come!

`(inject '(hr))`

`(inject '(h2 (@ (id "dotfiles"))
(a (@ (href "https://github.com/niltnir/dotfiles")) "Dotfiles")))`

In terms of software usage, I generally pertain to the following:

- **OS:** \*insert Debian or Debian-based Linux distros here\*
- **Text Editor:** Vim
- **Terminal:** Alacritty
- **Shell:** Bash
- **File Manager:** ranger
- **Browser:** Librewolf | qutebrowser
- **Email Client:** Mutt
- **PDF Viewer:** zathura
- **Image Viewer:** vimiv
- **Media Player:** mpv

I deviate from Vim to Emacs when writing Lisp code but with evil. Modes like
[SLIME](https://slime.common-lisp.dev/) and
[LispyVille](https://github.com/noctuid/lispyville) provide key bindings that
really help when working with s-expressions. I am not a hardcore Emacs user, so
wizardries such as Magit and org-mode are beyond me.

Stuff I want to try at some point:

1. i3 window manager
2. fish shell... maybe even Zsh
3. I don't use Arch btw... at least not yet >:D

`(inject '(hr))`

## [Competitive Programming](https://github.com/niltnir/cp)

I tried competitive programming briefly a few years ago, and it was pretty
fun.`(sidenote "I learned bits of C++ for this purpose only.")` I've only tried
AtCoder Beginner problems, but I may look into others.

CP is also an excuse to study more algorithms and data structures. It's an
area I'm still lacking in, but hopefully, my math Olympiad experience can help
me along.
