// File comparePolynomial.m

// Compares the runtime behaviour of several polynomial multiplication
// algorithms.

// Use as follows:
// - Run it with the following command, then grab a cup of coffee and wait.
//    $ magma -b comparePolynomial.m | tee out.txt
// - Amend out.txt to remove the first few lines where it says "loading
// polynomial.m".
// - Use gnuplot to plot the result
//    $ gnuplot plot.txt
//   where plot.txt is a file containing these lines:
//    set terminal png
//    set output "polynomial_measurements.png"
//    set grid
//    plot [:] [-1:] for [IDX=0:3] 'out.txt' i IDX u 1:2 w lines title columnheader(1)

load "polynomial.m";

MAX_DEGREE := 3000

// Runs the given polynomial multiplication algorithm with polynomials of
// increasing degree, and output the running time on stdout.
procedure run(f, name, coerce)
  print "\n\n";
  print "\"", name, "\"";
  for i := 2 to MAX_DEGREE by 55 do
    t1 := Cputime();
      _ := f(coerce([1..i]), coerce([1..i]));
    t2 := Cputime(t1);
    print i, t2;
  end for;
end procedure;


// Wrap the built in multiplication operator in a function, so we can pass it to
// `run`.
function multiplyBuiltin(f, g)
  return f * g;
end function;

// This magic number is the smallest prime p such that p - 1 mod 2^k = 1 where k
// is the smallest number such that d < 2^k where d is the degree of the
// polynomials we want to multiply.  If you increase the value MAX_DEGREE, adapt
// p accordingly.
p := 12289

// use this snippet to calculate an appropriate prime number to use as the field
// size
// p := 1;
// for i := 1 to 100000 do
//   p := NextPrime(p);
//   if p mod 4096 eq 1
//     then print p;
//   end if;
// end for;

F := FiniteField(p);
P := PolynomialRing(F);

// Coerce every element in a sequence to be of the field F.
function coerce(s)
  return [F!x : x in s];
end function;

run(multiplyBuiltin, "builtin", func<s|P!s>); // coerces s to be a P-polynomial
run(multiplyClassically, "classically", coerce);
run(multiplyKaratsuba, "Karatsuba", coerce);
run(multiplyDFT, "DFT", coerce);

quit;
// vim: ft=magma expandtab ts=2 sw=2
