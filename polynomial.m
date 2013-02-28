multiplyClassically := function(a, b)
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


multiplyKaratsuba := function(a, b)
end function;



split := function(s, n)
  return
    < [s[i] : i in [1   .. n ]]
    , [s[i] : i in [n+1 .. #s]]
    >;
end function;

// Multiplies a polynomail by x^n.
// This effectively shifts all coefficients n places to the right.
shift := procedure(~s, n)
  for i := 1 to n do
    Insert(~s, 1, 0);
  end for;
end procedure;

// Sanitizes accessing sequences.
// 1) sequence indexes start with 0
// 2) non-existing elements are filled with 0
get := function(s, i)
  if #s gt i
    then return s[i+1];
    else return 0;
  end if;
end function;


// vim: ft=magma expandtab ts=2 sw=2
