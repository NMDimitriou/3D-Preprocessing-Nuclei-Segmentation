# 3D Preprocessing and Nuclei Segmentation
Processing and Segmentation pipeline for the detection of Fluorescent Cell/Nuclei

**Citing**: If you use this code, please cite the following article in your publications. :)  

> Dimitriou, N.M., Flores-Torres, S., Kinsella, J.M. et al. Detection and Spatiotemporal 
> Analysis of In-vitro 3D Migratory Triple-Negative Breast Cancer Cells. 
> Ann Biomed Eng (2022). https://doi.org/10.1007/s10439-022-03022-y

**Contact**: For any questions or comments feel free to contact me at this emai address: nikolaos.dimitriou@mail.mcgill.ca

## Prerequisites

* [Fiji/ImageJ](https://fiji.sc/) including the following plugins:
  * PureDenoise (http://bigwww.epfl.ch/algorithms/denoise/)
  * Intensity Attenuation Correction (https://imagejdocu.tudor.lu/doku.php?id=plugin:stacks:attenuation_correction:start)
* MATLAB (version R2019a or newer), Image Processing toolbox

## Usage

**Image Preprocessing**

The preprocessing steps are summarized in the **preprocessing_main.ijm** macro. You can run this macro in ImageJ (*plugins->Macros->Run*) 
or perform the steps of the macro using the GUI of ImageJ. The steps are:

* Denoising using the PURE LET method of [PureDenoise plugin](http://bigwww.epfl.ch/algorithms/denoise/) of ImageJ.
* Intensity attenuation correction using the corresponding [plugin](https://imagejdocu.tudor.lu/doku.php?id=plugin:stacks:attenuation_correction:start) of ImageJ.
* Background subtraction in 3 stages:
   * 1st stage: The Intensity attenuation correction plugin produces two sets of images, the first is the image stack with the corrected intensity, the second 
   is the image stack with the estimated bacgkround. We subtract the background image stack from the intensity-corrected image stack.
   * 2nd stage: We use rolling ball algorithm (*Process->Subtract background...* tool of ImageJ). HiLo Look Up Table is recommended.
   * 3rd stage: Manual intesity threshold using *Image->Adjust->Brightness/Contrast* tool. HiLo LUT is **required**.
  
**Nuclei Segmentation**

For the segmentation, open the **main_4_0.m** MATLAB file, and specify the directory and name of the input image stack, as well as directory where the 
final results will be saved. Next run the script.
Steps included in the *main_4_0.m* file:

* Import image
* Break image into smaller parts (in the xy-dimensions) for faster processing. The parts of this image will be processed simultaneously using parallel pool.
* Interpolate each part 10 times
* Segment nuclei using Marker Controlled Watershed segmentation
* Split fused nuclei using Distance Based Watershed segmentation
* Assemble the final watershed result, and the splitted interpolated images
* Find the coordinates of the centroids of the segmented nuclei
* Rescale the final result back to the original size
* Save coordinates and visualize

Files related to the **main_4_0.m**:

 * *im_split.m*: Splits the image stack to smaller parts in the xy-planes.
 * *segmn.m*: Performs Marker Controlled Watershed segmentation.
 * *split_nc.m*: Splits fused nuclei performing Distance Based Watershed segmentation.
 * *im_stich.m*: Stiches back the split, interpolated parts of the image stack and the segmentation mask.
 * *find_nc.m*: Finds the coordinates of the centroids of the segmented nuclei.
 * *im_rsc.m*: Rescales the final segmentation mask, and the coordinates of centroids of the segmented nuclei.

