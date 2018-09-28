%--------------------------------------------------------------------------
% File     : ../ILLTP//KLE_32_CBV.p
% Domain   : Intuitionistic Syntactic 
% Problem  : Kleene intuitionistic theorems
% Version  : 1.0
% English  :
% Source   : Introduction to Metamathematics
% Name     : Kleene intuitionistic theorems (Translation CBV)
% Status   : Theorem 
% Rating   : 
% Comments : 
%--------------------------------------------------------------------------
fof(ax1, axiom,  ! (! A -o ! B) * ! (! B -o ! A) ).
fof(conj, conjecture,  ! (! (! A -o 0) -o ! (! B -o 0)) * ! (! (! B -o 0) -o ! (! A -o 0))).