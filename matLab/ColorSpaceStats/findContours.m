
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
        redBoxVerts;
        redBoxEdges;
        hull;
    end
    
    methods
        
        function   obj = findContours(image)
            obj.img = image;
            [obj.contours, obj.hierarchy] = cv.findContours(image);
            obj.nContours=size(obj.contours,2);
            obj.box = cell(1,obj.nContours);
            obj.boxVerts = cell(1,obj.nContours);
            obj.boxEdges = cell(1,obj.nContours);
            obj.redBoxVerts = cell(1,obj.nContours);
            obj.redBoxEdges = cell(1,obj.nContours);
            obj.hull = cell(1,obj.nContours);
            obj = obj.findRect;
            obj = obj.findHull;
            
        end
        
        function obj = findRect(obj)
            for i = 1:obj.nContours
                obj.box{i} = cv.minAreaRect(obj.contours{i});
                obj.box{i}.angle = obj.box{i}.angle*2*pi/360;
                
                obj.boxEdges{i} = [-obj.box{i}.size(1)/2,  0                   , obj.box{i}.size(1)/2, 0 ;
                    0                    , obj.box{i}.size(2)/2, 0                   ,-obj.box{i}.size(2)/2];
                
                obj.boxVerts{i} = [-obj.box{i}.size(1)/2,obj.box{i}.size(1)/2, obj.box{i}.size(1)/2,-obj.box{i}.size(1)/2;
                    obj.box{i}.size(2)/2,obj.box{i}.size(2)/2,-obj.box{i}.size(2)/2,-obj.box{i}.size(2)/2];
                
                rr = [cos(obj.box{i}.angle), - sin(obj.box{i}.angle); sin(obj.box{i}.angle), cos(obj.box{i}.angle)];
                obj.boxEdges{i} = rr * obj.boxEdges{i};
                obj.boxVerts{i} = rr * obj.boxVerts{i};
                obj.boxEdges{i}(1,:) = obj.boxEdges{i}(1,:) + obj.box{i}.center(1);
                obj.boxEdges{i}(2,:) = obj.boxEdges{i}(2,:) + obj.box{i}.center(2);
                obj.boxVerts{i}(1,:) = obj.boxVerts{i}(1,:) + obj.box{i}.center(1);
                obj.boxVerts{i}(2,:) = obj.boxVerts{i}(2,:) + obj.box{i}.center(2);
                
                dist = sqrt((obj.boxVerts{1}(1,:)-size(obj.img,2)/2).^2+(obj.boxVerts{1}(2,:)-size(obj.img,1)/2).^2);
                p1 = find(dist-min(dist)==0);
                dist = dist((find(dist-min(dist))));
                p2 = find(dist-min(dist)==0);
                squareWidth = min(obj.box{i}.size);
                shift = [squareWidth * sin(-1* obj.box{i}.angle); squareWidth * cos(obj.box{i}.angle)];
                obj.redBoxVerts{i} = [obj.boxVerts{i}(:,p1), obj.boxVerts{i}(:,p2), obj.boxVerts{i}(:,p2)+shift, obj.boxVerts{i}(:,p1)+shift];
                
            end
            
        end
        
        function obj = findHull(obj)
            
            for i = 1:obj.nContours
                hullTemp = cv.convexHull(obj.contours{i});
                nHullPts = size(hullTemp,2);
                obj.hull{i} = reshape(cell2mat(hullTemp),[2,nHullPts]);
            end
            
        end
        
        function showHull(obj)
            figure('Name',horzcat('Hull for ',obj.name),'NumberTitle','off');
            imagesc(obj.img)
            
            for j = 1:obj.nContours
                for i=1:size(obj.hull{j},2)-1
                    line([obj.hull{j}(1,i),obj.hull{j}(1,i+1)],[obj.hull{j}(2,i),obj.hull{j}(2,i+1)],'Color',[0,0.7,0]);
                    rectangle('Position',[obj.hull{j}(1,i),obj.hull{j}(2,i),3,3],'Curvature',[1,1],'FaceColor','green')
                end
                line([obj.hull{j}(1,size(obj.hull{j},2)), obj.hull{j}(1,1)],[obj.hull{j}(2,size(obj.hull{j},2)), obj.hull{j}(1,2)],'Color',[0,0.7,0]);
            end
            xlabel(obj.axisNames(2));
            ylabel(obj.axisNames(1));
            title(horzcat('Rect for ',obj.name));
            figure(gcf)
        end
        
        
        function showRect(obj)
            figure('Name',horzcat('Rect for ',obj.name),'NumberTitle','off');
            imagesc(obj.img)
            
            for i = 1:obj.nContours
                line([obj.boxVerts{i}(1,:),obj.boxVerts{i}(1,1)],[obj.boxVerts{i}(2,:),obj.boxVerts{i}(2,1)],'Color',[1,0.5,0])
                line([obj.redBoxVerts{i}(1,:),obj.redBoxVerts{i}(1,1)],[obj.redBoxVerts{i}(2,:),obj.redBoxVerts{i}(2,1)],'Color','red')
                for j = 1:size(obj.boxEdges{i},2)
                    rectangle('Position',[obj.boxEdges{i}(1,j),obj.boxEdges{i}(2,j),3,3],'Curvature',[1,1],'FaceColor','yellow')
                end
                
            end
            
            xlabel(obj.axisNames(2));
            ylabel(obj.axisNames(1));
            title(horzcat('Rect for ',obj.name));
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