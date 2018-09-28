%--------------------------------------------------------------------------
% File     : ../ILLTP//KLE_39_MU.p
% Domain   : Intuitionistic Syntactic 
% Problem  : Kleene intuitionistic theorems
% Version  : 1.0
% English  :
% Source   : Introduction to Metamathematics
% Name     : Kleene intuitionistic theorems (Translation MU)
% Status   : False (Not a theorem) 
% Rating   : 
% Comments : 
%--------------------------------------------------------------------------
fof(ax1, axiom,  B -o bot ).
fof(conj, conjecture,  ((A -o B) -o (A -o bot)) * ((A -o bot) -o (A -o B))).