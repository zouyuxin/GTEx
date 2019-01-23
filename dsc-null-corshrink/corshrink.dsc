corshrink: corshrink.R + R(V = CorShrink_sum(gene, '/project/mstephens/data/internal_supp/gtex-v6-sumstat-hdf5/MatrixEQTLSumStats.h5'))
  gene: Shell{cat gene_names.txt}
  $V: V

DSC:
  run: corshrink
  output: corshrink
