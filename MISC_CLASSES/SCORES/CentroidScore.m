classdef  CentroidScore < Score 
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
        function obj = CentroidScore(x1, y1, dx1, dy1)
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
             image = image - obj.background;
             image(image<0)=0;
            [Y,X]   = meshgrid(1:size(image, 2), 1:size(image, 1) );
            mask = zeros(size(image));
            mask((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2))) = 1;
        
            subimage = mask.*double(image);

             tot = sum(subimage(:));

             Xmoment = X.*subimage;
             obj.centroid_x = sum(Xmoment(:))/tot;
             Ymoment = Y.*subimage;
             obj.centroid_y = sum(Ymoment(:))/tot;
             val = -double(image( round(obj.centroid_x), round(obj.centroid_y)));
             if obj.bShowRect
                 image((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                    (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2))) = 5000;
                 obj.im = image;
             else
                 obj.im = image((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                    (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2)));
             end
             if obj.bShowScore
                 disp(strcat(string(round(obj.centroid_x)), ",", string(round(obj.centroid_y))));
                 disp(strcat('score = ', string(val)));
                 drawnow;
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