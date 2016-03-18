Files = dir('./frames/out*.png');

BarAppeared = false;
for File = Files'
    clearvars CroppedImage CroppedName CroppedTitle;
    try 
        Image = imread(['./frames/' File.name]);
    catch E
        continue;
    end
    
    CroppedImage = imcrop(Image, [295 452 416 48]);
    GrayCroppedImage = rgb2gray(CroppedImage);
    GrayCroppedImage = imadjust(GrayCroppedImage);
    
    thres = graythresh(GrayCroppedImage);
    imBW = im2bw(GrayCroppedImage, thres);
    [L1, L2] = size(GrayCroppedImage);
    
    sum = 0;
    for n = 1:L2
        sum = sum + imBW(round(L1/2), n);
    end
    
    if(sum == 0)
        CroppedName = imresize(imcrop(GrayCroppedImage, [0 0 416 23]), 2.5);
        CroppedTitle = imresize(imcrop(GrayCroppedImage, [0 25 416 26]), 2.5); 
    else
        CroppedName = GrayCroppedImage;
    end
    
    ReducedImage = mean(mean(CroppedImage, 1), 2);
  
%     imshow(edge(rgb2gray(Image), ''));

    ReducedVec = [ReducedImage(:,:,1), ReducedImage(:,:,2), ReducedImage(:,:,3)];
    Blue = [46.8840, 101.8790, 144.7839];
    Dist = norm(Blue - ReducedVec);

    if (Dist > 10 && Dist < 50)
        imwrite(CroppedImage, ['./output/cropped-' File.name]);
        imwrite(CroppedName, ['./output/name-' File.name]);
        if (exist('CroppedTitle'))
            imwrite(CroppedTitle, ['./output/title-' File.name]);
        end
        disp(['Dist in file ' File.name ' is ' num2str(Dist) '. Image is not empty bar'])
    else
%         disp('Image is empty bar');
    end
end

% exit(0);

% result = ocr(CroppedImage);

% SharpenedImage = imsharpen(CroppedImage, 'Radius', 2, 'Amount', 2);
% ResizedImage = imresize(CroppedImage, 4);
% imshow(ResizedImage);
% ContrastImage = imadjust(ResizedImage, [0.3 0.7], []);

%imagec = imopen(ResizedImage, strel('disk', 2))
%figure(); imshow(imagec);