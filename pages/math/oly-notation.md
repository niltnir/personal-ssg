title: Olympiad Notation
---

# Olympiad Notation Tidbits

Here is a list of almost all the notation used in my solutions. It will be
updated as new ones are introduced.

`(inject '(hr))`

## Set Theory
```math

\(\emptyset\) – The empty set.

\(\mathbb{Z}\), \(\mathbb{Q}\), \(\mathbb{R}\), \(\mathbb{C}\) – Respectively
the set of integers, rational numbers, real numbers, and complex numbers.

\(\mathbb{N}\), \(\mathbb{Z}^+\), \(\mathbb{Z}^{>0} \:\) – The set of positive integers.

\(\mathbb{Z}^{\geq 0} \:\) – The set of non–negative integers.

\(\mathbb{R}^+\), \(\mathbb{R}^{>0} \:\) – The set of positive real numbers.

\(\mathbb{R}^{\geq 0} \:\) – The set of non–negative real numbers.

\(2^A\), \(\mathcal{P}(A)\:\) – The power set of \(A\).

\(\left|A\right|\:\) – The cardinality/size of set \(A\).

\(A \cup B \:\) – The union of sets \(A\) and \(B\).

\(A \cap B \:\) – The intersection of sets \(A\) and \(B\).

\(A \sqcup B \:\) – The disjoint union of sets \(A\) and \(B\).

\(A \setminus B \:\) – The set difference of \(A\) and \(B\): the set of
elements in \(A\) but not in \(B\).

\(A \subset B \:\) – The set \(A\) is a subset of \(B\) where equality may hold.

\(A \supset B \:\) – The set \(A\) is a superset of \(B\) where equality may hold.

\(x \in A \:\) – \(x\) is an element of \(A\).

\(\{x \in A \mid P(x) \} \:\) – The set of elements \(x\) in \(A\) such that
statement \(P(x)\) is true.

\(f: X\to Y \:\) – The function \(f\) is defined from the domain \(X\) to the
codomain \(Y\).

```

`(inject '(hr))`

## Logic
```math

\(\forall \:\) – For each. Occasionally, for every.

\(\exist \:\) – There exists. For some.

\((A \implies B) \:\) – \(A\) implies \(B\).

\((A \impliedby B) \:\) – \(A\) if \(B\).

\((A \iff B) \:\) – \(A\) if and only if \(B\), \(A\) is equivalent to \(B\).

```

`(inject '(hr))`

## Algebra
```math

\(f(x) \:\) – The value of function \(f\) at \(x\).

\(f^{–1}(x) \:\) – The value of the inverse function of \(f\) at \(x\).

\(f'(x) \:\) – The derivative of function \(f\) at \(x\).

\(\left|x\right| \:\) – The magnitude of \(x\).

\(\sum_{cyc}f(a_1, a_2, \dots, a_n) \:\) –  The cyclic sum of a function across
variables \(a_1, a_2, \dots, a_n\).

\(\sum_{sym}f(a_1, a_2, \dots, a_n) \:\) –  The symmetric sum of a function across
variables \(a_1, a_2, \dots, a_n\).

\((a_i)\) – The sequence of numbers \(a_1, a_2, a_3, \dots\)

\((a_1, a_2, \dots, a_n) \:\) – The ordered tuple of \(n\) elements.

\(\deg(P) \:\) – The degree of a polynomial \(P\).

\(\min\{x, y\} \:\) – The minimum value between \(x\) and \(y\).

\(\max\{x, y\} \:\) – The maximum value between \(x\) and \(y\).

\(\Re(z)\) – The real part of complex number \(z\).

\(\Im(z)\) – The imaginary part of complex number \(z\).

\(\overline{z}\) – The complex conjugate of \(z\).

```

`(inject '(hr))`

## Combinatorics
```math

\(\lfloor x\rfloor \:\) – The floor of \(x\): the greatest positive integer
less than or equal to \(x\).

\(\lceil x\rceil \:\) – The ceiling of \(x\): the least positive integer
greater than or equal to \(x\).

\(n! \:\) – The number of permutations of \(n\) distinguishable objects, that is,
\(n\cdot (n–1)\cdot (n–2)\cdots 2\cdot 1\).

\(\binom{n}{k} \:\) – The number of ways to choose \(k\) objects from \(n\)
distinguishable objects.

\(\deg(V) \:\) – The degree of a vertex \(V\) in a graph.

\(K_n \:\) – The complete graph on \(n\) vertices, unless otherwise specified.

```

`(inject '(hr))`

## Number Theory
```math

\(a \mid b \:\) –  \(a\) divides \(b\).

\(a \nmid b \:\) –  \(a\) does not divide \(b\).

\(a \perp b \:\) –  \(a\) is relatively prime to \(b\).

\(a \equiv b \pmod{n}\:\) – The remainder of \(a\) is congruent to the
remainder of \(b\) upon division by \(n\).

\(\gcd(a, b) \:\) –  The greatest common divisor of \(a\) and \(b\).

\(\gdef\lcm{\operatorname{lcm}}\)
\(\lcm(a, b) \:\) –  The least common multiple of \(a\) and \(b\).

\(\tau(n) \:\) – The number of divsors of \(n\), unless otherwise specified.

\(\sigma(n) \:\) – The sum of the divsors of \(n\), unless otherwise specified.

\(\varphi(n) \:\) – Euler's totient function unless otherwise specified.

\(v_p(a)\:\) – The \(\textit{p}\)–adic valuation of \(a\): the greatest value
of \(k\) such that \(p^k\) divides \(a\), where \(p\) is a prime number.

\(\gdef\ord{\operatorname*{ord}}\)
\(\ord_p(a)\:\) – The order of \(a\) modulo \(p\): the minimum value of
\(d\) such that \(a^d \equiv 1 \pmod{p}\).

```

`(inject '(hr))`

## Geometry
```math

\(\overline{AB} \:\) –  The segment between points \(A\) and \(B\).

\(\widehat{AB} \:\) –  The minor arc between points \(A\) and \(B\) unless
otherwise specified.

\(\widehat{ABC} \:\) –  The arc between points \(A\) and \(C\) containing \(B\)
.

\(AB \parallel XY \:\) – The line \(AB\) is parallel to line \(XY\).

\(AB \perp XY \:\) – The line \(AB\) is perpendicular to line \(XY\).

\(AB \cap XY \:\) – The point of intersection between lines \(AB\) and \(XY\).

\(A_1A_2\dots A_n \:\) – The polygon containing points \(A_1\), \(A_2\), \(\dots\)
, \(A_n\).

\((A_1A_2\dots A_n) \:\) – The circle containing points \(A_1\), \(A_2\), \(\dots\)
, \(A_n\).

\([A_1A_2\dots A_n] \:\) – The area of polygon \(A_1A_2\dots A_n\).

\(\measuredangle ABC \:\) –  The directed angle of \(\angle ABC\), where measures
are taken modulo \(180^\circ\). In particular, \(\measuredangle ABC =
–\measuredangle CBA\).

```

`(inject '(hr))`

## Miscellaneous
```math
\(\coloneqq \:\) – Is defined as.

```

