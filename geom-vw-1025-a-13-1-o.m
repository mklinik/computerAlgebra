S<b,d1,d2,s,c1,c2,k,z> := PolynomialRing(AlgebraicClosure(RationalField()), 8);

h0 := s^2 - 3; // s is the square root of 3
h1 := (-b)^2 + 3 - 4; // B on circle
h2 := (d1 - 1)^2 + (d2 - s)^2 - 4; // D on circle
h3 := d1 * s - d2;  // D on line
h4 := 3*c1^2 - c2^2;
h5 := (c1-1)^2 + (c2-s)^2 - 4;
g  := d1; // d1 nonzero

t1 := (d1 - b)^2 + d2^2 - ((b  + 1)^2 + 3);
t2 := (d1 - b)^2 + d2^2 - ((d1 + 1)^2 + (d2 - s)^2);

NormalForm(S!1, ideal<S | h0, h1, h2, h3, h4, h5, g * k - 1, t1 * z - 1>);
NormalForm(S!1, ideal<S | h0, h1, h2, h3, h4, h5, g * k - 1, t2 * z - 1>);
