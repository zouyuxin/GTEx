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
    --optmethod mixIP \
    --mosek-license ~/.mosek.lic \
    $JOB_OPTION
```

*NOTE:* I use `--optmethod mixIP` (default is `mixSQP`) because somehow `flash` step failed using `mixSQP`. Upgrading `flashr`/`mixSQP`/`ashr` might help but I did not try it for now ...