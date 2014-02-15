
classdef findContours
    
    properties
        name = 'Contours'; % A discriptive name of the Contours.
        axisNames = ['x,','y'];
        img;
        contours;
        hierarchy;
        nContours;
        box;
        boxVerts;
        boxEdges;
    end
    
    methods
        
        function   obj = findContours(image)
            obj.img = image;
            [obj.contours, obj.hierarchy] = cv.findContours(image);
            obj.nContours=size(obj.contours,2);
            obj.box = cell(1,obj.nContours);
            obj.boxVerts = cell(1,obj.nContours);
            obj.boxEdges = cell(1,obj.nContours);
            obj = obj.findRect;
            
        end
        
        function obj = findRect(obj)
            for i = 1:obj.nContours
            obj.box{i} = cv.minAreaRect(obj.contours{i});
            
            obj.boxEdges{i} = [-obj.box{i}.size(1)/2,  0                   , obj.box{i}.size(1)/2, 0 ;
                                0                    , obj.box{i}.size(2)/2, 0                   ,-obj.box{i}.size(2)/2];
            
            obj.boxVerts{i} = [-obj.box{i}.size(1)/2,obj.box{i}.size(1)/2, obj.box{i}.size(1)/2,-obj.box{i}.size(1)/2;
                obj.box{i}.size(2)/2,obj.box{i}.size(2)/2,-obj.box{i}.size(2)/2,-obj.box{i}.size(2)/2];
            
            rr = [cos(obj.box{i}.angle*2*pi/360.0), - sin(obj.box{i}.angle*2*pi/360.0); sin(obj.box{i}.angle*2*pi/360.0), cos(obj.box{i}.angle*2*pi/360.0)];
            obj.boxEdges{i} = rr * obj.boxEdges{i};
            obj.boxVerts{i} = rr * obj.boxVerts{i};
            obj.boxEdges{i}(1,:) = obj.boxEdges{i}(1,:) + obj.box{i}.center(1);
            obj.boxEdges{i}(2,:) = obj.boxEdges{i}(2,:) + obj.box{i}.center(2);
            obj.boxVerts{i}(1,:) = obj.boxVerts{i}(1,:) + obj.box{i}.center(1);
            obj.boxVerts{i}(2,:) = obj.boxVerts{i}(2,:) + obj.box{i}.center(2);
            end
            
        end
        
        function showRect(obj)
            figure('Name',horzcat('Contours for ',obj.name),'NumberTitle','off');
            imagesc(obj.img)
           
            for i = 1:obj.nContours
            line([obj.boxVerts{i}(1,:),obj.boxVerts{i}(1,1)],[obj.boxVerts{i}(2,:),obj.boxVerts{i}(2,1)])
            end
            
            xlabel(obj.axisNames(2));
            ylabel(obj.axisNames(1));
            title(horzcat('Contours for ',obj.name));
            figure(gcf)
        end
        
        
        
        function out = showContours(obj)
            out = obj.img;
            for j=1:obj.nContours
                s = size(obj.contours{j},2);
                for i=1:s
                    p = obj.contours{j}{1,i};
                    out(p(2)+1,p(1)+1) = j+1;
                end
                imagesc(out)
                figure(gcf)
            end
            
            figure('Name',horzcat('Contours for ',obj.name),'NumberTitle','off');
            imagesc(out)
            xlabel(obj.axisNames(2));
            ylabel(obj.axisNames(1));
            title(horzcat('Contours for ',obj.name));
            figure(gcf)
            
        end
        
        
    end
end