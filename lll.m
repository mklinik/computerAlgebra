
/*
 * The mu matrix as a function in i and j
 *
 * Helper function for `GSO`
 */
function mu(i, j, F, Fstar)
  ipG := InnerProduct(Fstar[j], Fstar[j]);
  return ipG eq 0 select 0 else
    InnerProduct(F[i], Fstar[j])
    /
    ipG;
end function;


/*
 * Helper function for `GSO`
 */
function fancySum(i, F, Fstar)
  result := mu(i, 1, F, Fstar) * Fstar[1];
  for j := 2 to i-1 do
    result +:= mu(i, j, F, Fstar) * Fstar[j];
  end for;
  return result;
end function;


/*
 * Calculates the Gram-Schmidt orthogonal basis of the matrix F
 */
function GSO(F)
  Fstar := F;
  for i := 2 to NumberOfRows(F) do
    Fstar[i] := F[i] - fancySum(i, F, Fstar);
  end for;
  return Fstar;
end function;


/*
 * Helper function for `reducedBasis`
 */
function needsSwap(Gstar, i)
  return
    InnerProduct(Gstar[i-1], Gstar[i-1])
    gt
    2 * InnerProduct(Gstar[i], Gstar[i]);
end function;


/*
 * Calculates the reduced basis of the given lattice.
 *
 * The rows of the matrix are regarded as the base vectors of the lattice.
 */
function reducedBasis(F)
  G := F;
  Gstar := GSO(F);

  n := NumberOfRows(F);
  i := 2;
  while i le n do
    for j := i-1 to 1 by -1 do
      G[i] := G[i] - Floor(mu(i, j, G, Gstar) + 0.5) * G[j];
      Gstar := GSO(G);
    end for;
    if i gt 1 and needsSwap(Gstar, i)
      then
        SwapRows(~G, i-1, i);
        Gstar := GSO(G);
        i -:= 1;
      else
        i +:= 1;
    end if;
  end while;

  return G;
end function;


/*
 * Generates a random square matrix with linearly independent rows.
 *
 * For testing.
 */
function randomIndependentSquareMatrix(n)
   M := MatrixAlgebra(RationalField(), n) !
     [[Random(-500, 500) : x in [1..n]] : y in [1..n]];
  for i := 1 to n do
    M[i,i] := 0;
  end for;
  return M;
end function;

/*
 * Generates a random square matrix, not necessarily linearly independent.
 *
 * For testing.
 */
function randomSquareMatrix(n)
   return MatrixAlgebra(RationalField(), n) !
     [[Random(-500, 500) : x in [1..n]] : y in [1..n]];
end function;

/*
 * Generates a random n x m matrix.
 *
 * For testing.
 */
function randomMatrix(n, m)
   return Matrix(RationalField(),
     [[Random(-500, 500) : x in [1..n]] : y in [1..m]]);
end function;


/*
 * Determines whether the matrix F is actually a reduced basis
 */
function isReduced(F)
  Fstar := GSO(F);
  result := true;
  for i := 1 to NumberOfRows(Fstar) - 1 do
    result := result and
      (InnerProduct(Fstar[i], Fstar[i])
       le
       2 * InnerProduct(Fstar[i+1], Fstar[i+1])
      );
  end for;
  return result;
end function;


procedure main()
  /*F := Matrix(RationalField(), 3, 3,*/
              /*[RationalField() ! x : x in*/
              /*[1, 1, 0*/
              /*,1, 0, 1*/
              /*,0, 1, 1*/
              /*]]);*/
  /*F := Matrix(RationalField(), 3, 3,*/
              /*[RationalField() ! x : x in*/
              /*[ 1,  1,  1*/
              /*,-1,  0,  2*/
              /*, 3,  5,  6*/
              /*]]);*/
  /*F := Matrix(RationalField(), 3, 3,*/
              /*[RationalField() ! x : x in*/
              /*[ 1,  0,  0*/
              /*, 0,  1,  0*/
              /*, 1,  1,  0*/
              /*]]);*/
  /*F := Matrix(RationalField(), 3, 3,*/
              /*[RationalField() ! x : x in*/
              /*[ 1, -1,  3*/
              /*, 1,  0,  5*/
              /*, 1,  2,  6*/
              /*]]);*/
  /*F := Matrix(RationalField(), 6, 4,*/
              /*[RationalField() ! x : x in*/
                /*[ 1, 1, 10, 0*/
                /*, 1, 1, 0, 1*/
                /*, 1, 0, 1, 1*/
                /*, 0, 1, 1, 1*/
                /*, 0, 1, 1, 1*/
                /*, 0, 1, 1, 1*/
                /*]*/
              /*]);*/
  /*F := Matrix(RationalField(), 12, 12,*/
              /*[RationalField() ! x : x in*/
    /*[-470,   22,  151, -235, -118, -323,  432,  342, -292, -420, -431,  -31*/
    /*, 357, -249,  421,    9,  432,  160,   47,  162, -213,  118, -142,  -42*/
    /*, -36,  230, -493, -404, -163,  437,  263,  116,  279, -352, -124, -137*/
    /*, 412, -371, -160, -233,  350, -409, -474,  159,  -31,  109,  -25, -333*/
    /*, -97, -430, -227, -193,  212,  157,  371, -383,  278,  289,    2, -456*/
    /*,-185, -393,  413,  214,  110, -204, -491,  347,  -97,  -55,  327,  125*/
    /*, -85,  -37,  224,  246,  118, -274,   16,   26,  445,  -35, -421,  386*/
    /*, -77, -434, -160,  312, -155, -276,   22,  301, -438,   41, -321,  324*/
    /*,-414,  261,  -41,  459, -140,  -25,  248,   47,  212,  -55,  495, -154*/
    /*, 329,  456,   91,   41, -412,   53, -329,  245, -406,   22,  156,   19*/
    /*, 264,  236, -321, -430,  -11, -181,  388,  490, -302,  177,   -8,  423*/
    /*, 476,  271, -166, -407,  305, -246, -356,  437, -429,  339,  407,  273*/
    /*]]);*/
  F := Matrix(RationalField(), 4, 4,
              [RationalField() ! x : x in
    [ 167,  -52,  310,   22
    , 184,   90,  255,  -53
    ,-471,  -82,  281, -296
    ,-187, -177, -495,  458
    ]]);
  /*F := randomSquareMatrix(12);*/
  /*F := randomIndependentSquareMatrix(10);*/
  /*F := randomMatrix(10, 11);*/

  print F;
  print isReduced(F);
  print "---";
  R := reducedBasis(F);
  print R;
  print isReduced(R);
end procedure;

// vim: ft=magma
