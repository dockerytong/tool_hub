
# PARAMETERS to set
data_folder = 'data/DataPoints/' # folder where eem file called "DAtaPoints" stored
cores = 8 # number of cores used for analysis
dir.create('plot')

# load packages
library(tidyverse)
library(staRdom)

# define function
read_duetta = function(file) {
  a = as.matrix(data.table::fread(file, select = c(2:90)))
  a[a<0] = 0
  dim = dim(a)
  ex = seq(260,700, len = dim[2])
  em = seq(280,720,len = dim[1])
  b = matrix(nrow = dim[1], ncol = dim[2])
  for (i in c(1:dim[2])) {
    b[,i] = a[,dim[2] + 1 - i]
  }
  l = list(
    file = file,
    em = em,
    ex = ex,
    x = b
  )
  return(l)
}

# funtion to plot individual eem plot
eem_plot <- function(eem_list){
  eem_list %>% 
    ggeem(interpolate = TRUE, colpal = pals::parula(), contour = TRUE) +
    scale_x_continuous(expand = c(0,0), breaks = seq(0, 800, 50)) +
    scale_y_continuous(expand = c(0,0), breaks = seq(0, 800, 50)) +
    labs(fill = 'Intensity\n(a.u.)', color = 'Intensity\n(a.u.)') +
    theme_bw(base_size = 11) +
    theme(
      panel.grid = element_blank(),
      axis.text = element_text(color = 'black'),
      strip.background = element_blank(),
      strip.text = element_text(hjust = 0, face = 'bold'),
      legend.key.width = unit(2, 'mm')
    )
}

# read data
eem_list = eem_read(file = data_folder,import_function = read_duetta)
# change file name
eem_names(eem_list) = paste0("JX",seq(0,7,1))

# Raman normalisation
# need blank eem data
# eem_list <- eem_raman_normalisation2(eem_list, blank = "blank")

# Remove and interpolate scattering
job::job({
  remove_scatter <- c(TRUE, TRUE, TRUE, TRUE)
  remove_scatter_width <- c(15,15,25,15)
  # remove scatter
  eem_list <- eem_rem_scat(eem_list, remove_scatter = remove_scatter, remove_scatter_width = remove_scatter_width)
  # interp the removed black area
  eem_list <- eem_interp(eem_list, cores = cores, type = 1, extend = FALSE)
},
title = "Remove scatter"
)

# Correct for dilution
# correction for dilution, if needed
# dil_data <- meta["dilution"]
# eem_list <- eem_dilution(eem_list,dil_data)


# save all eem plot
job::job({
  dir.create('plot/eem_plot', recursive = T)
  
  eem_remove_scatter <- map(
    .x = seq(1,length(eem_names(eem_list))),
    .f = ~eem_extract(eem_list,eem_names(eem_list)[.x],keep = T) %>% 
      eem_plot
  )
  pwalk(
    list(paste0(eem_names(eem_list), '.pdf'), eem_remove_scatter),
    ggsave,
    width = 9.5,
    height = 8,
    units = 'cm',
    path = 'plot/eem_plot/'
  )
})


# smooth data
# smooth using 4 data points
job::job({
  eem4peaks <- eem_smooth(eem_list, n = 4, cores = cores)
})

# extract indices from eem data and save
job::job({
  bix <- eem_biological_index(eem4peaks)
  coble_peaks <- eem_coble_peaks(eem4peaks)
  fi <- eem_fluorescence_index(eem4peaks)
  hix <- eem_humification_index(eem4peaks, scale = TRUE)
  
  indices_peaks <- bix %>%
    full_join(coble_peaks, by = "sample") %>%
    full_join(fi, by = "sample") %>%
    full_join(hix, by = "sample")
  write.table(indices_peaks, file = 'data/eem_indices.csv')
  indices_peaks
})

# save eem_list object for further PARAFAC analysis
job::job({
  saveRDS(eem_list, file = "data/eem_list.RDS")
})


indices_plot = indices_peaks %>% 
  select(-hix) %>% 
  mutate(sample = as.numeric(str_replace(sample, 'JX',''))) %>% 
  pivot_longer(cols = -sample) %>% 
  ggplot(aes(sample, value, color = name, group = name)) +
  geom_point(show.legend = F) +
  scale_x_continuous(breaks = seq(0,7,1)) +
  facet_wrap(~name, scales = 'free_y', nrow = 2) +
  # facet_grid(cols = vars(name), scales = 'free', space = 'free') +
  theme_classic(base_size = 11) +
  theme(
    strip.background = element_blank(),
    strip.text = element_text(face = 'bold',hjust = 0),
    axis.text = element_text(color = 'black')
  )

ggsave('plot/indicesplot.pdf',indices_plot, width = 16, height = 8, units = 'cm')

