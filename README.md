# final-math-bsc-thesis
My BSc Thesis in Mathematics at Universitat Autònoma de Barcelona

## Introduction

This repository implements the ideas in my Mathematics Bachelor Thesis, which can be found in ... .

It is well-known in mathematics that the arithmetic progression $kn+\ell$ for $n\geqslant 0$ contains infinitely many primes if $\gcd(k,\ell)=1$. The proof to this fact is Dirichlet's Theorem, which is hard to prove. There are some cases, however, where infinitely many primes $\equiv \ell\pmod{k}$ can be found using a simple argument. In this cases, the ideas that Euclid's uses for his famous proof of the fact that infinitely many primes exist can be extended to prove there exist infinitely many primes $\equiv \ell\pmod{k}$. The condition for such a proof to exist is $\ell^2\equiv 1\pmod{k}$.

The code in this repository implements this specials proofs, for any value of $k$ and $\ell$ satisfying $\ell^2\equiv 1\pmod{k}$.

## Requirements

The code works for non-zero, positive relatively prime integers $k$ and $\ell$, where $k>\ell$ and $\ell^2\equiv 1\pmod{k}$. Other values of $k$ and $\ell$ either have no interest for our quest to find infinitely many primes $\equiv \ell\pmod{k}$ or can be studied via some pair of values which is considered by our code.

(For example, the progression $3n+7$, for $n\geqslant 0$ has the same terms as $3n+1$, for $n\geqslant 1$.)

## Execution of the code

It is enough to have every file in a folder and execute the function ap_euc..

The final proofs are piped into the webpage http://167.172.185.115.
