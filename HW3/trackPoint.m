function [centers] = trackPoint(data, box_size, showBox)
    search_size = box_size;
    numFrames = size(data,4);

    imshow(data(:, :, :, 1));
    point = int16(ginput(1));
    close all;

    y = point(2) + int16(-box_size:box_size);
    x = point(1) + int16(-box_size:box_size);
    tracking_box = data(y, x, :, 1);

    centers = [point];

    for j = 2:numFrames
        X = (data(:,:,:,j));

        % find new center

        point = findCenter(X, tracking_box, point, box_size, search_size);
        centers = [centers; point];

        if showBox
            % draw green box
            for x = (point(1) + int16(-box_size:box_size))
                for y = (point(2) + int16([-box_size, box_size]))
                    X(y, x, 1) = 0;
                    X(y, x, 2) = 255;
                    X(y, x, 3) = 0;
                end
            end
            for y = point(2) + int16(-box_size:box_size)
                for x = point(1) + int16([-box_size, box_size])
                    X(y, x, 1) = 0;
                    X(y, x, 2) = 255;
                    X(y, x, 3) = 0;
                end
            end

            tracking_box = X(point(2) + int16(-box_size:box_size), ...
                point(1) + int16(-box_size:box_size), :);

            imshow(X);
            drawnow
        end
    end
end