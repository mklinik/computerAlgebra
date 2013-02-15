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

gcdByQuotremRecursive := function(m, n)
  if n eq 0 then return m;
  else
    _, r := Quotrem(m, n);
    return $$(n, r);
  end if;
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
runGCD(gcdByQuotrem);
runGCD(gcdByQuotremRecursive);
runGCD(GCD);

// vim: ft=magma expandtab ts=2 sw=2
