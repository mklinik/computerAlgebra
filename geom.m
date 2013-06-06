// S<u,l,v,z> := PolynomialRing(ComplexField(), 4);
S<u,l,v,z> := PolynomialRing(RationalField(), 4);
// S<u,l,v,z> := PolynomialRing(RealField(), 4);

h := (u-l)^2 + v^2 - l^2;
t := u*(u - 2*l) + v^2;

I := ideal<S | h, t * z - 1>;

NormalForm(u^0, I);
