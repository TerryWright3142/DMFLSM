
classdef  KurtosisScore < Score 
    %returns the kurtosis score from the image (background corrected)
    properties  
       x
       y
       dx
       dy
       r
       im
    end
    
    methods 
        function obj = KurtosisScore(x, y, dx, dy,  r)
            obj.x = x;
            obj.y = y;
            obj.dx = dx;
            obj.dy = dy;
            obj.r = r;
        end

        function val = FindScore(obj, image)
            image = double(image);
            [height, width] = size(image);
            y_sub = max(1, obj.y - obj.dy) : min(obj.y + obj.dy, height);
            x_sub = max(1, obj.x - obj.dx) : min(obj.x + obj.dx, width);
            obj.im = image(y_sub, x_sub);
            
            maxValue = max(obj.im(:));
            % Find all locations where it exists.
            [rowsOfMaxes, colsOfMaxes] = find(obj.im == maxValue);
            mode_y = round(mean(rowsOfMaxes));
            mode_x = round(mean(colsOfMaxes));
            [X, Y] = meshgrid(x_sub, y_sub);%c
            
            mx = sum(X(:).*obj.im(:))/sum(obj.im(:));
            my = sum(Y(:).*obj.im(:))/sum(obj.im(:));            
            

            
            %take the points within a circle of radius obj.r
            R2 = ((Y - my).^2 + (X - mx).^2);
            R4 = R2.*R2.*R2;
            II = obj.im.*R4;
            r2 = obj.r^2;
            im_inside_circle = II(:);
            val = log(sum(im_inside_circle));
            imm = obj.im;
            imm( round(mode_y), round(mode_x)) = 0;
            imagesc(imm);
            drawnow();
            
            


      
        end


    end


end

