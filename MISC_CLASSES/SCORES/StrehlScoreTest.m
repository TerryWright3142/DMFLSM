classdef  StrehlScoreTest < Score 
    properties  
       x
       y
       dx
       dy
       r
       im
       background
       xx0 %%%%%rectangle for offset for high speed
       yy0
    end
    
    methods 
        function SetRectOffset(obj, x0, y0)
            obj.xx0 = x0 - 1;
            obj.yy0 = y0 - 1;
        end
        function obj = StrehlScoreTest(x, y, dx, dy,  r)
            obj.x = x;
            obj.y = y;
            obj.dx = dx;
            obj.dy = dy;
            obj.r = r;
            obj.xx0 = 0;
            obj.yy0 = 0;
            obj.background = 0;
        end
        function [xm, ym] = FindMean(obj, image)
            image = double(image);
            [height, width] = size(image);
            y_sub = max(1, obj.y - obj.dy) : min(obj.y + obj.dy, height);
            x_sub = max(1, obj.x - obj.dx) : min(obj.x + obj.dx, width);
            im_sub = image(y_sub, x_sub);           
  
            [X,Y] = meshgrid(x_sub, y_sub);

            momXX = X.*im_sub;
            xm = sum(momXX(:))/sum(im_sub(:));
            
            momYY = Y.*im_sub;
            ym = sum(momYY(:))/sum(im_sub(:));
       
        end
        function SetBackground(obj, bk)
            obj.background = bk;
        end
        function val = FindScore_20_11_20(obj, image1)
            [height, width] = size(image1);
            y_sub = (max(1, obj.y - obj.dy) : min(obj.y + obj.dy, height));%%%%%%%%%%
            x_sub = (max(1, obj.x - obj.dx) : min(obj.x + obj.dx, width));%%%%%%%%%
            
            obj.im = double(image1(y_sub, x_sub) - obj.background); % for now
%             imagesc(obj.im);
%             drawnow();
            [X, Y] = meshgrid(x_sub, y_sub);
            mx = sum(X(:).*obj.im(:))/sum(obj.im(:));
            my = sum(Y(:).*obj.im(:))/sum(obj.im(:));
            R = sqrt((Y - my).^2 + (X - mx).^2);
            im_inside_circle = obj.im(R <= obj.r);
            if sum(im_inside_circle) ~= 0
                val = max(im_inside_circle)/sum(im_inside_circle);
                   obj.im(obj.im == max(im_inside_circle)) = 200;
            else
                val = 0;
            end
% %             fprintf('%d, %d \n', mx - obj.x + obj.dx, my - obj.y + obj.dy);
% %             obj.im(R <= obj.r) = 100 +obj.im(R <= obj.r) ;
% %             obj.im( int16(my - obj.y + obj.dy +1), int16(mx - obj.x + obj.dx + 1)) = 30;
% %          
% %             imagesc(obj.im);
% % % % % %             title( [num2str(obj.x) ' ' num2str(obj.y)]);
% %             drawnow();
        end
        function val = FindScore(obj, image1, imBack)
            [height, width] = size(image1);
            y_sub = (max(1, obj.y - obj.dy) : min(obj.y + obj.dy, height));%%%%%%%%%%
            x_sub = (max(1, obj.x - obj.dx) : min(obj.x + obj.dx, width));%%%%%%%%%
            
            obj.im = double(image1(y_sub, x_sub))- double(imBack(y_sub, x_sub));
            [X, Y] = meshgrid(x_sub, y_sub);
            mx = sum(X(:).*obj.im(:))/sum(obj.im(:));
            my = sum(Y(:).*obj.im(:))/sum(obj.im(:));
            R = sqrt((Y - my).^2 + (X - mx).^2);
            im_inside_circle = obj.im(R <= obj.r);
            if sum(im_inside_circle) ~= 0
                val = max(im_inside_circle)/sum(im_inside_circle);
                   obj.im(obj.im == max(im_inside_circle)) = 200;
            else
                val = 0;
            end
% %             fprintf('%d, %d \n', mx - obj.x + obj.dx, my - obj.y + obj.dy);
% %             obj.im(R <= obj.r) = 100 +obj.im(R <= obj.r) ;
% %             obj.im( int16(my - obj.y + obj.dy +1), int16(mx - obj.x + obj.dx + 1)) = 30;
% %          
% %             imagesc(obj.im);
% % % % % %             title( [num2str(obj.x) ' ' num2str(obj.y)]);
% %             drawnow();
        end
            
        function val = FindScore_Old(obj, image)
            tic();
            image = double(image);
            [height, width] = size(image);
            %location of origin in the image
            y0 = max(1, obj.y - obj.dy) - 1;
            x0 = max(1, obj.x - obj.dx) - 1;
            y_sub = max(1, obj.y - obj.dy) : min(obj.y + obj.dy, height);
            x_sub = max(1, obj.x - obj.dx) : min(obj.x + obj.dx, width);
            obj.im = image(y_sub, x_sub);
            
            maxValue = max(obj.im(:));
            if maxValue == 0
                val = 0;
            else
                % Find all locations where it exists.
                [rowsOfMaxes, colsOfMaxes] = find(obj.im == maxValue);
                mode_y = round(mean(rowsOfMaxes));
                mode_x = round(mean(colsOfMaxes));
                
                %recentre
%                 obj.y = mode_y + y0;
%                 obj.x = mode_x + x0;
%                 y_sub = max(1, obj.y - obj.dy) : min(obj.y + obj.dy, height);
%                 x_sub = max(1, obj.x - obj.dx) : min(obj.x + obj.dx, width);
%                 obj.im = image(y_sub, x_sub);
                
                [X, Y] = meshgrid(x_sub, y_sub);%c

    %             mx =  obj.x; %X(mode_y, mode_x);
    %             my = obj.y; %Y(mode_y, mode_x);
                 mx = sum(X(:).*obj.im(:))/sum(obj.im(:));
                my = sum(Y(:).*obj.im(:))/sum(obj.im(:));            

                %take the points within a circle of radius obj.r
                R = sqrt((Y - my).^2 + (X - mx).^2);
                im_inside_circle = obj.im(R <= obj.r);
                if sum(im_inside_circle) ~= 0
                    val = max(im_inside_circle)/sum(im_inside_circle);
                else
                    val = 0;
                end
                %obj.im(mode_y, mode_x) = 10;
%                 imagesc(obj.im);   
%                 drawnow();
            end
            toc
        end
    end
end