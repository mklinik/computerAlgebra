/*
 * The Groebner basis reduction algorithm
 */

/*
 * Monomials are represented as N-sequences of natural numbers.
 *
 * Terms are represented as tuples <c, m>, where c is an element of the
 * underlying ring, and m is a monomial.
 *
 * Polynomials are represented as lists of terms.
 *
 * For monomials, minus infinity is represented as the empty sequence, which is
 * always smaller than any other sequence.
 */

N := 2;
zeroPolynomial := [];
zeroMonomial := [ 0 : x in [1..N] ];

/*
 * Left fold
 */
function foldl(f, z, xs)
  if #xs eq 0
    then return z;
    else
      acc := z;
      for i:=1 to #xs do
        acc := f(acc, xs[i]);
      end for;
      return acc;
  end if;
end function;

/*
 * Left fold, assumes that the list has at least one element.
 */
function foldl1(f, xs)
  acc := xs[1];
  for i:=2 to #xs do
    acc := f(acc, xs[i]);
  end for;
  return acc;
end function;

/*
 * We define the ordering on monomials as the lexicographical ordering, so
 * comparing two monomials amounts to comparing the tuples representing them.
 */
function monomialGt(m1, m2)
  return m1 gt m2;
end function;


/*
 * Given two terms, returns the term with the greater monomial
 */
function maxTerm(t1, t2)
  return monomialGt(t1[2], t2[2]) select t1 else t2;
end function;

/*
 * Returns the leading term of the polynomial f
 */
function leadingTerm(f)
  return #f eq 0 select zeroPolynomial else foldl1(maxTerm, f);
end function;

/*
 * Returns the leading monomial of the polynomial f
 */
function leadingMonomial(f)
  return leadingTerm(f)[2];
end function;

function leadingCoefficient(f)
  return leadingTerm(f)[1];
end function;

procedure main()
  f := [<1000, [5, 1]>, <2, [1, 2]>];
  print(f);
  lm := leadingMonomial(f);
  print(lm);
  lc := leadingCoefficient(f);
  print(lc);
end procedure;

// vim: ft=magma
