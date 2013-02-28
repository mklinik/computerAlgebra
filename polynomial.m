// Sanitizes accessing sequences.
// 1) sequence indexes start with 0
// 2) non-existing elements are filled with 0
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
// This effectively shifts all coefficients n places to the right.
function shift(s, n)
  result := s;
  for i := 1 to n do
    result := Insert(result, 1, 0);
  end for;
  return result;
end function;

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

// Adds two sequences point-wise
function plus(s, t)
  return [get(s, i-1) + get(t, i-1) : i in [1..Max(#s, #t)]];
end function;

// Subtracts two sequences point-wise
function minus(s, t)
  return [get(s, i-1) - get(t, i-1) : i in [1..Max(#s, #t)]];
end function;

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
      F0F1G0G1 := $$(plus(F0, F1), plus(G0, G1));

      x := shift(F1G1, n*2);
      y := minus(minus(F0F1G0G1,F0G0), F1G1);

      return plus(plus(x, shift(y, n)), F0G0);
  end if;
end function;


// vim: ft=magma expandtab ts=2 sw=2
