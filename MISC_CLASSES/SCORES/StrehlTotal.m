classdef  StrehlTotal < Score 
    properties  
       best_score;
       points;
       imVoron;
       background;
    end
    
    methods 
        function obj = StrehlTotal(im, background,  x1, y1, x2, y2, num)
            obj.background = background;
            m =  obj.FindMag(x1,y1,x2,y2,num);
            fprintf('mag = %d\n', m);
            pins = CPinholeAnalysis(0.55, 0.85, 35, 200, 0.1, 200, 0.1, 0.5, false);
            pins.SetSensor(6.5, 6.5, 0, 0);
            figure(2);
            pins.DrawSensor();
            inclusionRadius = 20;
            score = StrehlScore(inclusionRadius);
            obj.best_score = pins.ApplyStatistic(score);
            back_thresh = 1000;
            cluster_spacing = 40;
            im = double(im) - background;
            im(im<0) = 0;
            obj.points = obj.FindMeans(im, cluster_spacing, back_thresh);
            figure(1);
            plot(obj.points(:,2), obj.points(:,1), 'o');
            [height, width] = size(im);
            obj.imVoron = VoronoiFull(width, height, obj.points, inclusionRadius);
            figure(2);
            imagesc(5*obj.imVoron + im);
        end
        function val = FindScore(obj, image)
            im = double(image) - obj.background;
            im(im<0) = 0;
            [imStat, imm, stats] = obj.VoronoiApplyStatistic(im, obj.points, obj.imVoron);
            val = sum(double(stats(:,1))/obj.best_score);
         

        end
        function DrawImage(obj)

        end
        function im_out = VoronoiFull(obj, width, height, points, r0)
            im_out =  zeros(height, width);
            for y = 1:height
                for x = 1:width
                    % for each pixel
                    rr = 1e10;
                    kmin = 0;
                    for k =1:size(points, 1)
                        r2 = (x - points(k, 2))^2 + (y - points(k,1))^2;
                        if r2 < rr
                            rr = r2;
                            kmin = k;
                        end     
                    end
                    if rr < r0^2
                        im_out(y, x) = kmin;
                    else
                        im_out(y,x) = -kmin;
                    end
                end
            end
        end
        function [ret, im_out] = FindMeans(obj, im, cluster_spacing, brightness_thresh)
            [height, width] = size(im);
            im_out = zeros(size(im));
            means = [1 1]; %[22.0 111.0; 67 28; 118 108]; %means arranged as a matrix - each row is a cluster mean
            mean_N = double(im(1,1));
            for y=1:height
                for x = 1:width
                if im(y,x) < brightness_thresh
                    continue;
                end
               bFound = false;
               k_found = -1;
               for k = max(1, (numel(mean_N) - 30)) : numel(mean_N)
                   r = sqrt( sum( (means(k, :)- [y, x]).^2 )); 
                   if r < cluster_spacing
                       %find the first cluster that it is sufficiently close to
                       means(k, :) = (means(k, :)*mean_N(k) + double(im(y, x))*[y, x])/(mean_N(k)+double(im(y,x)));
                       mean_N(k) = mean_N(k) + double(im(y,x));
                       %update the kth mean
                       k_found = k;
                       bFound = true;
                       break;
                   end         
               end
               if ~bFound
                    %if a cluster was not found that was sufficiently close
                    means = [means; y x];
                    %update the total
                    mean_N = [mean_N, double(im(y,x))];
                    k_found = numel(mean_N);
               end 
               im_out(y, x) = k_found;

                end
            end
            ret = means;
        end
        function [im_out1, im_out2, stats] = VoronoiApplyStatistic(obj, im, points, voron)
            stats = zeros(size(points, 1), 5);
            [height, width] = size(im);
            for y = 1:height
                for x = 1:width
                    if voron(y, x) > 0
                        % update the total
                        stats(voron(y,x), 2) = im(y, x) + stats(voron(y,x),2);
                        % find the maximum
                        if im(y,x) > stats(voron(y,x),3)
                            stats(voron(y,x),3) = im(y,x);
                        end
                        stats(voron(y,x),4) = stats(voron(y,x),4) + x*im(y,x);
                        stats(voron(y,x),5) = stats(voron(y,x),5) + y*im(y,x);
                    end

                end
            end
            for k = 1:size(points,1)
                stats(k,4) = stats(k,4)/stats(k,2);
                stats(k,5) = stats(k,5)/stats(k,2);
            end
            for k = 1:size(points,1)
                %fprintf('%d %d %d \n', round(stats(k,5)), round(stats(k,4)), stats(k,2));

                if stats(k,2)>0
                    stats(k,1) = im(round(stats(k,5)), round(stats(k,4)))/stats(k,2);
                else
                    stats(k,1) = 0;
                end
            end
            %stats(:,1)= stats(:,3)./stats(:,2);
            im_out1 = zeros(height, width);
            for y = 1:height
                for x = 1:width
                    im_out1(y,x) = stats(abs(voron(y,x)),1);


                end
            end
            im_out2 = zeros(height, width);
            for y = 1:height
                for x = 1:width
                    im_out2(y,x) = stats(abs(voron(y,x)),2);


                end
            end
        end
        function mag = FindMag(obj, x1,y1,x2,y2,num)
            r = sqrt( (x2-x1)^2 + (y2-y1)^2);
            r = r*6.5/num;
            mag = r/20;
        end
    end
end