open("path/to/image");
selectWindow("image");
run("Grays");
run("PureDenoise ", "parameters='3 4' estimation='Auto Global' ");
selectWindow("Denoised-image");
run("Attenuation Correction", "opening=3 reference=2"); //depends on the slice with highest intensity
selectWindow("Background of Denoised-image");
imageCalculator("Subtract create stack", "Correction of Denoised-image","Background of Denoised-image");
selectWindow("Result of Correction of Denoised-AD0-C.tif");
run("16-bit"); //We turn the resulted 32-bit to 16-bit
run("HiLo"); //HiLo Look Up Table for background subtraction
run("Subtract Background...", "rolling=3 stack");
run("8-bit"); //8-bit for manual intensity threshold
run("Brightness/Contrast...");
//run("Apply LUT", "stack");
run("Grays"); //Returns to gray-scale
