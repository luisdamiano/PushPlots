# PushPlots

An easy way to upload plots to public sharing services. Currently supported services: imgur.

## Usage

Install.

```r
devtools::install_github("luisdamiano/PushPlots")
```

Draw a plot.

```r
plot(1:10)
```

You may run `r PushPlots::push_imgur()` in the console, or more convenientlyassign a shortcut (Tools -> Modify Keyboard Shortcuts).

If you want to change settings, run `r PushPlots::push_imgur_config()`.
