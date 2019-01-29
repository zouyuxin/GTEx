# GTEx mash pipeline

Set some bash variables,

```bash
JOB_OPTION="-q none -j 8" # use this on an interactive node with 8 "cpus" required.
# JOB_OPTION="-c midway_sos.yml -q midway2" # use this to submit jobs
```

## GTEx V6 analysis

For different $V$ methods,

```bash
sos run mashr_flashr_workflow.ipynb mash \
    --data /project/mstephens/gtex_yuxin/MatrixEQTLSumStats.Portable.Z.rds \
    --cwd /project/mstephens/gtex_yuxin/V6_MASH_output \
    --effect-model EZ \
    --vhat mle \
    $JOB_OPTION
```

### Using `corshrink` to estimate $V$

The `vhat_corshrink_xcondition` performs estimates of gene-specific $V$. Since we might have different methods to estimate it, we use `--vhat-file-label` to label these different computations. For example,

```bash
sos run mashr_flashr_workflow.ipynb vhat_corshrink_xcondition \
    --data ... \
    --cwd /project/mstephens/gtex_yuxin/V6_MASH_output \
    --effect-model EZ \
    --vhat corshrink_xcondition \
    --vhat-file-label nullz \
    $JOB_OPTION
```

computes it for some collection of gene-snp pairs and save it with `nullz` in the filename; 

```bash
sos run mashr_flashr_workflow.ipynb vhat_corshrink_xcondition \
    --data ... \
    --cwd /project/mstephens/gtex_yuxin/V6_MASH_output \
    --effect-model EZ \
    --vhat corshrink_xcondition \
    --vhat-file-label nullz_strong \
    $JOB_OPTION
```

computes it for some **other** collection of gene-snp pairs and save it with `nullz_strong` in the filename.

Now to use `nullz` data for fitting the MASH mixture and the `nullz_strong` data to compute posterior,

```bash
sos run mashr_flashr_workflow.ipynb mash \
    --data /project/mstephens/gtex_yuxin/MatrixEQTLSumStats.Portable.Z.rds \
    --cwd /project/mstephens/gtex_yuxin/V6_MASH_output \
    --effect-model EZ \
    --vhat corshrink_xcondition \
    --vhat-file-label nullz \
    --posterior-vhat-file /project/mstephens/gtex_yuxin/V6_MASH_output/MatrixEQTLSumStats.Portable.Z.EZ.FL_PC3.V_corshrink_xcondition_nullz_strong.rds \
    --implementation R \
    $JOB_OPTION
```

Also notice that we need to add `--implementation R` at this prototyping stage because the code is currently not available for the Rcpp version yet.