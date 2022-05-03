library("Seurat")
library("ggplot2")
library("png")
library("stringr")
library("EBImage")


data_location = "/Users/morganoneka/Dropbox (University of Michigan)/from_box/My Stuff/KimiaNet/"
rds_files = list.files(data_location, pattern="*.rds$", full.names=TRUE)

for (filename in rds_files){
  # read in file
  brain <- readRDS(filename)
  sample_name = str_split_fixed(tail(strsplit(filename, "/")[[1]],1), "_", 2)[,1]
  
  # resize image
  img = brain@images[[1]]@image
  img_resized = resize(img, dim(img)[1] * 10)
  
  # save resized image to png folder
  writePNG(img_resized, paste(data_location, "pngs/", sample_name, ".png", sep=""))
  
  
}

# NEXT: run kimanet jupyter notebook



