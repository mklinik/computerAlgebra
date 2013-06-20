function powerMod(a,n,f) //gives a^n mod f
  nl:=[];
  while n ne 0 do
    n, r := Quotrem(n,2);
    Append(~nl,r);
  end while;
  k:=#nl;
  i:=k-1;
  b:=a;
  while i ge 1 do
    if nl[i] eq 1 then
      b:=(b^2 mod f)*a mod f;
    else b:=b^2 mod f;
    end if;
    i:= i-1;
  end while;
  return b;
end function;

// Algorithm 14.3
function distinctDegreeFactorization(f, q, R)
  R<x> := R;
  hi := x;
  fi := f;
  i := 0;
  g := [];
  repeat
    him1 := hi;
    fim1 := fi;

    i := i + 1;
    hi := powerMod(him1, q, f);

    Append(~g, GCD(hi - x, fim1));

    fi := fim1 div g[i];

  until fi eq 1;

  return g;
end function;

function randomPolynomialWithDegreeLess(n, F, R)
  R<x> := R;
  result := R!0;
  for i := 0 to n-1 do
    c := Random(F);
    result := result + (c * x^i);
  end for;
  return result;
end function;

// Algorithm 14.8
// * f is a squarefree monic polynomail of degree n > 0
// * q is an odd prime power and a divisor of n, such that all irreducible
//   factors of f have degree d
// We represent failure by a list of successes
function equalDegreeSplitting(f, d, q, F, R)
  n := Degree(f);

  a := randomPolynomialWithDegreeLess(n, F, R);
  if Degree(a) le 0 then return []; end if;

  g1 := GCD(a, f);
  if g1 ne 1 then return [g1]; end if;

  // b := a^((q^d - 1) div 2) mod f;
  b := powerMod(a, (q^d - 1) div 2, f);

  g2 := GCD(b-1, f);
  if (g2 ne 1) and (g2 ne f) then return [g2]; else return []; end if;
end function;


// Algorithm 14.10
function equalDegreeFactorization(f, d, q, F, R)
  n := Degree(f);
  if n eq d then return [f]; end if;

  tmp := [];
  success := false;
  while not success do
    tmp := equalDegreeSplitting(f, d, q, F, R);
    success := #tmp gt 0;
  end while;
  g := tmp[1];

  return equalDegreeFactorization(g, d, q, F, R)
    cat equalDegreeFactorization(f div g, d, q, F, R);
end function;


// Algorithm 14.13
function polynomialFactorization(f, q)
  F := FiniteField(q);
  R<x> := PolynomialRing(F);
  hi := x;
  vi := f div LeadingCoefficient(f);
  U := {};
  i := 0;

  repeat
    him1 := hi;
    vim1 := vi;
    i +:= 1;

    // hi := him1^q mod f;
    hi := powerMod(him1, q, f);
    g := GCD(hi - x, vim1);

    if g ne 1 then
      gs := equalDegreeFactorization(g, i, q, F, R);

      vi := vim1;
      for j:=1 to #gs do
        e := 0;
        while vi mod gs[j] eq 0 do
          vi := vi div gs[j];
          e +:= 1;
        end while;
        Include(~U, <gs[j], e>);
      end for;

    end if;
  until vi eq 1;

  return U;
end function;


// Algorithm 14.15
function rootsOverFiniteField(f, q)
  F := FiniteField(q);
  R<x> := PolynomialRing(F);
  h := x^q mod f;

  g := GCD(h - x, f);
  r := Degree(g);
  if r eq 0 then return {}; end if;

  factors := equalDegreeFactorization(g, r, q, F, R);
  return [ x - factor : factor in factors ];
end function;
