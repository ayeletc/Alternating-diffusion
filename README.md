# Alternating diffusion for motion and speach detection

* This project suggest a partial solution to the [MediaEval's 2019 No-Audio Multimodal Speech Detection Task](http://www.multimediaeval.org/mediaeval2019/speakerturns/),  based on manifold learning methods

* For more details about the project read our abstract in [SIPL website](http://sipl.eelabs.technion.ac.il/projects/multimodal-motion-detection-using-alternating-diffusion/).

### How to use

* In order to run the Alternative Diffusion Heatmap algorithm on simulation use “trackingHeatmap.m” => section “analyze patches in the simulation”.

* If you want to run the Alternative Diffusion Heatmap algorithm on cocktail party dataset use “trackingHeatmap.m”, and choose the desired output, the speaker, video, and AD parameters in the section:
 “flags”, “speaker”, …, “Calculate heatmap for each time window”
And then run the relevant section to get the desired output.

* Only the 3 simulations from our presentation were added.

* The full dataset is [here](http://matchmakers.ewi.tudelft.nl/svn/MNM_version2/).

* In order to use one of the specific tests or the scripts for the presentation, you should move these files into the main directory (where  you can find all the algorithmic scripts). 



Ayelet Cohen & Amir Kfir

28.12.2020
