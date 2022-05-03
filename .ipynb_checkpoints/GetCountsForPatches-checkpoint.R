library("Seurat")
library("stringr")

data_location = "/Users/morganoneka/Dropbox (University of Michigan)/from_box/My Stuff/KimiaNet/"
rds_files = list.files(data_location, pattern="*.rds$", full.names=TRUE)

# now we get the counts for each patch
for (filename in rds_files){
  # read in file
  brain <- readRDS(filename)
  sample_name = str_split_fixed(tail(strsplit(filename, "/")[[1]],1), "_", 2)[,1]
  
  # get coordinates from rds file
  coordinates = GetTissueCoordinates(brain)  
  count_data = t(as.matrix(brain@assays$Spatial@data))
  
  # scale coordinates
  scale_factor = 10
  coordinates$scalerow = coordinates$imagerow * scale_factor
  coordinates$scalecol = coordinates$imagecol * scale_factor
  
  # subset counts based on square location
  files = list.files(paste(data_location, "patches/" , sample_name, sep=""), pattern="*.jpg")
  file_counts = lapply(files, function(fname){
    # get square info
    coords = str_split_fixed(fname, "_", 3)
    x_min = as.numeric(gsub("[^0-9]", "", str_split_fixed(coords[2], ",",2)[1]))
    x_max = as.numeric(gsub("[^0-9]", "", str_split_fixed(coords[3], ",",2)[1]))
    y_min = as.numeric(gsub("[^0-9]", "", str_split_fixed(coords[2], ",",2)[2]))
    y_max = as.numeric(gsub("[^0-9]", "", str_split_fixed(coords[3], ",",2)[2]))
    
    # subset square
    location_subset = coordinates[which(coordinates$scalerow >= x_min & coordinates$scalerow  <= x_max &
                                          coordinates$scalecol >= y_min & coordinates$scalecol <= y_max),]
    
    # get count info
    location_subset_counts = subset(count_data, rownames(count_data) %in% rownames(location_subset))
    
    # sum count info
    location_subset_totals = colSums(location_subset_counts)
    return(location_subset_totals)
  })
  
  # combine all count info
  file_counts_combo = do.call(rbind, file_counts)
  
  # get coordinates and set as row names
  coords_from_file_names = lapply(files, function(fname){
    coords = str_split_fixed(fname, "_", 3)
    return(paste(coords[2], str_split_fixed(coords[3], "\\.", 2)[1], sep="_"))
  })
  row.names(file_counts_combo) = unlist(coords_from_file_names)
  
  
  # save
  write.table(file_counts_combo, paste("/Users/morganoneka/Dropbox (University of Michigan)/from_box/My Stuff/KimiaNet/CountsForSquares_", sample_name,".txt", sep=""), sep="\t", quote=FALSE)
  
}




