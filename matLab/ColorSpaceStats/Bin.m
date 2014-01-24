classdef Bin
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name = 'Bins'; % A discriptive name of the bin.
        axisNames;
        dims;
        bin;
        vals;
        bins;  % the counts for each bin.
        fBin; % bins normalised to 1:0 .
        f; % interpolated data at non zero points.
        aScale;
        count = 0;
        a;
        
    end
    
    methods
        function obj = Bin(bins, aMin, aMax)
            obj.dims = length(bins);
            obj.aScale = aMax(:) - aMin(:);
            obj.vals = cell(obj.dims,1);
            obj.bin = zeros(bins);
            obj.bins = cell(obj.dims,1);
            names = ['a','b','c','d','e'];
            obj.axisNames = names(1:obj.dims);
            
            if nargin >=2
                for i = 1:obj.dims
                    obj.vals{i} = aMin(i):(obj.aScale(i))/(bins(i)-1):aMax(i);
                    obj.bins{i} = uint32((0:obj.aScale(i)).*(bins(i))./(obj.aScale(i)+1))+1;
                end
            end
            
        end
        
        function self = addValue(self,pixel)
            self.bin(self.bins{1}(pixel(1)),self.bins{2}(pixel(2)),self.bins{3}(pixel(3))) = self.bin(self.bins{1}(pixel(1)),self.bins{2}(pixel(2)),self.bins{3}(pixel(3))) + 1;
            self.count = self.count + 1;
        end
        
        function self = norm(self)
            %--- Normalised Histogram data ---------------------
            self.fBin = self.bin ./ max(max(max(self.bin)));
        end
        
        function self = smooth(self)
            %--- Normalised Histogram data ---------------------
            % we remove zeros from the input bin data as some are due to the color
            % space rotation and they affect the sigma values.
            if self.dims == 2
                G = fspecial('gaussian',[3,3],1);
                self.fBin = imfilter(self.fBin,G,'same');
            end
        end
        
        function self = fit(self)
            %--- Normalised Histogram data ---------------------
            % we remove zeros from the input bin data as some are due to the color
            % space rotation and they affect the sigma values.
            loc = find(self.bin>0);
            locSub = zeros(length(loc),3);
            [locSub(:,1),locSub(:,2),locSub(:,3)] = ind2sub(size(self.bin),loc);
            self.fBin = self.bin(loc)/max(max(max(self.bin)));
            self.f = TriScatteredInterp(self.vals{1}(locSub(:,2)), self.vals{2}(locSub(:,1)), self.vals{3}(locSub(:,3)), self.fBin);
            NaNLoc = isnan(binOut)==1;
            self.fBin(NaNLoc) = 0;
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
        
        function self = mean(self)
            cT = [0 0 0];
            for i = 1:self.bins{1}
                for j = 1:self.bins{2}
                    for k = 1:self.bins{3}
                        cT(1) = cT(1) + self.bin(k,j,i) * self.vals(1,k,j,i);
                        cT(2) = cT(2) + self.bin(k,j,i) * self.vals(2,k,j,i);
                        cT(3) = cT(3) + self.bin(k,j,i) * self.vals(3,k,j,i);
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
            loc = find(maskBin.bin > thresh);
            obj.bin(loc) = 0;
            obj.name = strcat(obj.name,' ! ',maskBin.name);
        end
        
        function obj = show(obj)
            if obj.dims ==3
                figure('Name',obj.name,'NumberTitle','off');
                subplot(1,3,1)
                imagesc(squeeze(sum(obj.bin,1)));
                subplot(1,3,2)
                imagesc(squeeze(sum(obj.bin,2)));
                subplot(1,3,3)
                imagesc(squeeze(sum(obj.bin,3)));
            elseif obj.dims == 2
                figure('Name','2D Bins','NumberTitle','off');
                imagesc(obj.bin);
            end
        end
        
        
        function obj = showNormBin(obj)
            figure('Name','Normalized Bins','NumberTitle','off');
            subplot(1,3,1)
            imagesc(squeeze(sum(obj.fBin,1)));
            subplot(1,3,2)
            imagesc(squeeze(sum(obj.fBin,2)));
            subplot(1,3,3)
            imagesc(squeeze(sum(obj.fBin,3)));
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
        end
        
        
        function binOut = negateBins(bin, maskBin)
            loc = find(maskBin.bin);
            binOut = bin;
            binOut.bin(loc) = 0;
            binOut.name = strcat(binOut.name,' ! ',maskBin.name);
        end
    end
end



