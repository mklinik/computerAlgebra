S<e1,e2,f1,f2,a1,a2,m1,m2,z> := PolynomialRing(AlgebraicClosure(RationalField()), 9);

h1 := (m1-f1)*(2-a1) + (m2-f2)*(-a2);
h2 := (m1-e1)*(-a1) + (m2-e2)*(-a2);
h3 := 2*e1-a1;
h4 := 2*e2-a2;
h5 := 2*f1-2-a1;
h6 := 2*f2-a2;
t  := m1 - 1;

I := ideal<S | h1, h2, h3, h4, h5, h6, t * z - 1>;
NormalForm(S!1, I);
