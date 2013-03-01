load "polynomial.m";

procedure run(f, name)
  print "\n\n";
  print "\"", name, "\"";
  for i := 0 to 2000 by 50 do
    t1 := Cputime();
    /*for j := 0 to 1 do*/
      _ := f([1..i], [1..i]);
    /*end for;*/
    t2 := Cputime(t1);
    print i, t2;
  end for;
end procedure;

run(multiplyClassically, "classically");
run(multiplyKaratsuba, "Karatsuba");

quit;
// vim: ft=magma expandtab ts=2 sw=2
