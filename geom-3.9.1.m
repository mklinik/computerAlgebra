
S<a,b1,b2,z> := PolynomialRing(RationalField(), 5);

h1 := b1^2 * (a - b1)^2 - b2^4;
t := a * b1 - b1^2 - b2^2;

I := ideal<S | h1, t * z - 1>;

NormalForm(S!1, I);
