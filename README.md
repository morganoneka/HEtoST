# H&E to ST

Goal: predict spatial gene expression from H&E slides
What you'll need: a Seurat object for 10x visium data, or similar. We'll need an H&E slide, and spatial transcript counts.

 ## Getting data from Seurat object
 First, we'll extract the necessary data from the Seurat object. The H&E slide is extracted using `RDS_to_PNG.R` and the transcript counts are extracted using `GetCountsForPatches.R`

 ## Obtaining patch-level features
 To make predictions from our image, we'll use features calculated from [KimiaNet](https://kimialab.uwaterloo.ca/kimia/index.php/data-and-code-2/kimia-net/). The code within `RunKimiaNet.ipynb` splits the image into patches and calculates features using this pipeline.

 ## Prediction
 Finally, we predict individual transcript expression levels, using Spatial Random Forest, using KimiaNet features in `RandomForest.Rmd`.
