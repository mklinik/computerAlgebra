






function mu(i, j, F, G)
  return
    InnerProduct(F[i], G[j])
    /
    InnerProduct(G[j], G[j]);
end function;


function blaat(i, F, G)
  result := mu(i, 1, F, G) * G[1];
  for j := 2 to i-1 do
    result +:= mu(i, j, F, G) * G[j];
  end for;
  return result;
end function;


function GSO(F)
  G := F;
  for i := 2 to NumberOfRows(F) do
    G[i] := F[i] - blaat(i, F, G);
  end for;
  M := F;
  for i := 1 to NumberOfRows(F) do
  for j := 1 to NumberOfColumns(F) do
    M[i,j] := i eq j select 1
         else i lt j select 0
         else        mu(i, j, F, G);
  end for;
  end for;
  return G, M;
end function;


function moo(i, Gstar)
  return
    InnerProduct(Gstar[i-1], Gstar[i-1])
    gt
    2 * InnerProduct(Gstar[i], Gstar[i]);
end function;

function reducedBasis(F)
  G := F;
  Gstar, M := GSO(F);

  n := NumberOfRows(F);
  i := 2;
  while i le n do
    for j := i-1 to 1 by -1 do
      G[i] := G[i] - Floor(M[i,j] + 0.5) * G[j];
      Gstar, M := GSO(G);
    end for;
    if i gt 1 and moo(i, Gstar)
      then
        SwapRows(~G, i-1, i);
        Gstar, M := GSO(G);
        i -:= 1;
      else
        i +:= 1;
    end if;
  end while;

  return G;
end function;


procedure main()
  /*F := Matrix(RealField(2), 3, 3,*/
              /*[RealField(2) ! x : x in*/
              /*[1, 1, 0*/
              /*,1, 0, 1*/
              /*,0, 1, 1*/
              /*]]);*/
  F := Matrix(RealField(2), 3, 3,
              [RealField(2) ! x : x in
              [ 1,  1,  1
              ,-1,  0,  2
              , 3,  5,  6
              ]]);
  print reducedBasis(F);
end procedure;

// vim: ft=magma expandtab ts=2 sw=2
