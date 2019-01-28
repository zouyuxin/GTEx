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
    --vhat mle \
    --effect-model EZ \
    $JOB_OPTION
```

Specifically for `corshrink` (or in general, gene specific covariance) methods, we need to add `--implementation R`
at this prototyping stage,

```bash
sos run mashr_flashr_workflow.ipynb mash \
    --data /project/mstephens/gtex_yuxin/MatrixEQTLSumStats.Portable.Z.rds \
    --cwd /project/mstephens/gtex_yuxin/V6_MASH_output \
    --vhat corshrink_xcondition \
    --posterior-vhat-file /project/mstephens/gtex_yuxin/V6_MASH_output/MatrixEQTLSumStats.Portable.Z.EZ.FL_PC3.V_corshrink_xcondition_strong.rds \
    --implementation R \
    --effect-model EZ \
    $JOB_OPTION
```