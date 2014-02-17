
classdef Contour
    
    properties
        pts;
        hierarchy;
        box;
        boxVerts;
        boxEdges;
        redBoxVerts;
        redBoxEdges;
        redBoxCrop = [0,1;0,1];
        hull;
    end
    
    methods
        
        function   obj = Contour(contour,hierarchy)
            
            obj.pts = contour;
            obj.hierarchy = hierarchy;
            obj = obj.findRect;
            obj = obj.findHull;
            
        end
        
        function obj = findRect(obj)
            obj.box = cv.minAreaRect(obj.pts);
            obj.box.angle = obj.box.angle*2*pi/360;
            
            obj.boxEdges = [-obj.box.size(1)/2, 0                , obj.box.size(1)/2,  0 ;
                0                , obj.box.size(2)/2, 0                , -obj.box.size(2)/2];
            
            obj.boxVerts = [-obj.box.size(1)/2,obj.box.size(1)/2, obj.box.size(1)/2,-obj.box.size(1)/2;
                obj.box.size(2)/2,obj.box.size(2)/2,-obj.box.size(2)/2,-obj.box.size(2)/2];
            
            rr = [cos(obj.box.angle), - sin(obj.box.angle); sin(obj.box.angle), cos(obj.box.angle)];
            obj.boxEdges = rr * obj.boxEdges;
            obj.boxVerts = rr * obj.boxVerts;
            obj.boxEdges(1,:) = obj.boxEdges(1,:) + obj.box.center(1);
            obj.boxEdges(2,:) = obj.boxEdges(2,:) + obj.box.center(2);
            obj.boxVerts(1,:) = obj.boxVerts(1,:) + obj.box.center(1);
            obj.boxVerts(2,:) = obj.boxVerts(2,:) + obj.box.center(2);
            
            
        end
        
        function obj = findSquare(obj,pt)
            indx = Contour.close(obj.boxVerts,pt,2);
            squareWidth = min(obj.box.size);
            shift = [squareWidth * sin(-1* obj.box.angle); squareWidth * cos(obj.box.angle)];
            obj.redBoxVerts = [obj.boxVerts(:,indx(1)), obj.boxVerts(:,indx(2)), obj.boxVerts(:,indx(2))+shift, obj.boxVerts(:,indx(1))+shift];
            obj.redBoxCrop = uint32([min(obj.redBoxVerts(1,:)),max(obj.redBoxVerts(1,:));min(obj.redBoxVerts(2,:)),max(obj.redBoxVerts(2,:))]);
            redHull = obj.cropHull;
            obj.redBoxCrop = uint32([min(redHull(1,:)),max(redHull(1,:));min(redHull(2,:)),max(redHull(2,:))]);
        end
        
        function obj = findHull(obj)
                hullTemp = cv.convexHull(obj.pts);
                nHullPts = size(hullTemp,2);
                obj.hull = reshape(cell2mat(hullTemp),[2,nHullPts]);
        end
        
        function newHull = cropHull(obj,iMinMax)
            if nargin <=1
                iMinMax = obj.redBoxCrop;
            end
            indx = find((obj.hull(1,:)<iMinMax(1,2)) .* (obj.hull(1,:)>iMinMax(1,1)) .* (obj.hull(2,:)<iMinMax(2,2)) .* (obj.hull(2,:)>iMinMax(2,1)));
            newHull = obj.hull(:,indx);
        end
        
        
        function crop = cropImg(obj,img)
            if length(size(img)) >2
                crop = img(obj.redBoxCrop(1,1):obj.redBoxCrop(1,2),obj.redBoxCrop(2,1):obj.redBoxCrop(2,2),:);
            else
                crop = img(obj.redBoxCrop(1,1):obj.redBoxCrop(1,2),obj.redBoxCrop(2,1):obj.redBoxCrop(2,2));
            end
        end
        
        function drawHull(obj)
            for i=1:size(obj.hull,2)-1
                line([obj.hull(1,i),obj.hull(1,i+1)],[obj.hull(2,i),obj.hull(2,i+1)],'Color',[0,0.7,0]);
                rectangle('Position',[obj.hull(1,i),obj.hull(2,i),3,3],'Curvature',[1,1],'FaceColor','green')
            end
            line([obj.hull(1,size(obj.hull,2)), obj.hull(1,1)],[obj.hull(2,size(obj.hull,2)), obj.hull(1,2)],'Color',[0,0.7,0]);
            
        end
        
        function drawRect(obj)
            line([obj.boxVerts(1,:),obj.boxVerts(1,1)],[obj.boxVerts(2,:),obj.boxVerts(2,1)],'Color',[1,0.5,0])
            line([obj.redBoxVerts(1,:),obj.redBoxVerts(1,1)],[obj.redBoxVerts(2,:),obj.redBoxVerts(2,1)],'Color','red')
            for j = 1:size(obj.boxEdges,2)
                rectangle('Position',[obj.boxEdges(1,j),obj.boxEdges(2,j),3,3],'Curvature',[1,1],'FaceColor','yellow')
            end
            
        end
    end
    
    methods(Static)
        
        function indx = close(points,pt,num)
            indx = zeros(num);
            dist = sqrt((points(1,:) - pt(1)).^2 + (points(2,:) - pt(2)).^2);
            done = max(dist);
            for  i=1:num
                indx(i) = find((dist-min(dist))==0,1,'first');
                dist(indx(i)) = done;
            end
        end
        
    end
end