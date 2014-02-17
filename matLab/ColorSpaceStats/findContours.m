
classdef findContours
    
    properties
        name = 'Contours'; % A discriptive name of the Contours.
        axisNames = ['x,','y'];
        img;
        contours;
        nContours;
        imgCenter;
    end
    
    methods
        
        function   obj = findContours(image)
            obj.img = image;
            obj.imgCenter = [size(image,1)/2,size(image,2)/2];
            [conts, hier] = cv.findContours(image);
            obj.nContours=size(conts,2);
                
            for i=1:obj.nContours
                obj.contours{i} = Contour(conts{i},hier{i});
                obj.contours{i} = obj.contours{i}.findSquare(obj.imgCenter);
                
            end
            
        end
        
        
        
        function showHull(obj)
            figure('Name',horzcat('Hull for ',obj.name),'NumberTitle','off');
            imagesc(obj.img)
            
            for i = 1:obj.nContours
                obj.contours{i}.drawHull;
            end
            xlabel(obj.axisNames(2));
            ylabel(obj.axisNames(1));
            title(horzcat('Hull for ',obj.name));
            figure(gcf)
        end
        
         function show(obj)
            figure('Name',horzcat('Shapes for ',obj.name),'NumberTitle','off');
            imagesc(obj.img)
            
            for i = 1:obj.nContours
                obj.contours{i}.drawHull;
                obj.contours{i}.drawRect;
            end
            xlabel(obj.axisNames(2));
            ylabel(obj.axisNames(1));
            title(horzcat('Shapes for ',obj.name));
            figure(gcf)
        end
        
        
        function showRect(obj)
            figure('Name',horzcat('Rect for ',obj.name),'NumberTitle','off');
            imagesc(obj.img)
            
            for i=1:obj.nContours
                obj.contours{i}.drawRect;
            end
            
            xlabel(obj.axisNames(2));
            ylabel(obj.axisNames(1));
            title(horzcat('Rect for ',obj.name));
            figure(gcf)
        end
        
        
        
        function out = showContours(obj)
            out = zeros(size(obj.img));
            for j=1:obj.nContours
                s = size(obj.contours{j}.pts,2);
                for i=1:s
                    p = obj.contours{j}.pts{i};
                    out(p(2)+1,p(1)+1) = j;
                end
            end
            
            
        end
        
        
    end
end