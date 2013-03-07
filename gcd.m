// File gcd.m

// Several variations of calculating the greatest common divisor of two numbers

// Calculates the GCD of two numbers by repeated subtraction.
gcdBySubtraction := function(M, N)
  m := M lt 0 select -M else M;
  n := N lt 0 select -N else N;
  m, n := Explode(n gt m select <n, m> else <m, n>);

  while n gt 0 do
    m -:= n;
    if n gt m then
      n, m := Explode(<m, n>);
    end if;
  end while;

  return m;
end function;

// Calculates the GCD of M and N using quotient and remainder.
// This is an iterative algorithm.
gcdByQuotrem := function(M, N)
  m := M lt 0 select -M else M;
  n := N lt 0 select -N else N;
  m, n := Explode(n gt m select <n, m> else <m, n>);

  while n gt 0 do
    _, r := Quotrem(m, n);
    m := n;
    n := r;
  end while;

  return m;
end function;

// Calculates the GCD of m and n using quotient and remainder.
// This is a recursive algorithm.
gcdByQuotremRecursive := function(m, n)
  if n eq 0 then return m;
  else
    _, r := Quotrem(m, n);
    return $$(n, r);
  end if;
end function;

// The extended Euclidean algorithm.
extGcd := function(a, b)
  if b eq 0 then return 1, 0;
  else
    q, r := Quotrem(a, b);
    s, t := $$(b, r);
    return t, s - q * t;
  end if;
end function;

inverse := function(n, p)
  s, _ := extGcd(n, p);
  return s mod p;
end function;

// Calculates the continued fraction representation of a rational number.
// The result is the sequence of coefficients in reverse order
CF_ := function(a, b)
  q, r := Quotrem(a, b);
  if r eq 0 then return [* q *];
  else
    return Append($$(b, r), q);
  end if;
end function;

// Calculates the continued fraction representation of a rational number.
// The rational number is given by its numerator a and denominator b: a/b
// Returns the sequence of coefficients of the CF representation.
CF := function(a, b)
  return Reverse(CF_(a, b));
end function;

runGCD := procedure(gcd)
t1 := Cputime();
for x := -500 to 500 do
for y := -500 to 500 do
  _ := gcd(x, y);
end for;
end for;
t2 := Cputime(t1);
print t2;
end procedure;

/*runGCD(gcdBySubtraction);*/
/*runGCD(gcdByQuotrem);*/
/*runGCD(gcdByQuotremRecursive);*/
/*runGCD(GCD);*/

// vim: ft=magma expandtab ts=2 sw=2
