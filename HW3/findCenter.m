function [minPoint] = findCenter(X, tracking_box, point, box_size, search_size)
    min_error = (256*2*box_size)^2;
    
    min_x = max(box_size + 1, point(1) - search_size);
    max_x = min(size(X, 2) - box_size, point(1) + search_size);
    
    min_y = max(box_size + 1, point(2) - search_size);
    max_y = min(size(X, 1) - box_size, point(2) + search_size);
    
    for x = min_x:max_x
        for y = min_y:max_y
            a = X(y + int16(-box_size:box_size), x + int16(-box_size:box_size), :);
            error = (int16(tracking_box) - int16(a)).^2;
            tmp_error = sum(error, 'all');
            if tmp_error < min_error
                min_error = tmp_error;
                min_point = [x, y];
            end
        end
    end
    
    minPoint = min_point;
end