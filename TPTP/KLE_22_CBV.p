%--------------------------------------------------------------------------
% File     : TPTP/KLE_22_CBV.p
% Domain   :
% Problem  : Kleene intuitionistic theorems
% Version  : 1.0
% English  :
% Source   : Introduction to Metamathematics
% Name     : Kleene intuitionistic theorems (Translation CBV)
% Status   : 
% Rating   : 
% Comments : 
%--------------------------------------------------------------------------
fof( ! (! A -o ! B) * ! (! B -o ! A),! (! B -o ! C) * ! (! C -o ! B) |- ! (! A -o ! C) * ! (! C -o ! A))
