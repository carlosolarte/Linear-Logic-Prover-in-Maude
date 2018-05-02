%--------------------------------------------------------------------------
% File     : TPTP/KLE_33_01.p
% Domain   :
% Problem  : Kleene intuitionistic theorems
% Version  : 1.0
% English  :
% Source   : Introduction to Metamathematics
% Name     : Kleene intuitionistic theorems (Translation 01)
% Status   : 
% Rating   : 
% Comments : 
%--------------------------------------------------------------------------
fof( nil |- ! (! (! (! (! A & ! B) & ! C) -o ! (A & ! (B & C))) & ! (! (! A & ! (! B & ! C)) -o ! (! (A & B) & C))))
