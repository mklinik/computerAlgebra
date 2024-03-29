// File polynomial.m
//
// Several variations of polynomial multiplication.
// Polynomials are represented as sequences of their coefficients.

// Helper for accessing elements of sequences.
// - sequence indexes start with 0
// - non-existing elements are filled with 0
function get(s, i)
  if #s gt i
    then return s[i+1];
    else return 0;
  end if;
end function;


// Splits a sequence into two.
// The first result sequence has n elements, while the second one has #s - n
function split(s, n)
  return
    [s[i] : i in [1   .. n ]] ,
    [s[i] : i in [n+1 .. #s]] ;
end function;


// Multiplies a polynomail by x^n.
// For our representation of polynomials as sequences, this means shifting all
// coefficients n places to the right.
function shift(s, n)
  result := s;
  for i := 1 to n do
    result := Insert(result, 1, 0);
  end for;
  return result;
end function;


// Multiplies two polynomials using the convolution product.
function multiplyClassically(a, b)
   result := [];
   for x := 0 to (#a - 1) + (#b - 1) do
     sum := 0;
     for y := 0 to x do
       sum := sum + get(a, y) * get(b, x - y);
     end for;
     result[x+1] := sum;
   end for;
   return result;
end function;


// Adds two sequences point-wise
function addPointwise(s, t)
  return [get(s, i-1) + get(t, i-1) : i in [1..Max(#s, #t)]];
end function;


// Subtracts two sequences point-wise
function subtractPointwise(s, t)
  return [get(s, i-1) - get(t, i-1) : i in [1..Max(#s, #t)]];
end function;


// Multiplies two sequences point-wise
function multiplyPointwise(s, t)
  return [get(s, i-1) * get(t, i-1) : i in [1..Max(#s, #t)]];
end function;


// Multiplies two polynomials using Karatsuba's method
function multiplyKaratsuba (F, G)
  if #F lt 2 and #G lt 2
    then
      return [get(F, 0) * get(G, 0)];
    else
      n := 2 ^ Floor(Log(2, Max(#F - 1, #G - 1)));
      F0, F1 := split(F, n);
      G0, G1 := split(G, n);
      F0G0 := $$(F0, G0);
      F1G1 := $$(F1, G1);
      F0F1G0G1 := $$(addPointwise(F0, F1), addPointwise(G0, G1));

      x := shift(F1G1, n*2);
      y := subtractPointwise(subtractPointwise(F0F1G0G1,F0G0), F1G1);

      return addPointwise(addPointwise(x, shift(y, n)), F0G0);
  end if;
end function;


// Zips two sequences.
// Given two sequences s and t, the result will be
//   [ s0, t0, s1, t1, s2, t2, ... ]
// s and t must be of the same length.
function zip(s, t)
  if #s eq 0 then return [];
  else
  result := [s[1], t[1]];
  for i := 1 to #s do
    Append(~result, s[i]);
    Append(~result, t[i]);
  end for;
  return result;
  end if;
end function;


// Discrete Fourier Transform
// Inputs:
//   k: An integer such that 2^k is larger than the degree of f.
//   f: A polynomial with coefficients in a finite field where appropriate
//      primitive roots exist.  The degree of the polynomial must be smaller
//      than 2^k.
//   w: Any primitive 2^k-th root of unity
function DFT(k, f, w)
  if k eq 0
    then
      return [get(f, 0)];
    else
      nDiv2 := 2 ^ (k - 1);

      r0 := [ get(f, j) + get(f, j + nDiv2)        : j in [0..nDiv2-1]];
      r1 := [(get(f, j) - get(f, j + nDiv2)) * w^j : j in [0..nDiv2-1]];

      return zip($$(k - 1, r0, w^2), $$(k - 1, r1, w^2));
  end if;
end function;


// Inverse DFT
// For a description of the parameters, see the DFT function.
function DFTinv(k, f, w)
  return [(1 / (2^k)) * a : a in DFT(k, f, w^(-1))];
end function;


// Actual implementation of the polynomial multiplication by DFT.
// Don't use this function directly, use multiplyDFT instead.
function multiplyDFT_(f, g, w, k)
  a := DFT(k, f, w);
  b := DFT(k, g, w);
  c := multiplyPointwise(a, b);
  return DFTinv(k, c, w);
end function;


// Multiplies two polynomials using the DFT method.
// Both f and g must be sequences of elements of a finite field.
// f must be non-empty.
function multiplyDFT(f, g)
  F := Parent(f[1]);
  k := 1 + Floor(Log(2, Max(#f - 1, #g - 1)));
  w := RootOfUnity(2^k, F);
  return multiplyDFT_(f, g, w, k);
end function;

// vim: ft=magma expandtab ts=2 sw=2 nocindent
