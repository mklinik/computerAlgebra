load "groebner.m"

procedure main()
  h := [ <1, [2, 0]>, <-2, [1, 1]>, <1, [0, 2]> ];
  t := [ <1, [2, 0]>, <-2, [1, 1]>, <1, [0, 2]> ];
  B := [h];
  reduce(t, h);
end procedure

// vim:ft=magma
