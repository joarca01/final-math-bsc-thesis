# Euclidean proofs of the infinitude of primes in arithmetic progressions
My BSc Thesis in Mathematics at Universitat Autònoma de Barcelona, developed in the academic year 2024/25.

## Introduction
Around the year 300 BC, Euclid proved that there are infinitely many prime numbers. His proof is straightforward: suppose there are only finitely many primes, say $p_1, p_2, \dots, p_m$. Then, the number $Q:=p_1p_2\cdots p_m+1$ is not divisible by any of the primes in the finite list (if it was, then this prime would equal $1$!). Thus, either $Q$ is a new prime not in our list or is divisible by a prime not in our list. This is a contradiction, so there are infinitely many primes.

The simplicity of this proof is certainly striking. One could go further and ask if there are infinitely many primes of a certain form. My BSc Thesis focuses on primes of the form $kn+\ell$, $n\geqslant 0$ for two fixed positive integers $k$ and $\ell$. Moreover, we are interested in giving a proof of the infinitude of such primes in a way that mimics Euclid's proof.

This type of proof, however, is not available for every value of $k$ and $\ell$. To start with, it is well-known that the arithmetic progression $kn+\ell$ contains infinitely many primes if and only if $\gcd(k, \ell)=1$. In these cases, a “Euclidean proof” can be found if additionally $\ell^2\equiv 1 \pmod{k}$. In fact, this is the only case where such a proof can be settled. The main objective of the Thesis is to prove both Schur and Murty Theorems, which combined read:

The arithmetic progression $\equiv\ell\pmod{k}$ admits a Euclidean proof if and only if $\ell^2\equiv 1 \pmod{k}$.

The work also aims to give a systematic and elemental method to build Euclidean proofs whenever the above condition is satisfied.

## Purpose of the repository

This repository serves a double purpose. For one part, it stores the latest version of the BSc Thesis (in English) at `Thesis-document`, together with the Beamer presentation used to defend it (in Catalan) at `Thesis-beamer` (this folder is temporarily unavailable until I defend the Thesis).

However, the main goal of this repository is to host the stable version of the $\LaTeX$, SageMath, and Python codes, together with the HTML templates that *effectively* implement a *systematic*, *elemental*, and *Euclidean* proof of the infinitude of primes $\equiv \ell\pmod{k}$, whenever Schur and Murty's conditions are satisfied. As far as the author is concerned, this is something new to the literature.

## Requirements

The webpage we created (available at http://167.172.185.115) makes the technical requirements to access the proofs virtually nonexistent. In fact, this was a goal from the beginning of the thesis: we wanted to create an automated proof generator publicly accessible. The only requisites to use the webpage are related to the supplied values of $k$ and $\ell$. Specifically, here's how to use the webpage:

- Remember that the values of $k$ and $\ell$ must be positive integers, satisfying $\gcd(k,\ell)=1$.
- Also, the condition $k>\ell$ must be met for $k>1$. Observe that this is not a limitation. If, say, $k=12$ and $\ell=17$, then the progression $12n+17$, $n\geqslant 0$ has the same terms as $12n+5$ for $n\geqslant 1$. The trick consists in considering $17 \bmod{12}=5$. 
- Additionally, the condition $\ell^2\equiv 1 \pmod{k}$ is crucial to guarantee that a Euclidean proof exists. If your brain starts to ache trying to find the suitable values of $\ell$ for a given $k$, the webpage can do this calculation for you.
- Finally, with the chosen arithmetic progression (represented by the elected pair $k$, $\ell$) one can get a personalised Euclidean proof of the fact that there are infinitely many primes $\equiv \ell\pmod{k}$.
  
## Execution of the code

The code for the webpage is located in the folder `HTML-based`.

Alternatively, an early version of the code is available at `PDF-based` (this folder is temporarily unavailable until I defend the Thesis). The relevant file in this folder is `template_euc.ipynb`, which, for a given $k$ and $\ell$, generates a `.tex` file with the proof, which can be later compiled to obtain a `.pdf`. It is enough to have every file in a unique folder and execute the function `ap_euc` in `template_euc.ipynb`. This version of the code requires:

- `tex` compiler
- `stopit` module
- `threading` module
