load "polynomial.m";

procedure run(f, name, coerce)
  print "\n\n";
  print "\"", name, "\"";
  for i := 2 to 2000 by 51 do
    t1 := Cputime();
    /*for j := 0 to 1 do*/
      _ := f(coerce([1..i]), coerce([1..i]));
      /*_ := coerce([1..i]);*/
    /*end for;*/
    t2 := Cputime(t1);
    print i, t2;
  end for;
end procedure;

function multiplyBuiltin(f, g)
  return f * g;
end function;

F := FiniteField(13);
P := PolynomialRing(F);
function coerce(s)
  return [F!x : x in s];
end function;

run(multiplyBuiltin, "builtin", func<s|P!s>);
run(multiplyClassically, "classically", coerce);
run(multiplyKaratsuba, "Karatsuba", coerce);
run(multiplyDFT, "DFT", coerce);

quit;
// vim: ft=magma expandtab ts=2 sw=2
