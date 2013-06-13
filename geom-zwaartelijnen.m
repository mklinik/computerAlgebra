// In an arbitrary triangle, all medians meet at the same point

S<e1,e2,f1,f2,a1,a2,m1,m2,z> := PolynomialRing(AlgebraicClosure(RationalField()), 9);

// M lies on CF
h1 := f1*m2 - f2*m1;

// M lies on BE
h2 := m2*(e1-2) - e2*(m1-2);

// E in the middle of AC
h3 := 2*e1-a1;
h4 := 2*e2-a2;

// F in the middle of AB
h5 := 2*f1-2-a1;
h6 := 2*f2-a2;

// M lies on DA
t  := (1-a1)*(-m2)-(-a2)*(1-m1);

I := ideal<S | h1, h2, h3, h4, h5, h6, t * z - 1>;
NormalForm(S!1, I);
