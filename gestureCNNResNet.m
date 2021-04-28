clear all;

images = imageDatastore('Dataset', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
[trainingImages,testImages] = splitEachLabel(images,0.7);

net = resnet18;

inputSize = net.Layers(1).InputSize;

lgraph = layerGraph(net);

[learnableLayer,classLayer] = findLayersToReplace(lgraph);

numClasses = numel(categories(trainingImages.Labels));

newLearnableLayer = fullyConnectedLayer(numClasses, ...
    'Name','new_fc', ...
    'WeightLearnRateFactor',10, ...
    'BiasLearnRateFactor',10);

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);

newClassLayer = classificationLayer('Name','new_classoutput');

lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);


pixelRange = [-30 30];

imageAugmenter = imageDataAugmenter( ...
    'RandYReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
augTrainingImages = augmentedImageDatastore(inputSize(1:2),trainingImages,...
    'DataAugmentation',imageAugmenter);

augTestImages = augmentedImageDatastore(inputSize(1:2),testImages);

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augTestImages, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

gestureResNet = trainNetwork(augTrainingImages,lgraph,options);

[gesturePred,scores] = classify(gestureResNet,augTestImages);

idx = randperm(numel(testImages.Files),25);
figure
for i = 1:25
    subplot(5,5,i)
    I = readimage(testImages,idx(i));
    imshow(I)
    label = gesturePred(idx(i));
    title(string(label));
end

gestureValidation = testImages.Labels;
accuracy = mean(gesturePred == gestureValidation)