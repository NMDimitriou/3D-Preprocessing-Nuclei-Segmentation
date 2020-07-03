# 3D Preprocessing and Nuclei Segmentation
Processing and Segmentation pipeline for the detection of Fluorescent Cell/Nuclei

## Prerequisites

* [Fiji/ImageJ](https://fiji.sc/) including the following plugins:
  * PureDenoise (http://bigwww.epfl.ch/algorithms/denoise/)
  * Intensity Attenuation Correction (https://imagejdocu.tudor.lu/doku.php?id=plugin:stacks:attenuation_correction:start)
* MATLAB, Image Processing toolbox

## Usage

**Image Preprocessing**

The preprocessing steps are summarized in the **preprocessing_main.ijm** macro. You can run this macro in ImageJ or perform the steps of the macro using 
the GUI of ImageJ. The steps are:

* Denoising using the PURE LET method of [PureDenoise plugin] (http://bigwww.epfl.ch/algorithms/denoise/) of ImageJ.
* Intensity attenuation correction using the corresponding [plugin] (https://imagejdocu.tudor.lu/doku.php?id=plugin:stacks:attenuation_correction:start) of ImageJ.
* Background subtraction in 3 stages:
   * 1st stage: The Intensity attenuation correction plugin produces two sets of images, the first is the image stack with the corrected intensity, the second 
   is the image stack with the estimated bacgkround. We subtract the background image stack from the intensity-corrected image stack.
   * 2nd stage: We use rolling ball algorithm (*Subtract background* tool of ImageJ, found in the *Process* section). HiLo Look Up Table is recommended.
   * 3rd stage: Manual intesity threshold using *Image->Adjust->Brightness/Contrast* tool. HiLo LUT is **required**.
  
**Nuclei Segmentation**

For the segmentation, open the **main_4_0.m** MATLAB file, and specify the directory and name of the image stack. Next run the script.
Steps included in the *main* file:

* Import image
* Break image into smaller parts (in the xy-dimensions) for faster processing. The parts of this image will be processed simultaneously using parallel pool.
* Interpolate each part 10 times
* Segment nuclei using Marker Controlled Watershed segmentation
* Split nuclei using Distance Based Watershed segmentation
* Assemble the final watershed result, and the splitted interpolated images
* Find the coordinates of the centroids of the segmented nuclei
* Rescale the final result
* Save coordinates and visualize


