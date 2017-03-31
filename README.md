User guide
==========
Useful commands

    stack build --force-dirty
    stack exec jackknife -- +RTS -N4 -ls -lf -A2g
    threadscope jackknife.eventlog

Note that compile-time flags are controlled in the cabal-file.

If you disable the `debug` flag and enable the `profiling` flag in the
cabal file and execute `jackknife-mem` you will see that `resamples 500`
consumes around ~1.5gb of data.

Benchmark
=========
This benchmark was executed with:

    ./jackknife +RTS -N4 -ls -lf -A1g

Output of benchmark (pruned):

    benchmarking [sequential] jackknife
    time                 580.2 ms   (514.8 ms .. 651.9 ms)
                         0.997 R²   (0.997 R² .. 1.000 R²)
    mean                 599.9 ms   (580.7 ms .. 611.7 ms)
    std dev              17.95 ms   (0.0 s .. 20.54 ms)
    variance introduced by outliers: 19% (moderately inflated)

    benchmarking [explicit]   jackknife
    time                 316.0 ms   (276.3 ms .. 361.8 ms)
                         0.988 R²   (0.971 R² .. 1.000 R²)
    mean                 340.5 ms   (324.7 ms .. 368.2 ms)
    std dev              27.10 ms   (6.126 ms .. 35.50 ms)
    variance introduced by outliers: 18% (moderately inflated)

    benchmarking [eval]       jackknife
    time                 330.8 ms   (304.5 ms .. 354.3 ms)
                         0.998 R²   (0.998 R² .. 1.000 R²)
    mean                 327.6 ms   (323.7 ms .. 331.4 ms)
    std dev              4.875 ms   (2.211 ms .. 6.381 ms)
    variance introduced by outliers: 16% (moderately inflated)

    benchmarking [strat]      jackknife
    time                 285.7 ms   (270.9 ms .. 291.6 ms)
                         0.999 R²   (0.996 R² .. 1.000 R²)
    mean                 282.1 ms   (277.4 ms .. 287.3 ms)
    std dev              5.345 ms   (2.810 ms .. 7.524 ms)
    variance introduced by outliers: 16% (moderately inflated)

    benchmarking [monad-par]  jackknife
    time                 282.7 ms   (273.7 ms .. 293.9 ms)
                         0.999 R²   (0.998 R² .. 1.000 R²)
    mean                 274.7 ms   (270.6 ms .. 277.2 ms)
    std dev              4.118 ms   (1.541 ms .. 5.665 ms)
    variance introduced by outliers: 16% (moderately inflated)


