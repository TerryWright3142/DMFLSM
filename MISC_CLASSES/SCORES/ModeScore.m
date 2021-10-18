classdef  ModeScore < Score 
    %returns the score from the image (background corrected
    properties  
       x
       y
       dx
       dy
       mode_x;
       mode_y;
       im
       background;
       bShowRect;
       bShowScore;
       avBack
    end
    
    methods 
        function obj = ModeScore(x1, y1, dx1, dy1)
            %%define the rectangle to find the centroid
            obj.x = x1;
            obj.y = y1;
            obj.dx = dx1;
            obj.dy = dy1;
            obj.mode_x = 0;
            obj.mode_y = 0;
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
            obj.avBack = mean(obj.background(:));
        end
        function val = FindNormalisedScore(obj, image)
            image = medfilt2(image);  %median fliter
            image = double(image) - double(obj.background);
            y_run = (obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2));
            x_run = (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2));
            [X,Y]   = meshgrid(1:size(image, 2), 1:size(image, 1) );
            mask = boolean(zeros(size(image)));
            mask((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
            (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2))) = true;

            subimage = reshape(image(mask), [length(y_run), length(x_run)]);
            %the subimage should contain out pinhole and be of width x_run
            %and depth y_run
            threshimage = zeros(size(subimage));
            threshimage(subimage > 150) = 1; %%%check
           
            thsh = subimage.*threshimage;
            total = sum(thsh(:));
            maxValue = max(subimage(:));
            % Find all locations where it exists.
            [rowsOfMaxes, colsOfMaxes] = find(subimage == maxValue);
            obj.mode_y = mean(rowsOfMaxes);
            obj.mode_x = mean(colsOfMaxes);
            val = -maxValue/total;    
            obj.im = image((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                    (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2)));
            obj.im(round(obj.mode_y), round(obj.mode_x)) = 0;
       
           
            
        end
        function val = FindScore(obj, image)
            %do we need to worry about the representation of the number
             image = medfilt2(image);  %median fliter
             image = double(image) - double(obj.background);
             y_run = (obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2));
             x_run = (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2));
            [X,Y]   = meshgrid(1:size(image, 2), 1:size(image, 1) );
            mask = boolean(zeros(size(image)));
            mask((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2))) = true;
     
            subimage = reshape(image(mask), [length(y_run), length(x_run)]);


            maxValue = max(subimage(:));
            % Find all locations where it exists.
            [rowsOfMaxes, colsOfMaxes] = find(subimage == maxValue);
            obj.mode_y = mean(rowsOfMaxes);
            obj.mode_x = mean(colsOfMaxes);

            val = -maxValue;

     
          
            obj.im = image((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                    (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2)));
            obj.im(round(obj.mode_y), round(obj.mode_x)) = 0;
       

      
        end
        function [xm,ym] = GetMode(obj)
            xm = obj.mode_x;
            ym = obj.mode_y;
            
        end
        function DrawImage(obj)
            if size(obj.im, 1)>0
                imagesc(obj.im);         
                drawnow;
             
            end
        end

    end


end