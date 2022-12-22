
library(abind)
library(ggplot2)
library(ggpubr)
library(ggpmisc)
library("dplyr")

#install.packages("scatterplot3d") # Install
library("scatterplot3d") # load
filename1 = "../data/resAllL.csv"

library( rgl )
library(magick)
library("plot3D")


m1 = FALSE
m3 = TRUE


source("meta1.R")
source("meta3.R")


if(m1) meta1(filename1)
if(m3) meta3()


