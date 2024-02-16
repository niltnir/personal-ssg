title: Japan 2010/4
date: 2024-02-14 01:32
tags: math, olympiad, inequality
---

## Degree-2 Fractional Inequality

```math
Let \( x,\ y,\ z\) be positive real numbers. Prove that \[ \frac {1 + yz +
zx}{(1 + x + y)^2} + \frac {1 + zx + xy}{(1 + y + z)^2} + \frac {1 +
xy + yz}{(1 + z + x)^2}\geq 1.\]
```

`(inject '(hr))`

## Solution

## Motivation

```math
This inequality is homogenized, but manipulating it seems like a huge ordeal.
For example, if we think of adding the terms, we end up with some ugly 6th
degree polynomial on the numerator of the left-hand side. So this suggests to us
that dealing with each term individually is the way to go. One thing we can try
is bounding each individual term against some value. If the sum of these bounds
evaluates to some value greater than or equal to 1, we would be done.

Now to think up such value, we can think about what we don't want. We probably
don't want constants because it's likely that we would be able to adjust
\(x\), \(y\), \(z\) in such a way that allows that inequality to break.
This means that we'll have to have some combination of \(x\), \(y\), \(z\)
in the bound. Another fact that may help is that the terms in the left-hand
side of the inequality are cyclic, suggesting that the bounds are probably
going to be cyclic.

Going through this train of thought, we may eventually find the following bounds:

\[\begin{aligned}
\frac{1+xy+xz}{(1+y+z)^2} \geq \frac{x^p}{x^p + y^p + z^p}, \\
\frac{1+yz+yx}{(1+z+x)^2} \geq \frac{y^p}{x^p + y^p + z^p}, \\
\frac{1+zx+zy}{(1+x+y)^2} \geq \frac{z^p}{x^p + y^p + z^p},
\end{aligned}\]

where \(p\) is some real value. Now to determine \(p\), WLOG, note that \[(1+xy+xz)
(x^p + y^p + z^p) \geq x^p(1+y+z)^2\] must be true.

This looks like weighted AM-GM might do the trick for us, so consider the
following fact about weighted AM-GM.

Whenever we have \[a_{1}^{w_1}a_{2}^{w_2}\cdots a_{n}^{w_n} \leq w_1a_1 +
w_2a_2 + \cdots + w_na_n,\] the product of the exponent and the coefficient on
each variable equate on either sides.

Therefore, we want the exact same thing to happen in our current situation.
Expanding and simplifying our inequality, we get

\[\begin{aligned}
&x^{p+1}y + x^{p+1}z + y^p +xy^{p+1} + xy^pz + z^p +
xyz^p + xz^{p+1} \\
\geq\ &x^py^2 + z^2x^p + 2x^pzy + 2x^pz + 2x^py.\end{aligned}\]

So using the trick on \(x\), we want

\[\begin{aligned}
&(p+1)\cdot 1 + (p+1)\cdot 1 + 1\cdot 1 + 1\cdot 1 +
1\cdot 1 + 1\cdot 1 \\
=\ &p\cdot 1 + p\cdot 1 + p\cdot 2 + p\cdot 2 +
p\cdot 2.\end{aligned}\]

Solving for \(p\), we get \(p=1\).

Letting \(p=1\) in our inequality and simplifying, we get \[x^2y + x^2z + y
+ z \geq 2xz + 2xy.\]

This is equivalent to \((x^2 + 1)(y + z) \geq 2x(y + z)\), which is the same
as \(x^2 + 1 \geq 2x,\) or \((x-1)^2 \geq 0\). To summarize, we have shown
that

\[\begin{aligned}
	\frac{1+xy+xz}{(1+y+z)^2} \geq \frac{x}{x + y +z}, \\
	\frac{1+yz+yx}{(1+z+x)^2} \geq \frac{y}{x + y + z}, \\
	\frac{1+zx+zy}{(1+x+y)^2} \geq \frac{z}{x + y + z}, 
\end{aligned}\]

so adding gives us the result. Also, note that although we have used AM-GM as a
motivator for finding the value of \(p\), it will not actually appear in a formal
write-up of the solution.
```
