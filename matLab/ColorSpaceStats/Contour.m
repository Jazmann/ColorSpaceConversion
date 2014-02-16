
classdef Contour
    
    properties
        pts;
        hierarchy;
        box;
        boxVerts;
        boxEdges;
        redBoxVerts;
        redBoxEdges;
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
            
            dist = sqrt((obj.boxVerts{1}(1,:)-size(obj.img,2)/2).^2+(obj.boxVerts{1}(2,:)-size(obj.img,1)/2).^2);
            p1 = find(dist-min(dist)==0);
            dist = dist((find(dist-min(dist))));
            p2 = find(dist-min(dist)==0);
            squareWidth = min(obj.box.size);
            shift = [squareWidth * sin(-1* obj.box.angle); squareWidth * cos(obj.box.angle)];
            obj.redBoxVerts = [obj.boxVerts(:,p1), obj.boxVerts(:,p2), obj.boxVerts(:,p2)+shift, obj.boxVerts(:,p1)+shift];
            
        end
        
        function obj = findHull(obj)
            
            for i = 1:obj.nContours
                hullTemp = cv.convexHull(obj.contours{i});
                nHullPts = size(hullTemp,2);
                obj.hull{i} = reshape(cell2mat(hullTemp),[2,nHullPts]);
            end
            
        end
        
        function newHull = cropHull(obj,iMinMax)
            indx = find((obj.hull{1}(1,:)<iMinMax(1,2)) .* (obj.hull{1}(1,:)>iMinMax(1,1)));
            newHull = obj.hull(indx);
        end
        function showHull(obj)
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
            dist = sqrt((points(1,:) - pt(1))^2 + (points(2,:) - pt(2))^2);
            for  i=1:num
                indx(i) = find((dist-min(dist))==0);
                dist = dist((find(dist-min(dist))));
            end
        end
        
    end
end