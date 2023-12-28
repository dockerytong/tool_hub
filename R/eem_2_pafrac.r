# load libs
library(tidyverse)
library(staRdom)
# load objest form previous analysis
eem_list <- readRDS("data/eem_list.RDS")

# PAFRAC model build
# model parameters
cores <- 8
# minimum and maximum of numbers of components
dim_min <- 2
dim_max <- 5
nstart <- 25 # number of similar models from which best is chosen
maxit <- 5000 # maximum number of iterations in PARAFAC analysis
ctol <- 10^-6 # tolerance in PARAFAC analysis

job::job({
  # build model using non-negative constraints
  pf1n <- eem_parafac(eem_list, comps = seq(dim_min, dim_max), normalise = FALSE, const = c("nonneg", "nonneg", "nonneg"), maxit = maxit, nstart = nstart, ctol = ctol, cores = cores)
  # rescale B and C modes to a maximum fluorescence of 1 for each component
  pf1n <- lapply(pf1n, eempf_rescaleBC, newscale = "Fmax")
})

# plot model result
model_plot = eempf_compare(pf1n, contour = TRUE)
model_plot[[3]]

# Check the correlation between different components
eempf_cortable(pf1n[[3]], normalisation = FALSE)
eempf_corplot(pf1n[[3]], progress = FALSE, normalisation = FALSE)

# reecalculate the model using normalized data
job::job({
  pf2 <- eem_parafac(eem_list, comps = seq(dim_min,dim_max), normalise = TRUE, const = c("nonneg", "nonneg", "nonneg"), maxit = maxit, nstart = nstart, ctol = ctol, cores = cores)
  # rescale B and C modes
  pf2 <- lapply(pf2, eempf_rescaleBC, newscale = "Fmax")
})

eempf_plot_comps(pf2, contour = TRUE, type = 1)

eempf_residuals_plot(pf2[[1]], eem_list, residuals_only = TRUE, spp = 6, cores = cores, contour = TRUE)
eempf_comp_load_plot(pf2[[1]], contour = TRUE)

saveRDS(pf2, file = 'data/pafrac_model.RDS')

norm2A(pf2[[1]])$A %>%
  data.frame() %>% rownames_to_column("sample") %>%
  gather(comp, amount, -sample) %>%
  ggplot() +
  geom_col(aes(x = sample,
               y = amount, fill = comp),
           position = 'fill',
           width = 0.8) +
  theme_minimal() +
  ggsci::scale_fill_npg() +
  theme(axis.text.x = element_text(angle = 90,
                                   hjust = 1))
