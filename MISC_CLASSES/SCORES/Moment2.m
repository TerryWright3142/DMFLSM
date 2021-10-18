classdef  Moment2 < Score 
    %returns the kurtosis score from the image (background corrected)
    properties  
       x
       y
       dx
       dy
       mode_x;
       mode_y;
       im
       xc
       yc
    end
    
    methods 
        function obj = Moment2(x1, y1, dx1, dy1)
            obj.x = x1;
            obj.y = y1;
            obj.dx = dx1;
            obj.dy = dy1;

        end

        function  [xmode, ymode] = FindMode(obj, image)
            image = medfilt2(image);  %median fliter
            subimage = double(image( obj.y:(obj.y + obj.dy), obj.x:(obj.x + obj.dx)));
            maxValue = max(subimage(:));
            % Find all locations where it exists.
            [rowsOfMaxes, colsOfMaxes] = find(subimage == maxValue);
            obj.mode_y = mean(rowsOfMaxes);
            obj.mode_x = mean(colsOfMaxes);
            xmode = obj.mode_x + obj.x;
            ymode = obj.mode_y + obj.y;
            
            subimage(uint32(round(obj.mode_y)), uint32(round(obj.mode_x))) = 0;
            imagesc(subimage);
            drawnow;
             % fprintf('%d %d %d %d\n', obj.x, obj.y, obj.dx, obj.dy);
            
        end
        function val = FindScore(obj, image, mx, my)
            %fprintf('%d %d %d %d\n', obj.x, obj.y, obj.dx, obj.dy);
      
            image = medfilt2(image);  %median fliter
            subimage = double(image( obj.y:(obj.y + obj.dy), obj.x:(obj.x + obj.dx)));          
            totPhotons = sum(subimage(:));
            [X,Y]   = meshgrid(1:size(subimage, 2), 1:size(subimage, 1) );
            if nargin == 2
                momentX = subimage.*X;
                momentY = subimage.*Y;
                obj.xc = sum(momentX(:))/totPhotons;
                obj.yc = sum(momentY(:))/totPhotons;
            else
                obj.xc = mx;
                obj.yc = my;
            end

            
            R2 = (X - obj.xc).^2 + (Y - obj.yc).^2;
            R = sqrt(R2) ; 
            Rmoment = R.*subimage; 
            R2moment = R2.*subimage;
            Rmean = sum(Rmoment(:))/totPhotons;
            R2mean = sum(R2moment(:))/totPhotons;
            
            % to give a summary of the distribution give a measure of
            % location and dispersion
            %val = sqrt(R2mean - Rmean^2);
            
            val = Rmean;
            
            
 
            imagesc(subimage);
            drawnow;
      
        end

    end


end