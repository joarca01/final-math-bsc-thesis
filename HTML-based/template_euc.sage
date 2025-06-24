#!/usr/bin/env python
# coding: utf-8

# In[29]:


load('utils.sage')
from sage.all import CyclotomicField
from pathlib import Path
import os
import subprocess

def ap_euc(k,l):
    if not (k.is_integer() and l.is_integer()) or (k <= 0 or l <= 0):
        raise ValueError("The values for l and k must be positive integers.")
    if gcd(k,l) != 1:
        raise ValueError("The arithmetic progession considered does not have infinitely many primes since " + "gcd(" + str(l) + "," + str(k) + ")" + " is not 1.")
    if k < l:
        raise ValueError("The arithmetic progession considered is equivalent to the progression " + str(k) + "n+" + str(l%k) + ", n>0. To view the proof, try this one instead.") 
    if l**2 % k != 1 and k != 1:
        raise ValueError("The arithmetic progession considered has infinitely many primes. However, an Euclidean proof does not exist since " + str(l) + "^2="  + str(l**2) + " is not congruent to 1 (mod " + str(k) + ").") 
    if k == 1:
        output2 = subprocess.run(["pandoc", "proof_mod1.tex", "-s", "--mathjax", "-o", "proof_euc.html"])
        print(output2)
        return
    if k == 2:
        output2 = subprocess.run(["pandoc", "proof_mod2.tex", "-s", "--mathjax", "-o", "proof_euc.html"])
        print(output2)
        return

    d = {}
    d['original_k'] = k
    d['original_ell'] = l
    if k % 2 == 0 and k/2 % 2 == 1:
        k = k/2
        l = l % k
    d['k'] = k
    d['ell'] = l
    if d['original_k'] % 2 == 0 and d['original_k']/2 % 2 == 1:
        template23_alt = Path('template23_alt.tex').read_text()
        d['progression_2k_alt'] = subst_dictionary(template23_alt,d)
    else:
        template24_alt = Path('template24_alt.tex').read_text()
        d['progression_2k_alt'] = subst_dictionary(template24_alt,d)
    d['coprimes_list'] = coprimes(k)
    try:
        factored_k = factor_timeout(k)
    except RuntimeError:
        print('The value of k is too large.')
        raise RuntimeError
    primes_div_k_list = prime_divisors(factored_k)
    d['sufix_cyclo_alt'] = sufix_cyclo(k)
    d['eulersphi_k'] = euler_phi(k)

    if l%k != 1:
        d['coset_reps_list'] = coset_reps(d['coprimes_list'],l,k)
        
        u_pos = k
        f_polynomial_roots_list_pos = f_polynomial_roots(l,k,u_pos,d['coset_reps_list'])
        multiple_pos = 2
        while len(f_polynomial_roots_list_pos) != len(set(f_polynomial_roots_list_pos)):
            u_pos = k*multiple_pos
            f_polynomial_roots_list_pos =  f_polynomial_roots(l,k,u_pos,d['coset_reps_list'])
            multiple_pos += 1

        u_neg = -k
        f_polynomial_roots_list_neg = f_polynomial_roots(l,k,u_neg,d['coset_reps_list'])
        multiple_neg = -2
        while len(f_polynomial_roots_list_neg) != len(set(f_polynomial_roots_list_neg)):
            u_neg = k*multiple_neg
            f_polynomial_roots_list_neg =  f_polynomial_roots(l,k,u_neg,d['coset_reps_list'])
            multiple_neg -= 1

        if abs(u_pos) <= abs(u_neg):
            u = u_pos
        else:
            u = u_neg

        f_polynomial_roots_list =  f_polynomial_roots(l,k,u,d['coset_reps_list'])
            
        d['u'] = u
        
        d['poly'] = polynomial(f_polynomial_roots_list)
        d['indep_coef_f'] = d['poly'].subs(x=0)

        d['discriminant'] = d['poly'].discriminant()
        
        d['first_prime'] = find_prime(l,k,d['discriminant'])
        d['prev_primes_list'] = prev_primes(d['first_prime'], l, k)
        try:
            factored_discrim = factor_timeout(d['discriminant'])
            prime_divisors_disc_list = prime_divisors(factored_discrim)
            d['factor_discriminant'] = factored_discrim
            if len(d['prev_primes_list']) > 1:
                d['prime_div_disc_ext'] = factor_timeout(prod(prime_divisors_disc_list + d['prev_primes_list'][:-1]))
            else:
                d['prime_div_disc_ext'] = factor_timeout(prod(prime_divisors_disc_list))
            d['p_exclusions_list'] = sorted(list(set(prime_divisors_disc_list + primes_div_k_list)))
            if k == 3 or k == 4 or k == 6:
                template3_alt = Path('template3_alt.tex').read_text()
                d['prime_divisors_argument_alt'] = subst_dictionary(template3_alt,d)
            else: 
                template2_alt = Path('template2_alt.tex').read_text()
                d['prime_divisors_argument_alt'] = subst_dictionary(template2_alt,d)
            template8_alt = Path('template8_alt.tex').read_text()
            d['prime_divisors_disc_alt'] = subst_dictionary(template8_alt,d)
            template10_alt = Path('template10_alt.tex').read_text()
            d['disc_value_alt'] = subst_dictionary(template10_alt,d)
            template11_alt = Path('template11_alt.tex').read_text()
            d['disc_value_2_alt'] = subst_dictionary(template11_alt,d)
            template14_alt = Path('template14_alt.tex').read_text()
            d['def_Q_alt'] = subst_dictionary(template14_alt,d)
            template15_alt = Path('template15_alt.tex').read_text()
            d['begin_lema1_alt'] = subst_dictionary(template15_alt,d)
        except RuntimeError:
            if len(d['prev_primes_list']) > 1:
                d['prev_primes_fact'] = factor_timeout(prod(d['prev_primes_list'][:-1]))
                d['cdot_alt'] = '\cdot'
            else:
                d['prev_primes_fact'] = ''
                d['cdot_alt'] = ''
            d['disc_value_alt'] = ''
            template17_alt = Path('template17_alt.tex').read_text()
            d['prime_divisors_argument_alt'] = subst_dictionary(template17_alt,d)
            template9_alt = Path('template9_alt.tex').read_text()
            d['prime_divisors_disc_alt'] = subst_dictionary(template9_alt,d)
            template12_alt = Path('template12_alt.tex').read_text()
            d['disc_value_2_alt'] = subst_dictionary(template12_alt,d)
            template13_alt = Path('template13_alt.tex').read_text()
            d['def_Q_alt'] = subst_dictionary(template13_alt,d)
            template16_alt = Path('template16_alt.tex').read_text()
            d['begin_lema1_alt'] = subst_dictionary(template16_alt,d)
        try:
            d['factor_indep_coef_f'] = factor_timeout(d['indep_coef_f'])
            prime_divisors_indep_coef_f_list = prime_divisors(d['factor_indep_coef_f'])
            d['primes_indep_coef_f_list'] = sorted(list(prime_divisors_indep_coef_f_list))
            if len(d['primes_indep_coef_f_list']) == 1:
                d['is_are_alt'] = 'is'
            else:
                d['is_are_alt'] = 'are'
            template6_alt = Path('template6_alt.tex').read_text()
            d['f0_factors_alt'] = subst_dictionary(template6_alt,d)
        except RuntimeError:
            d['kmenys1'] = k - 1
            if k.is_prime():    
                template21_alt = Path('template21_alt.tex').read_text()
                d['cont_proof_div_f0_alt'] = subst_dictionary(template21_alt,d)
            elif d['u'] == d['k']:
                template26_alt = Path('template26_alt.tex').read_text()
                d['argument_k_u_diff_alt'] = subst_dictionary(template26_alt,d)
                template22_alt = Path('template22_alt.tex').read_text()
                d['cont_proof_div_f0_alt'] = subst_dictionary(template22_alt,d)
            else:
                template25_alt = Path('template25_alt.tex').read_text()
                d['argument_k_u_diff_alt'] = subst_dictionary(template25_alt,d)
                template22_alt = Path('template22_alt.tex').read_text()
                d['cont_proof_div_f0_alt'] = subst_dictionary(template22_alt,d)
            template7_alt = Path('template7_alt.tex').read_text()
            d['f0_factors_alt'] = subst_dictionary(template7_alt,d)

        d['index_prime'] = len(d['prev_primes_list'])
        d['index_prime_unk'] = d['index_prime'] + 1 
        d['index_prime_unk_plusone'] = d['index_prime_unk'] + 1

        d['b_value'] = find_b_value(d['poly'], d['first_prime'])
        d['f_at_b'] = d['poly'].subs(x = d['b_value'])
        d['f_at_b_red'] = (d['f_at_b'] % d['first_prime']^2)/d['first_prime']
            
        if k == 3 or k == 4 or k == 6:
            d['prime_divisors_alt'] = ''
            d['section_alt'] = ''
        else:
            d['1plusell'] = 1 + l
            remove_set = {1, l} 
            d['G_minus_H_list'] = [num for num in d['coprimes_list'] if num not in remove_set]
            d['prime_example'] = d['G_minus_H_list'][0]
            
            d['ell_times_prime_example'] = l*d['prime_example']
            d['1plusell_times_prime_example'] = d['1plusell']*d['prime_example']
            d['u_squared'] = d['u']^2
            
            remove_set_2 = set(d['coset_reps_list'])
            d['G_minus_cosets_list'] = [num for num in d['coprimes_list'] if num not in remove_set_2]
            d['coprime_not_in_S'] = d['G_minus_cosets_list'][-2]
            d['try_reps_list'] = try_reps_list(d['coset_reps_list'], d['coprime_not_in_S'], l, k)

            if d['eulersphi_k'] <= 4:
                d['is_are_2_alt'] = 'is'
                d['values_alt'] = 'value'
            else:
                d['is_are_2_alt'] = 'are'
                d['values_alt'] = 'values'
            
            d['cyclotomic_polynomial'] = cyclotomic_polynomial(k)
            d['dividend_check'] = dividend_check(l,k,u,d['prime_example'])
            quocient, d['residue'] = d['dividend_check'].quo_rem(d['cyclotomic_polynomial'])
            d['degree_Bx'] = quocient.degree()

            d['section_alt'] = r'\section{The main Theorem}\label{sec:mainTh}'
            template1_alt = Path('template1_alt.tex').read_text()
            d['prime_divisors_alt'] = subst_dictionary(template1_alt,d)

        template = Path('template_euc.tex').read_text()
        output = subst_dictionary(template,d)
        
        with open('proof_euc.tex','w') as f:
            f.write(output)
        output2 = subprocess.run(["pandoc", "proof_euc.tex", "-s", "--mathjax", "-o", "proof_euc.html"])
        print(output2)
        return 
    
    if l%k == 1:
        d['coset_reps_list'] = d['coprimes_list']

        d['cyclotomic_polynomial'] = cyclotomic_polynomial(k)
        discriminant = d['cyclotomic_polynomial'].discriminant()
        try: 
            d['factor_discriminant'] = factor_timeout(discriminant)
            d['p_exclusions_list'] = sorted(primes_div_k_list)
            template18_alt = Path('template18_alt.tex').read_text()
            d['prime_divisors_disc_cyclo_alt'] = subst_dictionary(template18_alt,d)
            template20_alt = Path('template20_alt.tex').read_text()
            d['disc_cyclo_value_alt'] = subst_dictionary(template20_alt,d)
        except RuntimeError:
            d['disc_cyclo_value_alt'] = ''
            template19_alt = Path('template19_alt.tex').read_text()
            d['prime_divisors_disc_cyclo_alt'] = subst_dictionary(template19_alt,d)
            
        d['indep_coef_cyclotomic'] = d['cyclotomic_polynomial'].subs(x=0)
        
        if k == 3 or k == 4 or k == 6:
            template4_alt = Path('template4_alt.tex').read_text()
            d['polynom_aux_alt'] = subst_dictionary(template4_alt,d)
        else:
            template5_alt = Path('template5_alt.tex').read_text()
            d['polynom_aux_alt'] = subst_dictionary(template5_alt,d)

        template = Path('template_lcong1_euc.tex').read_text()
        output = subst_dictionary(template,d)
        
        with open('proof_euc.tex','w') as f:
            f.write(output)
        output2 = subprocess.run(["pandoc", "proof_euc.tex", "-s", "--mathjax", "-o", "proof_euc.html"])
        print(output2)
        return


# In[ ]:




