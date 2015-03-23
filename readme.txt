Building Labeling source code

by Qi Cao, Ruishan Liu, Tian Tang and Yue Zhang
<qcao> <rliu2> <tangtian> <yzhang91> @stanford.edu
Electrical Engineering Department, Stanford University

================================================================================
Please review our paper report “Building_Labeling.pdf” for the methods we used.

Abstract — In this paper, we present a method to tackle building recognition and labeling problem. This task is challenging as there are huge intra-class variations due to different illumination conditions and perspectives of camera. In our proposed method, first we do background elimination based on obtaining the multi-image saliency map for each training image. For image representation, both global features, such as color and texture histograms, and local features, such as Dense SIFT, are implemented with their results compared and discussed in chapter IV. Finally, test image with cropped target region is retrieved from the known dataset based on assigned score rule. The name of the building with highest score is returned to user interface. In conclusion, the training and test accuracies of using local features are satisfactory and higher than those of using global features in sacrifice of running time.
Index Terms — Multi-image saliency map (MISM), color histogram, texture histogram, Dense SIFT

————————————————————————————————————————————————————————————————————————————————
Follow the following steps to run this code:

(1) Add all folders and subfolders to path.

(2) Run test_hist.m for Method 1 (global features) or test_sift.m for Method 2 (local Features).

(3) For an input image, first crop the region you want to label and confirm by double clicking it.

(4) Labeling result will be shown below the image, and in MATLAB command window.

================================================================================
 Copyright Notice:
    MISM code are from http://ivipc.uestc.edu.cn/hlli/projects/cosaliency.html
================================================================================
