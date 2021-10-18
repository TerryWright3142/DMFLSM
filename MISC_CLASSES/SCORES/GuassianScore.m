classdef  GuassianScore < Score 
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
       fwhm,
       px
    end
    
    methods 
        function obj = GuassianScore(x, y, dx, dy, fwhm, px)
            %check this syntax
            %hopefully it will be more than 3stddev from a boundary
            obj.x = x;
            obj.y = y;
            obj.dx = dx;
            obj.dy = dy;
            obj.centroid_x = 0;
            obj.centroid_y = 0;
            obj.fwhm = fwhm;
            obj.px = px;
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
            Y = Y - obj.centroid_y;
            X = X - obj.centroid_x;
            R2 = X.^2 + Y.^2;
            % the value of each pixel must be normalised otherwise and
            % image that is simply brighter will seem to have a better
            % score
            sig = (obj.fwhm/obj.px)/(2*sqrt(2*log(10)));
  
            pdf_gaussian = 1/sig*exp(-0.5*R2/sig^2);
            normsubimage = subimage.*pdf_gaussian/tot;
            val = -sum(normsubimage(:));
            obj.im = image((obj.y - ceil(obj.dy/2)):(obj.y + ceil(obj.dy/2)), ...
                (obj.x - ceil(obj.dx/2)):(obj.x + ceil(obj.dx/2)));
            %imagesc(obj.im);
            disp(strcat('score = ', string(val), ' centroid=', string(obj.centroid_x), ...
                ',', string(obj.centroid_y)));
             drawnow;
           
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