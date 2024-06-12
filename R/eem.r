
library(tidyverse)
library(ecmisc)

# read shimadzu eem data
# read data 
# function for read eem data
import_shimadzu = function(file)
{
  library(data.table)
  x <- fread(file, header = TRUE)
  em <- colnames(x) %>% .[-1] %>% as.numeric()
  ex <- x[[1]]
  x <- x[, -1] %>% as.matrix() %>% unname()
  # x <- x[!is.na(em), !is.na(ex)]
  # ex <- ex[!is.na(ex)]
  # em <- em[!is.na(em)]
  x <- t(x)
  l <- list(file = file,
            x = x,
            em = em,
            ex = ex)
  return(l)
}
# actual load data
# not run, for illustration
# FL_data = eem_read(file = args[1], import_function = import_shimadzu)

# 从eemlist中提取单个样本的数据转换为dataframe，number参数为待提取样本的编号
eem2df <- function(eemlist, number = 1) {
  if (number <= length(eemlist)) {
    ex = eemlist[[number]]$ex
    em = eemlist[[number]]$em
    d1 = as.data.frame(eemlist[[number]]$x) %>%
      set_colnames(., ex)
    d1$em = em
    d2 = d1 %>%
      melt('em') %>%
      mutate(ex = as.numeric(as.character(variable))) %>%
      select(-variable)
    return(d2)
  } else {
    print(paste0('error','eemlist only have',length(eemlist),'data'))
  }
}

eem_plot <- function(data, limit) {
  len = nargs()
  if (len == 2) {
    p1 = ggplot(data = data, aes(em, ex, fill = value)) +
      ggfx::with_blur(
        geom_raster(interpolate = T),
        sigma = .5
      )   +
      geom_contour(aes(z = value), color = 'white', lwd = .1) +
      geom_hline(yintercept = 248, lwd = .2) +
      geom_vline(xintercept = 380, lwd = .2) +
      geom_segment(x = 330, xend = 330, y = -Inf, yend = 248, lwd = .2) +
      annotate('text', label = 'I', x = 300, y = 230, size = 10/.pt, color = 'white') +
      annotate('text', label = 'II', x = 355, y = 230, size = 10/.pt, color = 'white') +
      annotate('text', label = 'III', x = 465, y = 230, size = 10/.pt, color = 'white') +
      annotate('text', label = 'IV', x = 330, y = 350, size = 10/.pt, color = 'white') +
      annotate('text', label = 'V', x = 465, y = 350, size = 10/.pt, color = 'white') +
      labs(y = 'Excitation (nm)',
           x = 'Emission (nm)',
           fill = 'Intensity') +
      # scale_fill_viridis_c(
      #   begin = .2,
      #   limits = c(0, limit)
      # ) +
      # scale_fill_gradient2(low = 'blue', high = 'red', limits = c(0,limit), midpoint = 30) +
      scale_fill_gradientn(limits = c(0, limit), colors = pals::coolwarm(),
                           breaks = round(seq(0, limit, len = 4),0)
                           ) +
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0)) +
      theme(
        legend.text = element_text(size = 7),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, 'lines'),
        legend.key.height = unit(0.5,'lines'),
        legend.spacing.y = unit(0, 'lines'),
        legend.background = element_rect(color = alpha('white', 0.2), fill = alpha('white', 0.2)),
        legend.position = c(.15,.8)
      )
  } else {
    p1 = ggplot(data = data, aes(em, ex, fill = value)) +
      ggfx::with_blur(
        geom_raster(interpolate = T),
        sigma = .5
      )   +
      geom_contour(aes(z = value), color = 'white', lwd = .1) +
      geom_hline(yintercept = 248, lwd = .2) +
      geom_vline(xintercept = 380, lwd = .2) +
      geom_segment(x = 330, xend = 330, y = -Inf, yend = 248, lwd = .2) +
      annotate('text', label = 'I', x = 300, y = 230, size = 8/.pt, color = 'white') +
      annotate('text', label = 'II', x = 355, y = 230, size = 8/.pt, color = 'white') +
      annotate('text', label = 'III', x = 465, y = 230, size = 8/.pt, color = 'white') +
      annotate('text', label = 'IV', x = 330, y = 350, size = 8/.pt, color = 'white') +
      annotate('text', label = 'V', x = 465, y = 350, size = 8/.pt, color = 'white') +
      labs(y = 'Excitation (nm)',
           x = 'Emission (nm)') +
      # scale_fill_viridis_c(
      #   begin = .2,
      #   limits = c(0, NA)
      scale_fill_gradientn(limits = c(0, NA), colors = pals::coolwarm()) +
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0)) +
      pub_theme() +
      theme(
        legend.title = element_blank(),
        legend.key.size = unit(0.5,'lines'),
        legend.spacing.y = unit(0, 'lines'),
        legend.background = element_rect(color = alpha('white', 0.3), fill = alpha('white', 0.3)),
        legend.position = c(.15,.8)
      )
  }
  return(p1)
}

# eem2df(eemlist = eem_list, number = 6) %>% eem_plot(data = .)

eem_load_plot = function(pf_model, number, plot = 'content') {
  model = pf_model[[number]] %>% staRdom::norm2A()
  plot_data = model$A %>% 
    as.data.frame() %>% 
    rownames_to_column('Sample') %>% 
    melt('Sample')
  if (plot == 'content') {
     p1 = plot_data %>% 
      ggplot(aes(Sample, value, fill = variable)) +
      geom_col() +
      ggsci::scale_fill_npg() +
      labs(
        x = '',
        y = 'Component content',
        fill = 'Component'
      ) +
      pub_theme() +
      theme(
        legend.position = c(1.1,.8),
        legend.key.size = unit(3,'mm')
        )
     print('plotting content plot, input plot = ratio for a ratio plot')
     return(p1)
  } else {
    p1 = plot_data %>% 
      ggplot(aes(Sample, value, fill = variable)) +
      geom_col(position = position_fill(), width = .8) +
      ggsci::scale_fill_npg() +
      labs(
        x = '',
        fill = 'Component',
        y = 'Component percent (%)'
      ) +
      scale_y_continuous(breaks = seq(0,1,0.2), labels = seq(0,100,20)) +
      pub_theme() +
      theme(
        legend.position = c(1.1,.8),
        legend.key.size = unit(3,'mm')
            )
    print('plotting ratio plot, input plot = content for a content plot')
    return(p1)
  }
}

# eem_load_plot(pf_model = pf1n, number = 1, plot = 'ratio')

