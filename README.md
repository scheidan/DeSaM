# DeSaM

The *Decentralized Sanitation Model* (DeSaM) was originaly developed and
implemented in R by Thomas Hug.

This is a reimplementation of DeSaM from scratch in
[Julia](http://julialang.org/), a ``high-level, high-performance
dynamic programming language for technical computing''.

The aim of the reimplementation is not to reproduce all features of
the R version but rather provide a well designed basic structure that
can be extended easily by the user.


### Getting started

A simple model definition and many comments can be found in the file
`run_minimal.jl`. For further information see the TeX file in the
folder 'Docu'.

### Application of Desam for Durban

This implementation has been used to design and optimize the urine
collection of urine diverting dry toilets in Durban, South Africa.
For more information see
[here](http://www.eawag.ch/forschung/eng/gruppen/vuna/research/urine_collection).