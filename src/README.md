To use multiple cores the executable must be built with this in mind:

    stack build --executable-profiling

And we must also explicitly say how many cores we want to use when
executing the program:

    stack exec jackknife -- -N4
