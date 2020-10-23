// Preprocessing macro
// To run the preprocessing macro open imagej, go to plugins->macros->run 
// and select the current file.
// Author: N. M. Dimitriou

run("Clear Results"); // clear the results table of any previous measurements

// The next line prevents ImageJ from showing the processing steps during 
// processing of a large number of images, speeding up the macro
//setBatchMode(true); 

// Show the user a dialog to select a directory of images
inputDirectory = getDirectory("Choose a Directory of Images");


// Get the list of files from that directory
// NOTE: if there are non-image files in this directory, it may cause the macro to crash
fileList = getFileList(inputDirectory);

for (i = 0; i < fileList.length; i++)
{
    processImage(fileList[i]);
}

//setBatchMode(false); // Now disable BatchMode since we are finished
updateResults();  // Update the results table so it shows the filenames

//imageFile = getArgument;
//if (name=="") exit ("No argument!");
//path = getDirectory("home")+"Desktop"+File.separator+name;
//setBatchMode(true);
//open(path);

function processImage(imageFile)
{
	// Store the number of results before executing the commands,
    	// so we can add the filename just to the new results
    	prevNumResults = nResults;  
    
    	open(imageFile);
    	// Get the filename from the title of the image that's open for adding to the results table
    	// We do this instead of using the imageFile parameter so that the
    	// directory path is not included on the table
    	filename = getTitle();
	run("Split Channels"); 
	selectWindow("C2-"+filename);
	close();
	selectWindow("C1-"+filename);
	rename(filename);

	selectWindow(filename);
	run("Grays");
	run("PureDenoise ...", "parameters='3 4' estimation='Auto Global' "); //3 4
	selectWindow("Denoised-"+filename);
	run("Attenuation Correction", "opening=3 reference=2"); //depends on the slice with highest intensity
	selectWindow("Background of Denoised-"+filename);
	imageCalculator("Subtract create stack", "Correction of Denoised-"+filename,"Background of Denoised-"+filename);
	selectWindow("Result of Correction of Denoised-"+filename);
	run("16-bit"); //We turn the resulted 32-bit to 16-bit
	run("HiLo"); //HiLo Look Up Table for background subtraction
	run("Subtract Background...", "rolling=3 stack");
	run("8-bit"); //8-bit for manual intensity threshold
	run("Brightness/Contrast...");
	waitForUser("set the threshold and press OK, or cancel to exit macro"); 
	//run("Apply LUT", "stack");
	run("Grays"); //Returns to gray-scale

	saveAs("Tiff", "/home/nikos/Desktop/new_set/D0/8bit_denoised/"+filename);

	close("*");  // Closes all images 
	
	
}
