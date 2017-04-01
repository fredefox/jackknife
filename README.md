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

    ./jackknife +RTS -N4 -ls -lf -A1.6g

Notice that we are running the benchmarks with 1.6gb of memory[^1].

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
