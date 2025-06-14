#!/usr/bin/env python
# coding: utf-8

# In[12]:


# Remove unnecessary comments / add explanations to the code.

from sage.all import CyclotomicField
from decimal import Decimal
import numpy as np
import threading
import stopit

def subst_dictionary(template, dictionary):
        for ky, val in dictionary.items():
            if type(val) == list: # Remove the square brackets if val is a Python list.
               template = template.replace(f'{{{ky}}}', str(latex(val))[6:-7])  # latex(str(val)[1:-1])
            if ky[-3:] == "alt":
               template = template.replace(f'{{{ky}}}', val)
            else:
                template = template.replace(f'{{{ky}}}', latex(val))
        return template

def coprimes(k):
    return [i for i in range(1, k) if gcd(i, k) == 1]
        
def coset_reps(coprimes_list, l, k):
    list_aux = coprimes_list.copy()
    for i in range(len(list_aux)):
        list_aux.remove(list_aux[i]*l % k)
        if i == len(list_aux)-1:
            return list_aux

def try_reps_list(coset_reps_list, prime_example, l, k):
    return [m for m in coset_reps_list if l*m % k == prime_example]

def f_polynomial_roots(l, k, u, coset_reps_list):
    z = CyclotomicField(k, names = 'ζ').gen()
    return [h(l,k,u)(z**m) for m in coset_reps_list]

def h(l,k,u):
    z = QQ['x'].gen()
    return -(u - z)*(u - z**l)

#def f_polynomial_roots_cong1(k, coset_reps_list):
#    z = CyclotomicField(k, names = 'ζ').gen()
#    return [z**m for m in coset_reps_list]
    
def polynomial(root_list):
    R = QQ['x']
    x = R.gen()
    return R(prod(x-root for root in root_list))

def find_prime(l, k, discf, max_iter = 10000):
    i = 0
    iter_count = 0
    
    if discf != 0:
        while not (ZZ(i*k+l).is_prime() and discf % (i*k+l) != 0):
            #print(factor((i*k+l)))
            #print(factor(discf))
            i += 1
            iter_count += 1
            if iter_count > max_iter:
                raise ValueError(f"No suitable prime found within {max_iter} iterations.")
    else:
        while not ZZ(i*k+l).is_prime():
            i += 1
            iter_count += 1
            if iter_count > max_iter:
                raise ValueError(f"No suitable prime found within {max_iter} iterations.")
    return i*k+l

def prev_primes(prime, l, k):
    return sorted([prime-i for i in range(0, prime, 1) if ((prime-i) % k == l and ZZ(prime-i).is_prime())])

def prime_divisors(factored_num):
    return [p for p, e in factored_num]

def cyclotomic_roots(k):
    z = CyclotomicField(k, names = 'ζ').gen()
    return [z ** i for i in range(1, k + 1) if gcd(i, k) == 1]

def find_b_value(f, prime, max_iter = 10000):
    b = 0
    while b < max_iter:
        f_b = f(x=b) 
        if f_b % prime == 0 and f_b % (prime ** 2) != 0:
            return b
        b += 1
    raise ValueError(f"Could not find a valid b value within {max_iter} iterations.")

def dividend_check(l,k,u,p):
    x = QQ['x'].gen()
    return -u*(x^p+x^(l*p))+x^((1+l)*p)+u*(x+x^l)-x^(1+l)

def sufix_cyclo(k):
    S = [4,5,6,7,8,9,0]
    if k == 11 or k == 12 or k == 13 or k % 10 in S:
        return 'th'
    elif k % 10 == 1:
        return 'st'
    elif k % 10 == 2:
        return 'nd'
    else:
        return 'rd'

def ell_options(k):
    if not k.is_integer() or k <= 0:
        raise ValueError("k must be a positive integer.")
    elif k == 1:
        return [1]
    else:
        return [m for m in range(1,k) if m^2%k == 1]

###### Functions to test the limit of the program ######

def factor_timeout(n, timeout = 2):
    with stopit.ThreadingTimeout(timeout) as to_ctx_mgr: 
        ans = fork(lambda n: ZZ(n).factor(), timeout = timeout)(n)
        return ans
    if to_ctx_mgr.state in [to_ctx_mgr.TIMED_OUT, to_ctx_mgr.INTERRUPTED]:
        print('The factorization takes too long.')
        raise RuntimeError