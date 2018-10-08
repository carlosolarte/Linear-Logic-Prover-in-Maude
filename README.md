# Linear Logic Theorem Prover in Maude
Provers for intuitionistic and classical linear logic plus.

## Getting Started

The project was tested in Maude 2.7.1. No extra library is needed for execution. 

The implementation includes the following files:

- <b>syntax.maude</b>: Syntax of Propositional Linear Logic
- <b>ILL-Prover.maude</b>:  Focused system for Intuitionistic Linear Logic
- <b>cll-system.maude</b>: Focused system for Classical Linear Logic 
- <b>LJ-Prover.maude</b>:  LJ System (propositional intuitionistic logic)
- <b>translations-ILL.maude</b>: Different translations from LJ sequents into linear logic formulas.

## Benchmarks 
The directory ```utils``` contains some scripts to execute LLTP files (see [https://github.com/meta-logic/lltp]). The file benchmark.txt contains some intuitionistic sequents (see syntax below) that can be translated into lienar logic sequents (translations-ILL.maude).

## Examples
Loading the system:
```
maude ILL-Prover.maude
```

Searching for a proof:
```
search [1] prove([emp] 1 , ! 'p * ! 'q |~ ! ('p * 'q)) =>* proved(Tr) .
```

Printing the LaTex code of the proof
```
red solve([emp] ! 'p * ! 'q |~ ( 'p * 'q) & (( 'q * 'p)  & ('q * 'q ))) .
```

The syntax to perform the translation is the following:

``` 
Propositions: A B C P Q R ...
Formulas: F to F --- implication
          F sim F --- biimplication
          F land F --- conjunction
          F lor F --- disjunction
          neg F --- negation
          True / False --- Constants
Contexts: nil | C , C
Sequents: C vdasg F
``` 

For instance, by loading translations-ILL.maude:
```
maude translations-ILL.maude 
```

The following command will prove, using the CALL-BY-NAME translation, the given intuitionistic sequent

```
select CALL-BY-NAME .
red proveIt( nil vdash A to A) .
```
