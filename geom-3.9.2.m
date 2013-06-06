
// S<a,b1,b2,p,z> := PolynomialRing(RationalField(), 5);
S<a,b1,b2,p,z> := PolynomialRing(ComplexField(), 5);

h1 := b1 * (a - b1) - b2^2;
h2 := p * (b1 - p);
t := p * (p - a) - b2^2;

I := ideal<S | h1, h2, t * z - 1>;

NormalForm(S!1, I);
