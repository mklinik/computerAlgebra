load "polynomial_factorization.m";

q := 3;
F := FiniteField(q);
R<x> := PolynomialRing(F);

// Example page 357
f := x * (x+1) * (x^2 + 1) * (x^2 + x + 2);
distinctDegreeFactorization(f, q, R) eq [x^2 + x, x^4 + x^3 + x + 2];

// Example 14.3
f := x^8 + x^7 - x^6 + x^5 - x^3 - x^2 - x;
distinctDegreeFactorization(f, q, R) eq [x, x^4 + x^3 + x - 1, x^3 - x + 1];


f := x^4 + x^3 + x - 1;
success := false;
for i:=0 to 100 do
  result := equalDegreeSplitting(f, 4, q, F, R);
  if #result gt 0 then
    success := f mod result[1] eq 0;
  end if;
end for;
print success;


SequenceToSet(equalDegreeFactorization(x^4 + x^3 + x - 1, 2, q, F, R))
    eq {x^2 + x + 2, x^2 + 1};

function testFactorization(f, q)
  result := SetToSequence(polynomialFactorization(f, q));
  check := 1;
  for i:=1 to #result do
    g, m := Explode(result[i]);
    check *:= g^m;
  end for;
  if not check eq f then
    print f;
    print result;
    print check;
  end if;
  return check eq f;
end function;


// Exercise 14.3
q := 5;
F := FiniteField(q);
R<x> := PolynomialRing(F);
f := x^17 + 2*x^15 + 4*x^13 + x^12 + 2*x^11 + 2*x^10 + 3*x^9
  + 4*x^8 + 4*x^4 + 3*x^3 + 2*x^2 + 4*x;
testFactorization(f, q);


// Exercise 14.29
q := 3;
R<x> := PolynomialRing(FiniteField(q));
f1 := x^6 - x^5 - 4*x^4 + 2*x^3 + 5*x^2 - x - 2;
testFactorization(f1, q);
f2 := x^6 - 3*x^5 + 6*x^3 - 3*x^2 - 3*x + 2;
testFactorization(f2, q);
f3 := x^5 - 2*x^4 - 2*x^3 + 4*x^2 + x - 2;
testFactorization(f3, q);
f4 := x^6 - 2*x^5 - 4*x^4 + 6*x^3 + 7*x^2 - 4*x - 4;
testFactorization(f4, q);
f5 := x^6 - 6*x^5 + 12*x^4 - 6*x^3 - 9*x^2 + 12*x - 4;
testFactorization(f5, q);


// Exercise 14.23
q := 5;
R<x> := PolynomialRing(FiniteField(q));
f := x^1000+2;
polynomialFactorization(f, q);


// Exercise 14.13
q := 2591;
R<x> := PolynomialRing(FiniteField(q));
f := x^2 - 1005;
polynomialFactorization(f, q);
