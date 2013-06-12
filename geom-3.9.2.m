
S<a,b1,b2,z> := PolynomialRing(AlgebraicClosure(RationalField()), 4);

h1 := b1 * (a - b1) - b2^2;
t := b1^2 * (b1 - a)^2 - b2^4;

I := ideal<S | h1, t * z - 1>;

NormalForm(S!1, I);
