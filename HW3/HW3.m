%% Part 1 - Track Paint Can
clear variables; close all; clc;

load('cam1_1.mat');
load('cam2_1.mat');
load('cam3_1.mat');

box_size = 40;
search_size = 40;

centers1 = trackPoint(vidFrames1_1, box_size, true);
centers2 = trackPoint(vidFrames2_1, box_size, true);
centers3 = trackPoint(vidFrames3_1, box_size, true);

save('centers1_1', 'centers1');
save('centers2_1', 'centers2');
save('centers3_1', 'centers3');

%% Part 2 - PCA
clear variables; close all; clc;

load('centers1_1.mat');
load('centers2_1.mat');
load('centers3_1.mat');

data = centers3(:, 2:-1:1); % camera is sideways
%data = centers2;
t = 1:226;
X = [t; normalize(double(data(t, 1)))'];
X(1, :) = X(1, :) - mean(X(1, :));
X(1, :) = X(1, :) * 25 / t(end);
%X(2, :) = X(2, :) - mean(X(2, :));

[U,S,V] = svd(X, 'econ');
n = size(V, 1);
y1 = S(1,1)/sqrt(n-1)*U(:,1);
y2 = S(2,2)/sqrt(n-1)*U(:,2);

X = U'*X;
y1 = U'*y1;
y2 = U'*y2;

plot(X(1, :), X(2, :), 'k.');
hold on;
c = compass(y1(1),y1(2));
c = compass(y2(1),y2(2));
axis equal;
xlabel('Time');
ylabel('X-Position');
title('Camera 3 Take 1 Principal Component Analysis');

saveas(gcf, 'centers3_1_x.jpg');