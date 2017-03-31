Useful commands

    stack build --force-dirty
    stack exec jackknife -- +RTS -N4 -ls -lf -A2g
    threadscope jackknife.eventlog

Note that compile-time flags are controlled in the cabal-file.

If you disable the `debug` flag and enable the `profiling` flag in the
cabal file and execute `jackknife-mem` you will see that `resamples 500`
consumes around ~1.5gb of data.
