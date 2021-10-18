classdef  SkewScore < Score 
    %returns the score from the image (background corrected
    properties  
       x
       y
       dx
       dy
       centroid_x;
       centroid_y;
       im
       background;
       bShowRect;
       bShowScore;
    end
    
    methods 
        function obj = SkewScore(x1, y1, dx1, dy1)
            %%define the rectangle to find the centroid
            obj.x = x1;
            obj.y = y1;
            obj.dx = dx1;
            obj.dy = dy1;
            obj.centroid_x = 0;
            obj.centroid_y = 0;
            obj.bShowRect = false;
            obj.bShowScore = false;
        end
        function SetShowRect(obj, bShowRect)
            obj.bShowRect = bShowRect;
        end
        function SetShowScore(obj, bShowScore)
            obj.bShowScore = bShowScore;
        end
        function SetBackground(obj, background)
            %%check this c++ like syntax
            obj.background = background;
        end
        function val = FindScore(obj, image)
            image = medfilt2(image);  %median fliter
            image = double(image) - double(obj.background);
            y_run = (obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2));
            x_run = (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2));
            [X,Y]   = meshgrid(1:size(image, 2), 1:size(image, 1) );
            mask = boolean(zeros(size(image)));
            mask((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
            (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2))) = true;

            subimage = reshape(image(mask), [length(y_run), length(x_run)]);
            subX = reshape(X(mask), [length(y_run), length(x_run)]);
            subY = reshape(Y(mask), [length(y_run), length(x_run)]);


            totPhotons = sum(subimage(:));
            Xmoment = subX.*subimage;
            obj.centroid_x = sum(Xmoment(:))/totPhotons;
            Ymoment = subY.*subimage;
            obj.centroid_y = sum(Ymoment(:))/totPhotons;

            obj.centroid_x = obj.x;
            obj.centroid_y = obj.y;
            
            R2 = (subX - obj.centroid_x).^2 + (subY - obj.centroid_y).^2 ; 
            R2moment = R2.*subimage; %using pixel value as frequency
            val = sqrt(sum(R2moment(:))/totPhotons);
            Z = sqrt(R2)/val;
            Z3 = Z.^3;
            val = abs(sum(Z3(:))/totPhotons);
            
            
            
            
            
            
             if obj.bShowRect
                 image((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                    (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2))) = 5000;
                 obj.im = image;
             else
                 obj.im = image((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                    (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2)));
             end
             
             if obj.bShowScore
%                  disp(strcat('centroid = ',string(obj.centroid_x), ",", string(obj.centroid_y)));
%                  disp(strcat('score = ', string(val)));
%                  drawnow;
             end

      
        end
        function DrawImage(obj)
            if size(obj.im, 1)>0
                imagesc(obj.im);
                colormap(gray);
                drawnow;
             
            end
        end

    end


end