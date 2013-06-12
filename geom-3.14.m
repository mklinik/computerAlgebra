S<l,s,p,q,u,v,k,z> := PolynomialRing(AlgebraicClosure(RationalField()), 8);

h1 := q*u - p*v;
h2 := q*(u-s) - v*(p-l);
g  := q;
t  := (u^2 + v^2)*l^2 - s^2 *(p^2+q^2);

I := ideal<S | h1, h2, g * k - 1, t * z - 1>;

NormalForm(S!1, I);

t2 := ((s - u)^2 + v^2)*l^2 - s^2 * ((p - l)^2 + q^2);
I2 := ideal<S | h1, h2, g * k - 1, t2 * z - 1>;
NormalForm(S!1, I2);
