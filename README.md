# Word Segmentation Analyses for the paper "WordSeg: Standardizing unsupervised word form segmentation from text"

## Put briefly

You can find the additional analyses promised as supplementary
materials in [supmat.pdf](https://github.com/alecristia/wordseg-brm-analyses/blob/master/supmat.pdf). We also provide a host of other files that
can be used to check for reproducibility (see below for instructions).

## Full contents of this project

* `supmat.pdf`: Supplementary analyses.

* `results_do_prov.zip` and `results_do_concat_prov.zip`: Contain the
  evaluation and stats files outputted by WordSeg as called by the
  scripts `do_prov.sh` and `do_concat_prov.sh`.

* `sel-providence.zip`: Contains the tags files used in the reported
  experiments, as well as the orthographic version of those files for
  ease of human reading. (ignore unless you want to check for
  reproducibility)

* `do_prov.sh`: Bash script used to run the experiments building on
  independent transcripts, reported in the paper (sections 4.3)
  (ignore unless you want to check for reproducibility and/or get
  inspiration to run your own experiments)

* `do_concat_prov.sh`: Bash script used to run the experiments
  building on concatenated transcripts, reported in the paper (section
  4.4) (ignore unless you want to check for reproducibility and/or get
  inspiration to run your own experiments)

* `analyses.Rmd`: RMarkdown file generating all figures and analyses
  reported on in the paper. (ignore unless you want to check for
  reproducibility; see below for knitting instructions)

* `analyses.html`: Latest knitted version of the `analysis.Rmd` file
  (this is redundant with the information reported on in the
  manuscript -- ignore unless you want to check for reproducibility,
  in which case you would compare your results against these ones)

* `analyses-DATE.html`: We expect we may make modifications to the
  wordseg package. If so, we will store older versions of the knitted
  Rmd with this format. (The data is in an unambiguous format:
  YYYYMMDD)

* `supmat.Rmd`: RMarkdown file generating the supplementary
  materials. (ignore unless you want to check for reproducibility; see
  below for knitting instructions)


## Dependencies

Those analyses depends on [RStudio](https://www.rstudio.com/). You need
to install it.

You also need the R packages `car` and `jsonlite` dependencies.
Install them using your system package distribution, or from a R
prompt:

    install.packages("car")
    install.packages("jsonlite")


## Instructions to reproduce analyses reported on in the paper

Some readers may want to check our materials for reproducibility. To
regenerate the reports above, you will need
[RStudio](https://www.rstudio.com/). For further information on using
Rmd for transparent (knittable) analyses, see [Mike Frank & Chris
Hartgerink's
tutorial](https://libscie.github.io/rmarkdown-workshop/handout.html).

1. Download and unzip `results_do_prov.zip` or
   `results_do_concat_prov.zip`.

2. Download `analyses.Rmd` (or `supmat.Rmd`) and put it at the same
   level as the two ensuing results folders. Create a folder called
   "derived" at the same level as the results folder and the
   `analyses.Rmd` (or `supmat.Rmd`) file

3. Launch RStudio by double-clicking on `analyses.Rmd` (or
   `supmat.Rmd`) -- (or otherwise ensure that your working directory
   points to the Rmd location).  Click on the button *"knit"*.

## Instructions to check your word segmentation analyses against ours

Some readers may want to check our whole pipeline, from the
unsegmented materials to the analyses. This cannot be done blindly and
will require some knowledge of the WordSeg package and your own
system. Thus, the following instructions are intended for more
advanced users. Please note that to generate the html or pdf reports,
you will need [RStudio](https://www.rstudio.com/). For further
information on using Rmd for transparent (knittable) analyses, see
[Mike Frank & Chris Hartgerink's
tutorial](https://libscie.github.io/rmarkdown-workshop/handout.html).

1. Install wordseg-0.7.1
   (https://github.com/bootphon/wordseg/releases/tag/v0.7.1)

2. Download and unzip `sel-providence.zip`.

3. Download `do_prov.sh`, `do_concat_prov.sh`

4. **Change the paths at the top of these files** to make them
   appropriate to your environments. For instance, you need to point
   to the sel-providence files unzipped in step 1.

5. **Verify that the calls are appropriate to your system.** Most
   importantly, please make sure you adapt the call to slurm if you
   are not running these scripts in a system containing slurm. If you
   run Sun Grid Engine, please use `wordseg-sge.sh` instead. If you do
   not work on a cluster, you can use `wordseg-bash.sh` instead.

6. Make the for .sh scripts executable with `chmod +x *.sh`

7. Launch `do_prov.sh` and `do_concat_prov.sh` one at a time with e.g., `./do_prov.sh`

8. Download `analyses.Rmd` (or `supmat.Rmd`) and put it at the same level
   as the two ensuing results folders.

9. Create a folder called `derived` at the same level as the results
   folder and the `analyses.Rmd` (or `supmat.Rmd`) file

10. Launch RStudio by double-clicking on `analyses.Rmd` (or
    `supmat.Rmd`) (or otherwise ensure that your working directory
    points to the Rmd location).

11. Click on the button *"knit"*.

12. Compare your resulting `analyses.html` file against the one we
    provide in this project

13. If you notice divergencies, consider creating an issue on [the
    wordseg's github](https://github.com/bootphon/wordseg/issues).
