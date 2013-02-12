main := procedure()
  print "hello world";
end procedure;

printf "%10.3o\n", 0.6;

f := function(a)
  return a * 2;
end function;

g := func< a | a * 2 >;

gcd := function(M, N)
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

// check whether GCD and gcd agree
exists(counterexample)
  { <x, y> : x in [-250..250], y in [-250..250] | GCD(x,y) ne gcd(x,y) };

// vim: ft=magma expandtab ts=2 sw=2
