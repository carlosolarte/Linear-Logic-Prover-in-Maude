%--------------------------------------------------------------------------
% File     : TPTP/KLE_52_MU.p
% Domain   :
% Problem  : Kleene intuitionistic theorems
% Version  : 1.0
% English  :
% Source   : Introduction to Metamathematics
% Name     : Kleene intuitionistic theorems (Translation MU)
% Status   : 
% Rating   : 
% Comments : 
%--------------------------------------------------------------------------
fof( ((B -o bot) -o bot) -o B |- ((A -o B) -o (A * (B -o bot) -o bot)) * ((A * (B -o bot) -o bot) -o (A -o B)))
