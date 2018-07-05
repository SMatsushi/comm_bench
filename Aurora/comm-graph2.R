# R script to draw graph from csv file converted with dtgen2.pl
# (C) Copyright Satoshi Matsushita 2018
#
library(tidyverse)
library(ggplot2)

setwd("/Users/matsushi/mnt/mmatom/aurora/comm_bench/Aurora")

# output file name:
outf <- "commbench-graph.png"

colors <- c("red",  "blue", "black", "red",  "blue",  "black", "red", "blue")
linetypes <- c("solid","solid","solid", "dashed","dashed","dashed", "twodash", "twodash")
ltitle <- "Src-Dest"
shapes <- c(0:10)
# read csv into data frame
rf <- read.csv(file="commbench.csv", header=T)
print(rf)
# print(resFrame[1,-1])

cols <- colnames(rf)
print(cols)
print(rf[cols[1]])
xaxis <- rf[cols[1]] / 1000 # make it to KB
print(xaxis)
print(rf[cols[2]])
# ser <- rev(cols[-1])
mcols <- sub("\\.", "-", cols)
print(mcols)
colnames(rf) <- mcols
print(10^(0:1))

molten <- gather(rf, key=ser, value=value, mcols[-1])
print(molten)

yfmt <- function(x) format(x, nsmall=2)
print(yfmt(10^((0:10)/4)))
# pdf(outf)

# theme_set(theme_bw(15))
g <- 
#  ggplot(molten, aes(x=Size/1000, y=value, group=ser,
#                     label=rep(letters[1:26], length=48))) +
  ggplot(molten, aes(x=Size/1000, y=value, group=ser)) +
  geom_point(aes(color=ser, shape=ser), size=5) +
  geom_text(aes(label=round(value, 2)),
            position=position_nudge(x=-0.1, y=0.1), check_overlap=T) +
  geom_line(aes(group=ser, linetype=ser)) +
  scale_shape_manual(values=shapes, name=ltitle, guide=guide_legend(reverse=T)) +
  scale_colour_manual(values=colors, name=ltitle, guide=guide_legend(reverse=T)) +
  scale_linetype_manual(values=linetypes, name=ltitle, guide=guide_legend(reverse=T))

# g <- ggplot(rf, aes(x=xaxis, y=rf[ser[1]]))
g <- g + scale_x_log10(breaks=10^(0:5))
g <- g + scale_y_log10(breaks=round(10^((-1:10)/4),2))
# g <- g + scale_y_log10(breaks=10^((-1:10)/4))
# g <- g + scale_x_log10(breaks=10**(3:7), minor_breaks=log10(5 * 10**(3:7)))
#      + scale_y_log10(breaks=10**(0:3), minor_breaks=log10(5 * 10**(0:3)))
g <- g + annotation_logticks()
g <- g + xlab('Transfer block size (KB)') + ylab('Throughput (GB/s)')
g <- g + ggtitle('SX Aurora Tsubasa comm_bench result') +
  theme(plot.title = element_text(hjust = 0.5))

# print(g)
ggsave(file=outf, plot=g)
