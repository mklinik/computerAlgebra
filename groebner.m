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

N := 4;
zeroPolynomial := [];
zeroMonomial := [ 0 : x in [1..N] ];
zeroTerm := <0, zeroMonomial>;

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
 * Returns all elements of the sequence that satisfy the predicate
 */
function filter(p, xs)
  result := [];
  for i:=1 to #xs do
    if p(xs[i]) then Append(~result, xs[i]);
    end if;
  end for;
  return result;
end function;

function zipWith(f, xs, ys)
  acc := [];
  for i:=1 to #xs do
    Append(~acc, f(xs[i], ys[i]));
  end for;
  return acc;
end function;

function all(p, xs)
  return foldl(func< b, x | b and p(x)>, true, xs);
end function;

function id(x)
  return x;
end function;

/*
 * We define the ordering on monomials as the lexicographical ordering, so
 * comparing two monomials amounts to comparing the sequences representing them.
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

function leadingTerm(f)
  // if f is the zero polynomial, we return the minus infinity mononomial
  return foldl(maxTerm, <0, []>, f);
end function;

function leadingMonomial(f)
  return leadingTerm(f)[2];
end function;

function leadingCoefficient(f)
  return leadingTerm(f)[1];
end function;

function greaterThanEqual(x, y)
  return x ge y;
end function;

/*
 * Monomial m1 divides m2 if every exponent of m2 is greater or equal to the corresponding exponent
 * of m1.
 */
function divides(m1, m2)
  if #m2 eq 0 then return false; end if; // m2 is the minus infinity thingy
  return all(id, zipWith(greaterThanEqual, m2, m1));
end function;

function minus(x, y)
  return x - y;
end function;

function plus(x, y)
  return x + y;
end function;

/*
 * Divides two monomials by subtracting the representing lists elementwise
 */
function divideMonomial(m1, m2)
  return zipWith(minus, m1, m2);
end function;

/*
 * Multiplies two monomials by adding the representing lists elementwise
 */
function multiplyMonomial(m1, m2)
  return zipWith(plus, m1, m2);
end function;

/*
 * Divides two terms by dividing the coefficients and the monomials
 */
function divideTerm(t1, t2)
  return <t1[1] / t2[1], divideMonomial(t1[2], t2[2])>;
end function;

/*
 * Multiplies two terms by multiplying the coefficients and the monomials
 */
function multiplyTerm(t1, t2)
  return <t1[1] * t2[1], multiplyMonomial(t1[2], t2[2])>;
end function;

/*
 * Multiplies a term t to a polynomial f
 */
function multiplyTermPolynomial(t, f)
  if t[1] eq 0 then return zeroPolynomial;
  end if;

  result := [];
  for i:=1 to #f do
    Append(~result, multiplyTerm(t, f[i]));
  end for;
  return result;
end function;

function subtractPolynomial(f1, f2)
  g := f1;
  for j:=1 to #f2 do
    processed := false;
    for i:=1 to #f1 do
      if f1[i][2] eq f2[j][2] // the monomials are the same
        then
          g[i][1] -:= f2[j][1]; // subtract the coefficients
          processed := true;
      end if;
    end for;
    if not processed
      then Append(~g, <-f2[j][1], f2[j][2]>);
    end if;
  end for;
  return filter(func<t | t[1] ne 0>, g); // remove all zero terms
end function;

function reduce(B, f)
  J := [ b : b in B | divides(leadingMonomial(b), leadingMonomial(f)) ];
  if #J ne 0
    then
      b := J[1];
      ltf := leadingTerm(f);
      ltb := leadingTerm(b);
      return reduce(B, subtractPolynomial(f, multiplyTermPolynomial(divideTerm(ltf, ltb), b)));
    else
      return f;
  end if;
end function;

/*
 * We get the least common multiple of two monomials by pointwise taking the maximum exponent
 */
function lcmMonomial(m1, m2)
  return zipWith(Max, m1, m2);
end function;

function S(f, g)
  lmf := leadingMonomial(f);
  lmg := leadingMonomial(g);
  ltf := leadingTerm(f);
  ltg := leadingTerm(g);
  lcmfgTerm := <1, lcmMonomial(lmf, lmg)>;
  left := multiplyTermPolynomial(divideTerm(lcmfgTerm, leadingTerm(f)), f);
  right := multiplyTermPolynomial(divideTerm(lcmfgTerm, leadingTerm(g)), g);
  return subtractPolynomial(left, right);
end function;

function unorderedPairs(S)
  return [<S[i], S[j]> : j in [i..#S], i in [1..#S] ];
end function;

function groebnerBasis(B_)
  B := B_;
  P := unorderedPairs(B);
  while #P ne 0 do
    f, g := Explode(P[1]);
    Remove(~P, 1);
    c := reduce(B, S(f, g));
    if c ne zeroPolynomial
    then
      Append(~B, c);
      P cat:= [<b, c> : b in B];
    end if;
  end while;
  return B;
end function;

procedure isGroebnerBasis(B)
  print "S(b, c) reduces to 0 modulo B for each pair b, c in B:";
  print all(func<x | reduce(B, x) eq zeroPolynomial>, [S(B[i], B[j]) : i in [1..#B], j in [1..#B]] );
end procedure;

procedure main()
  // f := [<1000, [5, 1]>, <2, [1, 2]>];
  // print(f);
  // lm := leadingMonomial(f);
  // print(lm);
  // lc := leadingCoefficient(f);
  // print(lc);


  // example 3.1
  f := [ <1, [2,2]> ];
  g := [<-1, [0,0]>, <1, [2,1]>];
  h := [<-1, [0,0]>, <1, [1,2]>];
  B := [g, h];

  /*print(leadingMonomial(f));*/

  /*print(subtractPolynomial(g, h));*/
  /*print(subtractPolynomial(f, g));*/

  /*print(reduce(B, f));*/
  isGroebnerBasis(groebnerBasis(B));
end procedure;

// main();

// vim: ft=magma
