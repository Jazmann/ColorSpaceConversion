classdef Bin
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dims;
        bin;
        vals;
        bins;  % the counts for each bin.
        fBin; % bins normalised to 1:0 with zero bins removed.
        aScale;
        count = 0;
        a;
        
    end
    
    methods
        function obj = Bin(bins, aMin, aMax)
            obj.dims = length(bins);
            obj.aScale = aMax(:) - aMin(:);
            obj.vals = cell(obj.dims,1);
            
            obj.bins = cell(obj.dims,1);
            for i = 1:obj.dims
                obj.vals{i} = aMin(i):(obj.aScale(i))/(bins(i)-1):aMax(i);
                obj.bins{i} = uint32((0:obj.aScale(i)).*(bins(i))./(obj.aScale(i)+1))+1;
            end
            
            obj.bin = zeros(bins(1),bins(2),bins(3));
        end
        
        function self = addValue(self,pixel)
            self.bin(self.bins{1}(pixel(1)),self.bins{2}(pixel(2)),self.bins{3}(pixel(3))) = self.bin(self.bins{1}(pixel(1)),self.bins{2}(pixel(2)),self.bins{3}(pixel(3))) + 1;
            self.count = self.count + 1;
        end
        
        function self = norm(self)
            %--- Normalised Histogram data ---------------------
            % we remove zeros from the input bin data as some are due to the color
            % space rotation and they affect the sigma values.
            
            grid = cell(self.dims,1);
            if self.dims == 3
                [grid{1}, grid{2}, grid{3}] = meshgrid(self.vals{1}, self.vals{2}, self.vals{3});
            elseif obj.dims == 2
                [grid{1}, grid{2}] = meshgrid(self.vals{1}, self.vals{2});
                grid{1} = grid{1}';
                grid{2} = grid{2}';
            end
            loc = find(self.bin>0);
            locSub = zeros(length(loc),3);
            [locSub(:,1),locSub(:,2),locSub(:,3)] = ind2sub(size(self.bin),loc);
            self.fBin = self.bin(loc)/max(max(max(self.bin)));
            self.fBin = griddata(self.vals{1}(locSub(:,2)), self.vals{2}(locSub(:,1)), self.vals{3}(locSub(:,3)), self.fBin, grid{1}, grid{2}, grid{3});
            NaNLoc = isnan(self.fBin)==1;
            self.fBin(NaNLoc) = 0;
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
        
        function obj = show(obj)
            
            figure('Name','Bins','NumberTitle','off');
            subplot(1,3,1)
            imagesc(squeeze(sum(obj.bin,1)));
            subplot(1,3,2)
            imagesc(squeeze(sum(obj.bin,2)));
            subplot(1,3,3)
            imagesc(squeeze(sum(obj.bin,3)));
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
    
end



