q := 3;
F := FiniteField(q);
R<x> := PolynomialRing(F);

function distinctDegreeFactorization(f)
  hi := x;
  fi := f;
  i := 0;
  g := [];
  repeat
    him1 := hi;
    fim1 := fi;

    i := i + 1;
    hi := (him1 ^ q) mod f;

    Append(~g, GCD(hi - x, fim1));

    fi := fim1 div g[i];

  until fi eq 1;

  return g;
end function;

function randomPolynomialWithDegreeLess(n)
  result := R!0;
  for i := 0 to n-1 do
    c := Random(F);
    result := result + (c * x^i);
  end for;
  return result;
end function;

// * f is a squarefree monic polynomail of degree n > 0
// * q is an odd prime power and a divisor of n, such that all irreducible
//   factors of f have degree d
// We represent failure by a list of successes
function equalDegreeSplitting(f, d)
  n := Degree(f);

  a := randomPolynomialWithDegreeLess(n);
  if Degree(a) le 0 then return []; end if;

  g1 := GCD(a, f);
  if g1 ne 1 then return [g1]; end if;

  b := a^((q^d - 1) div 2) mod f;

  g2 := GCD(b-1, f);
  if (g2 ne 1) and (g2 ne f) then return [g2]; else return []; end if;
end function;


function equalDegreeFactorization(f, d)
  n := Degree(f);
  if n eq d then return [f]; end if;

  tmp := [];
  success := false;
  while not success do
    tmp := equalDegreeSplitting(f, d);
    success := #tmp gt 0;
  end while;
  g := tmp[1];

  return equalDegreeFactorization(g, d)
    cat equalDegreeFactorization(f div g, d);
end function;



function polynomialFactorization(f)
  hi := x;
  vi := f div LeadingCoefficient(f);
  U := {};
  i := 0;

  repeat
    him1 := hi;
    vim1 := vi;
    i +:= 1;

    hi := him1^q mod f;
    g := GCD(hi - x, vim1);

    if g ne 1 then
      gs := equalDegreeFactorization(g, i);

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
