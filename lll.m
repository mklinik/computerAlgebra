






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
  return G;
end function;


/*function reducedBasis(F)*/
  /*G := GSO(F);*/
  /*return 0;*/
/*end function;*/

procedure main()
  F := Matrix(RealField(2), 3, 3,
              [RealField(2) ! x : x in
              [1, 1, 0
              ,1, 0, 1
              ,0, 1, 1
              ]]);
  /*F := Matrix(3, 3,*/
              /*[1.0, 1.0, 0.0*/
              /*,1.0, 0.0, 1.0*/
              /*,0.0, 1.0, 1.0*/
              /*]);*/
  print F;
  print GSO(F);
end procedure;

// vim: ft=magma expandtab ts=2 sw=2
