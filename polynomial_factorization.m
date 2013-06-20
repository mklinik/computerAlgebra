q := 3;
R<x> := PolynomialRing(FiniteField(q));

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
