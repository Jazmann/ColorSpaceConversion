classdef Bin
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name = 'Bins'; % A discriptive name of the bin.
        axisNames;
        dims;
        nBins;
        bin;
        vals;
        bins;  % the counts for each bin.
        fBin; % bins normalised to 1:0 .
        f; % interpolated data at non zero points.
        g;
        gMean = [0,0];
        gSigma = [0,0];
        gTheta = 0;;
        gAmp = 1.0;
        aMin; aMax; aScale;
        count = 0;
        a;
        subs; loc;
        
    end
    
    methods
        function obj = Bin(nBins, aMin, aMax)
            obj.dims = length(nBins);
            obj.nBins = nBins;
            obj.aMin = aMin; obj.aMax = aMax; obj.aScale = aMax(:) - aMin(:);
            obj.vals = cell(obj.dims,1);
            obj.bin = zeros(nBins);
            obj.bins = cell(obj.dims,1);
            names = ['a','b','c','d','e'];
            obj.axisNames = names(1:obj.dims);
            
            if nargin >=2
                for i = 1:obj.dims
                    obj.vals{i} = aMin(i):(obj.aScale(i))/(nBins(i)-1):aMax(i);
                    obj.bins{i} = uint32((0:obj.aScale(i)).*(nBins(i))./(obj.aScale(i)+1))+1;
                end
            end
            
        end
        
        function obj = setAxis(obj, aMin, aMax)
            if length(aMax) == obj.dims && length(aMin) == obj.dims
                obj.aMin = aMin;
                obj.aMax = aMax;
                obj.aScale = obj.aMax(:) - obj.aMin(:);
                for i = 1:obj.dims
                    obj.vals{i} = aMin(i):(obj.aScale(i))/(obj.nBins(i)-1):aMax(i);
                end
                obj = obj.mean;
                
            end
        end
        
        function obj = addValue(obj,pixel)
            obj.bin(obj.bins{1}(pixel(1)),obj.bins{2}(pixel(2)),obj.bins{3}(pixel(3))) = obj.bin(obj.bins{1}(pixel(1)),obj.bins{2}(pixel(2)),obj.bins{3}(pixel(3))) + 1;
            obj.count = obj.count + 1;
        end
        
        function obj = norm(obj)
            %--- Normalised Histogram data ---------------------
            if isempty(obj.fBin)
                obj.fBin = obj.bin ./ max(max(max(obj.bin)));
            else
                obj.fBin = obj.fBin ./ max(max(max(obj.fBin)));
            end
            NaNLoc = isnan(obj.fBin)==1;
            obj.fBin(NaNLoc) = 0;
        end
        
        function obj = removeZeros(obj,rad)
            obj.loc = find(obj.fBin);
            obj = obj.resetSubs;
            mask = ones(size(obj.fBin));
            if obj.dims == 2
                for i = 1:length(obj.subs(:,1))
                    mask(obj.subs(i,1)-rad:obj.subs(i,1)+rad,obj.subs(i,2)-rad:obj.subs(i,2)+rad) = 0;
                end
            elseif obj.dims == 3
                for i = 1:length(obj.subs(:,1))
                    mask(obj.subs(i,1)-rad:obj.subs(i,1)+rad,obj.subs(i,2)-rad:obj.subs(i,2)+rad,obj.subs(i,3)-rad:obj.subs(i,3)+rad) = 0;
                end
            end
            keep = find(mask);
            obj.loc = vertcat(obj.loc,keep);
            obj = obj.resetSubs;
            obj = obj.fit;
            grid = obj.grid;
            obj.fBin = obj.f(grid{2},grid{1});
            minCount = 1.0/max(max(obj.bin));
            loc = find(obj.fBin < minCount);
            obj.fBin(loc) = 0;
        end
        
        function obj = resetSubs(obj)
            obj.subs = zeros(length(obj.loc),obj.dims);
            if obj.dims ==2
                [obj.subs(:,1), obj.subs(:,2)] = ind2sub(size(obj.fBin),obj.loc);
            elseif obj.dims ==3
                [obj.subs(:,1), obj.subs(:,2), obj.subs(:,3)] = ind2sub(size(obj.fBin),obj.loc);
            end
        end
        
        function obj = smooth(obj)
            %--- Normalised Histogram data ---------------------
            % we remove zeros from the input bin data as some are due to the color
            % space rotation and they affect the sigma values.
            if obj.dims == 2
                G = fspecial('gaussian',[3,3],1);
                obj.fBin = imfilter(obj.fBin,G,'same');
            end
        end
        
        function obj = fit(obj)
            %--- Normalised Histogram data ---------------------
            % we remove zeros from the input bin data as some are due to the color
            % space rotation and they affect the sigma values.
            if obj.dims ==2
                obj.f = TriScatteredInterp(obj.vals{2}(obj.subs(:,2))', obj.vals{1}(obj.subs(:,1))', obj.fBin(obj.loc));
            elseif obj.dims ==3
                obj.f = TriScatteredInterp(obj.vals{2}(obj.subs(:,2))', obj.vals{1}(obj.subs(:,1))', obj.vals{3}(obj.subs(:,3))', obj.fBin(obj.loc));
            end
        end
        
        function obj = gFit(obj)
            xdata = zeros(obj.nBins(1),obj.nBins(2),2);
            [ xdata(:,:,1), xdata(:,:,2)] =  meshgrid(obj.vals{2},obj.vals{1});
            x0 = [1.0, obj.a(2),         obj.aScale(2)/4.0,                obj.a(1),        obj.aScale(1)/4.0,                0.0]; % Inital guess parameters
            lb = [0.9, obj.vals{2}(1),   obj.aScale(2)*(3.0/obj.nBins(2)), obj.vals{1}(1),  obj.aScale(1)*(3.0/obj.nBins(1)),-pi/4];
            ub = [1.0, obj.vals{2}(end), obj.aScale(2),                    obj.vals{1}(end),obj.aScale(1),                    pi/4];
            [x,resnorm,residual,exitflag] = lsqcurvefit(@D2GaussFunctionRot,x0,xdata,obj.fBin,lb,ub);
            obj.gAmp = x(1);
            obj.gMean(2) = x(2);
            obj.gSigma(2) = x(3);
            obj.gMean(1) = x(4);
            obj.gSigma(1) = x(5);
            obj.gTheta = x(6);
        end
        
        function grid = grid(obj)
            grid = cell(obj.dims,1);
            if obj.dims == 3
                [grid{1}, grid{2}, grid{3}] = meshgrid(obj.vals{1}, obj.vals{2}, obj.vals{3});
            elseif obj.dims == 2
                [grid{1}, grid{2}] = meshgrid(obj.vals{1}, obj.vals{2});
                grid{1} = grid{1}';
                grid{2} = grid{2}';
            end
        end
        
        function obj = mean(obj)
            if obj.dims == 3
                cT = [0 0 0];
                for i = 1:obj.nBins(1)
                    for j = 1:obj.nBins(2)
                        for k = 1:obj.nBins(3)
                            cT(1) = cT(1) + obj.bin(i,j,k) * obj.vals{1}(i);
                            cT(2) = cT(2) + obj.bin(i,j,k) * obj.vals{2}(j);
                            cT(3) = cT(3) + obj.bin(i,j,k) * obj.vals{3}(k);
                        end
                    end
                end
            elseif obj.dims == 2
                cT = [0 0];
                for i = 1:obj.nBins(1)
                    for j = 1:obj.nBins(2)
                        cT(1) = cT(1) + obj.bin(i,j) * obj.vals{1}(i);
                        cT(2) = cT(2) + obj.bin(i,j) * obj.vals{2}(j);
                    end
                end
            end
            obj.a = cT/obj.count;
        end
        
        function binOut = collapse(obj, d, range)
            ind = sort([mod(d,obj.dims)+1,mod(d+1,obj.dims)+1]);
            binOut = Bin([length(obj.vals{ind(1)}),length(obj.vals{ind(2)})], [obj.vals{ind(1)}(1),obj.vals{ind(2)}(1)], [obj.vals{ind(1)}(end),obj.vals{ind(2)}(end)]);
            binOut.axisNames = [obj.axisNames(ind(1)),obj.axisNames(ind(2))];
            binOut.name = strcat(obj.name,'_',obj.axisNames(ind(1)),obj.axisNames(ind(2)));
            if nargin <=2
                if d==1
                    binOut.bin = squeeze(sum(obj.bin,d));
                elseif d==2
                    binOut.bin = squeeze(sum(obj.bin,d));
                elseif d==3
                    binOut.bin = squeeze(sum(obj.bin,d));
                end
            else
                if d==1
                    binOut.bin = squeeze(sum(obj.bin(range(1):range(2),:,:),d));
                elseif d==2
                    binOut.bin = squeeze(sum(obj.bin(:,range(1):range(2),:),d));
                elseif d==3
                    binOut.bin = squeeze(sum(obj.bin(:,:,range(1):range(2)),d));
                end
            end
            binOut.count = obj.count;
        end
        
        function obj = add(obj, addBin)
            obj.bin = obj.bin + addBin.bin;
            obj.count = obj.count + addBin.count;
            obj.name = strcat(obj.name,' + ',addBin.name);
        end
        
        function obj = negate(obj, maskBin,thresh)
            if nargin <=2
                thresh = 0;
            end
            if isa(maskBin,'Bin')
                Loc = find(maskBin.bin > thresh);
                obj.name = strcat(obj.name,' ! ',maskBin.name);
            else
                Loc = find(maskBin>thresh);
            end
            obj.bin(Loc) = 0;
            obj.count = sum(sum(sum(obj.bin)));
        end
        
        
        function obj = fNegate(obj, maskBin, thresh)
            if nargin <=2
                thresh = 0;
            end
            if isa(maskBin,'Bin')
                Loc = find(maskBin.fBin > thresh);
                obj.name = strcat(obj.name,' ! ',maskBin.name);
            else
                Loc = find(maskBin>thresh);
            end
            obj.fBin(Loc) = 0;
        end
        
        function obj = show(obj)
            if obj.dims ==3
                figure('Name',strcat('3D ',obj.name,' bin'),'NumberTitle','off');
                subplot(1,3,1)
                imagesc(obj.vals{3},obj.vals{2},squeeze(sum(obj.bin,1)));
                xlabel(obj.axisNames(3));
                ylabel(obj.axisNames(2));
                subplot(1,3,2)
                imagesc(obj.vals{3},obj.vals{1},squeeze(sum(obj.bin,2)));
                xlabel(obj.axisNames(3));
                ylabel(obj.axisNames(1));
                subplot(1,3,3)
                imagesc(obj.vals{2},obj.vals{1},squeeze(sum(obj.bin,3)));
                xlabel(obj.axisNames(2));
                ylabel(obj.axisNames(1));
            elseif obj.dims == 2
                figure('Name',strcat('2D ',obj.name,' bin'),'NumberTitle','off');
                imagesc(obj.vals{2},obj.vals{1},obj.bin);
                xlabel(obj.axisNames(2));
                ylabel(obj.axisNames(1));
            end
            figure(gcf);
        end
        
        function obj = binShow(obj,nContours)
            if nargin <= 1
                nContours = 25;
            end
            if isa(nContours,'number')
                vMax = max(max(max(obj.bin)));
                vStep = ceil(vMax / nContours);
                v = 1:vStep:vMax-vStep+1;
            else
                v = nContours;
            end
            if obj.dims ==3
                figure('Name',obj.name,'NumberTitle','off');
                subplot(1,3,1)
                contour(obj.vals{3},obj.vals{2},squeeze(sum(obj.bin,1)), v);
                xlabel(obj.axisNames(3));
                ylabel(obj.axisNames(2));
                subplot(1,3,2)
                contour(obj.vals{3},obj.vals{1},squeeze(sum(obj.bin,2)), v);
                xlabel(obj.axisNames(3));
                ylabel(obj.axisNames(1));
                subplot(1,3,3)
                contour(obj.vals{2},obj.vals{1},squeeze(sum(obj.bin,3)), v);
                xlabel(obj.axisNames(2));
                ylabel(obj.axisNames(1));
            elseif obj.dims == 2
                figure('Name',strcat('2D ',obj.name),'NumberTitle','off');
                contour(obj.vals{2},obj.vals{1},obj.bin, v);
                xlabel(obj.axisNames(2));
                ylabel(obj.axisNames(1));
            end
            figure(gcf);
        end
        
        function obj = fShow(obj,nContours)
            if nargin <= 1
                nContours = 25;
            end
            if obj.dims ==3
                figure('Name',obj.name,'NumberTitle','off');
                subplot(1,3,1)
                contour(obj.vals{3},obj.vals{2},squeeze(sum(obj.fBin,1)), nContours);
                xlabel(obj.axisNames(3));
                ylabel(obj.axisNames(2));
                subplot(1,3,2)
                contour(obj.vals{3},obj.vals{1},squeeze(sum(obj.fBin,2)), nContours);
                xlabel(obj.axisNames(3));
                ylabel(obj.axisNames(1));
                subplot(1,3,3)
                contour(obj.vals{2},obj.vals{1},squeeze(sum(obj.fBin,3)), nContours);
                xlabel(obj.axisNames(2));
                ylabel(obj.axisNames(1));
            elseif obj.dims == 2
                figure('Name',strcat('2D ',obj.name),'NumberTitle','off');
                contour(obj.vals{2},obj.vals{1},obj.fBin, nContours);
                xlabel(obj.axisNames(2));
                ylabel(obj.axisNames(1));
            end
            figure(gcf);
        end
        
        
        function obj = showNormBin(obj)
            figure('Name','Normalized Bins','NumberTitle','off');
            subplot(1,3,1)
            imagesc(squeeze(sum(obj.fBin,1)));
            subplot(1,3,2)
            imagesc(squeeze(sum(obj.fBin,2)));
            subplot(1,3,3)
            imagesc(squeeze(sum(obj.fBin,3)));
            figure(gcf);
        end
    
    
        function gShow(obj, nContours)
            figure('Name',strcat('Gaussian fit ',obj.name),'NumberTitle','off');
            if nargin <= 2
                nContours = 25;
            end
            xdata = zeros(obj.nBins(1), obj.nBins(2),2);
            [ xdata(:,:,1), xdata(:,:,2)] =  meshgrid(obj.vals{2}, obj.vals{1});
            gF = D2GaussFunctionRot([obj.gAmp, obj.gMean(2), obj.gSigma(2), obj.gMean(1),obj.gSigma(1),obj.gTheta],xdata);
            contour(obj.vals{2},obj.vals{1},gF, nContours);
            figure(gcf);
        end
    end
    
    methods (Static = true)
        
        function overlap(bin1,bin2, thresh)
            if nargin <=2
                thresh = 0;
            end
            bin1Max = max(max(max(bin1.bin)));
            bin2Max = max(max(max(bin2.bin)));
            test = zeros(size(bin1.bin));
            loc = find(bin1.bin > thresh * bin1Max);
            test(loc)=1;
            loc = find(bin2.bin > thresh * bin2Max);
            test(loc)=test(loc)+2;
            figure('Name',strcat('Overlap of ',bin1.name,' and ',bin2.name),'NumberTitle','off')
            imagesc(test)
            figure(gcf);
        end
        
        
        function binOut = negateBins(bin, maskBin)
            loc = find(maskBin.bin);
            binOut = bin;
            binOut.bin(loc) = 0;
            binOut.name = strcat(binOut.name,' ! ',maskBin.name);
            binOut.count = sum(sum(sum(binOut.bin)));
        end
        
        function showGaussianFit(bin, x, nContours)
            figure('Name','Gaussian fit','NumberTitle','off');
            if nargin <= 2
                nContours = 25;
            end
            xdata = zeros(bin.nBins(1),bin.nBins(2),2);
            [ xdata(:,:,1), xdata(:,:,2)] =  meshgrid(bin.vals{2},bin.vals{1});
            gF = D2GaussFunctionRot(x,xdata);
            contour(bin.vals{2},bin.vals{1},gF, nContours);
            figure(gcf);
        end
    end
end



