dirName = 'JSkinSamples';
D = [dir(strcat(dirName,'/*.jpg')),dir(strcat(dirName,'/*.JPG'))];
mkdir(dirName,'Neg');
% D = dir('SkinSamples/*.jpg');
imcell = cell(1,numel(D));
for k = 1:numel(D)
  imcell{k} = imread(strcat(dirName,'/',D(k).name));
end

for j = 1:numel(D)
for k = j+1:numel(D)
    [path,name1,ext] = fileparts(D(j).name);
    [path,name2,ext] = fileparts(D(k).name);
    deltaImage = negGet(imcell{j},imcell{k},[138,273],[164,303]);
    
imwrite(deltaImage, strcat(dirName,'/Neg/',name1,'_',name2,'.jpg'));
    
end

end