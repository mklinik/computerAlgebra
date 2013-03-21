






function mu(i, j, F, G)
  return
    InnerProduct(F[i], G[j])
    /
    InnerProduct(G[j], G[j]);
end function;


function fancySum(i, F, G)
  result := mu(i, 1, F, G) * G[1];
  for j := 2 to i-1 do
    result +:= mu(i, j, F, G) * G[j];
  end for;
  return result;
end function;


function GSO(F)
  G := F;
  for i := 2 to NumberOfRows(F) do
    G[i] := F[i] - fancySum(i, F, G);
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


function needsSwap(Gstar, i)
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
    if i gt 1 and needsSwap(Gstar, i)
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


function randomIndependentSquareMatrix(n)
   M := MatrixAlgebra(RationalField(), n) !
     [[Random(-500, 500) : x in [1..n]] : y in [1..n]];
  for i := 1 to n do
    M[i,i] := 0;
  end for;
  return M;
end function;


procedure main()
  /*F := Matrix(RationalField(2), 3, 3,*/
              /*[RationalField(2) ! x : x in*/
              /*[1, 1, 0*/
              /*,1, 0, 1*/
              /*,0, 1, 1*/
              /*]]);*/
  /*F := Matrix(RationalField(2), 3, 3,*/
              /*[RationalField(2) ! x : x in*/
              /*[ 1,  1,  1*/
              /*,-1,  0,  2*/
              /*, 3,  5,  6*/
              /*]]);*/
  /*F := Matrix(RationalField(2), 3, 3,*/
              /*[RationalField(2) ! x : x in*/
              /*[ 1,  0,  0*/
              /*, 0,  1,  0*/
              /*, 1,  1,  0*/
              /*]]);*/
  /*F := Matrix(RationalField(2), 3, 3,*/
              /*[RationalField(2) ! x : x in*/
              /*[ 1, -1,  3*/
              /*, 1,  0,  5*/
              /*, 1,  2,  6*/
              /*]]);*/
  F := Matrix(RationalField(), 4, 4,
              [RationalField() ! x : x in
                [ 1, 1, 1, 0
                , 1, 1, 0, 1
                , 1, 0, 1, 1
                , 0, 1, 1, 1
                ]
              ]);
  print reducedBasis(randomIndependentSquareMatrix(5));
end procedure;

// vim: ft=magma expandtab ts=2 sw=2
