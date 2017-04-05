Jackknife
=========

Building
----------
To build the project use using cabal. It is adviced that you do it in
a sandbox, but this is optional:

    cabal sandbox init

Then do:

    cabal install

If you're really opposed to using a build system you can acheive similar
effects using ghc directly with appropriate flags:

    ghc -debug -threaded -rtsopts -with-rtsopts=-N --make app/Jackknife.hs -isrc
    ghc -debug -threaded -rtsopts -with-rtsopts=-N --make app/MergeSort.hs -isrc

This will place the executables in the `app` directory.

The two main executables in this project are `jackknife` and `benchmark`,
if you don't want to install them globally on your machine you
can use the following commands to execute them locally:

    cabal exec jackknife

and

    cabal exec mergesort

If you need to pass run-time flags to the exectuables this can be done like so:

    cabal exec jackknife -- +RTS -N4 -ls -lf -A2g

This command will also create an eventlog that can be inspected with threadscope:

    threadscope jackknife.eventlog

Note that compile-time flags are controlled in the cabal-file. `-debug` is enabled
by default.

If you disable the `debug` flag and enable the `profiling` flag in the
cabal file and execute `jackknife-mem` with profiling enabled you will see
that `resamples 500` consumes around ~1.5gb of data.

Benchmark
---------
This benchmark was executed with:

    ./jackknife +RTS -N4 -ls -lf -A1.6g

Notice that we are running the benchmarks with 1.6gb of memory[^1].
It should be added as well that this was run on a machine with 2
physical cores and hyperthreading (an i7 processor).

Output of benchmark (pruned):

    benchmarking [sequential] jackknife
    time                 576.8 ms   (519.1 ms .. 648.3 ms)
                         0.998 R²   (0.994 R² .. 1.000 R²)
    mean                 630.1 ms   (608.1 ms .. 665.6 ms)
    std dev              30.99 ms   (0.0 s .. 33.18 ms)
    variance introduced by outliers: 19% (moderately inflated)

    benchmarking [explicit]   jackknife
    time                 266.5 ms   (-469.9 ms .. 1.247 s)
                         0.396 R²   (0.113 R² .. 1.000 R²)
    mean                 489.9 ms   (336.4 ms .. 773.9 ms)
    std dev              246.3 ms   (0.0 s .. 252.6 ms)
    variance introduced by outliers: 74% (severely inflated)

    benchmarking [eval]       jackknife
    time                 333.9 ms   (299.6 ms .. 368.0 ms)
                         0.999 R²   (0.995 R² .. 1.000 R²)
    mean                 331.9 ms   (325.9 ms .. 337.0 ms)
    std dev              6.110 ms   (1.954 ms .. 7.355 ms)
    variance introduced by outliers: 16% (moderately inflated)

    benchmarking [strat]      jackknife
    time                 319.6 ms   (277.7 ms .. 355.6 ms)
                         0.995 R²   (0.983 R² .. 1.000 R²)
    mean                 297.9 ms   (267.8 ms .. 309.6 ms)
    std dev              20.80 ms   (3.718 ms .. 27.00 ms)
    variance introduced by outliers: 17% (moderately inflated)

    benchmarking [monad-par]  jackknife
    time                 289.1 ms   (269.9 ms .. 322.7 ms)
                         0.996 R²   (0.977 R² .. 1.000 R²)
    mean                 285.3 ms   (265.7 ms .. 292.0 ms)
    std dev              13.17 ms   (492.8 μs .. 15.97 ms)
    variance introduced by outliers: 16% (moderately inflated)

It seems that we have invented a time-machine - namely our explicit parallel
version -- that's pretty impressive, it's so fast that it travels back in time
and finishes before it was even started[^2].

[^1]: Higher values seem to crash my computer. I start to see a speed-up
      around 512m.
[^2]: This was seriously the output I got. Perhaps the error can be attributed
      to a bug in criterion.

Mergesort
=========

See [this diagram](assets/mergesort.png). From this diagram we see there is an
initial amount of work being done (presumably generating the random list). Then
some work is done in parallel and finally there is a big chunk of sequential
work. We conjecture that work corresponds to the final merge,
but we're not certain.

The benchmark:

    stack exec mergesort -- +RTS -N4 -ls -lf -A1.6g

Gave the following results:

    benchmarking [sequential] mergesort
    time                 159.1 ms   (120.8 ms .. 181.0 ms)
                         0.970 R²   (0.872 R² .. 0.999 R²)
    mean                 178.7 ms   (166.4 ms .. 193.6 ms)
    std dev              17.80 ms   (12.53 ms .. 22.14 ms)
    variance introduced by outliers: 27% (moderately inflated)

    benchmarking sequential array qsort
    time                 60.43 ms   (59.95 ms .. 60.73 ms)
                         1.000 R²   (1.000 R² .. 1.000 R²)
    mean                 60.81 ms   (60.60 ms .. 61.16 ms)
    std dev              442.7 μs   (167.7 μs .. 615.7 μs)

    benchmarking parallel array qsort
    time                 33.65 ms   (31.94 ms .. 35.70 ms)
                         0.993 R²   (0.984 R² .. 0.999 R²)
    mean                 31.86 ms   (28.45 ms .. 33.29 ms)
    std dev              4.464 ms   (1.230 ms .. 7.683 ms)
    variance introduced by outliers: 55% (severely inflated)

    benchmarking [explicit]   mergesort
    time                 147.1 ms   (137.8 ms .. 156.8 ms)
                         0.994 R²   (0.976 R² .. 1.000 R²)
    mean                 143.6 ms   (140.3 ms .. 148.5 ms)
    std dev              5.622 ms   (3.505 ms .. 7.887 ms)
    variance introduced by outliers: 12% (moderately inflated)

    benchmarking [eval]       mergesort
    time                 152.4 ms   (140.9 ms .. 164.4 ms)
                         0.993 R²   (0.980 R² .. 1.000 R²)
    mean                 144.2 ms   (139.5 ms .. 149.2 ms)
    std dev              6.939 ms   (5.013 ms .. 8.384 ms)
    variance introduced by outliers: 12% (moderately inflated)

So we see that we have been able to get a modest speed improvement.
