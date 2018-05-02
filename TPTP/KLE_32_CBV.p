%--------------------------------------------------------------------------
% File     : TPTP/KLE_32_CBV.p
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
fof( ! (! A -o ! B) * ! (! B -o ! A) |- ! (! (! A -o 0) -o ! (! B -o 0)) * ! (! (! B -o 0) -o ! (! A -o 0)))
