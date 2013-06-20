load "polynomial_factorization.m";

// Example page 357
f := x * (x+1) * (x^2 + 1) * (x^2 + x + 2);
distinctDegreeFactorization(f) eq [x^2 + x, x^4 + x^3 + x + 2];

// Example 14.3
f := x^8 + x^7 - x^6 + x^5 - x^3 - x^2 - x;
distinctDegreeFactorization(f) eq [x, x^4 + x^3 + x - 1, x^3 - x + 1];


f := x^4 + x^3 + x - 1;
success := false;
for i:=0 to 100 do
  result := equalDegreeSplitting(f, 4);
  if #result gt 0 then
    success := f mod result[1] eq 0;
  end if;
end for;
print success;
