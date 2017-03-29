To use multiple cores the executable must be built with this in mind:

    stack build --executable-profiling

See also the flags in the cabal-file.

And we must also explicitly say how many cores we want to use when
executing the program:

    stack exec jackknife -- -N4

`-ls` will give us an eventlog.
