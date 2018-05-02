%--------------------------------------------------------------------------
% File     : TPTP/KLE_50_CBV.p
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
fof( nil |- ! (! (! A * ! B -o 0) -o ! (! (! (! A -o 0) -o 0) -o ! (! B -o 0))) * ! (! (! (! (! A -o 0) -o 0) -o ! (! B -o 0)) -o ! (! A * ! B -o 0)))
