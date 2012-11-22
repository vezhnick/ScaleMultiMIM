clear;
ImageDir = 'd:\MATLAB\im_parser\LabelMeDataSet\OnlyTrain\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMeDataSet\SemanticLabels\';

BuildIndex;

clear;
ImageDir = 'd:\MATLAB\im_parser\LabelMeDataSet\OnlyTrain\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMeDataSet\SemanticLabels\';
TestSetDir = 'd:\MATLAB\im_parser\LabelMeDataSet\TestSet\';

BuildIndexTest;
BuildILP;

BuildGlobalDescriptors;

clear;
PredictILPbyTagProp;

BuildJointFeatures;
BuildLabels;

%% Test part
MultiMIM_Test;