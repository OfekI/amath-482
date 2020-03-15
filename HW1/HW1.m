%% Find center frequency
clear; close all; clc;
load Testdata

L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

Utave = zeros(1, n^3);
for j = 1:20
    Utave = Utave + fft(Undata(j, :));
end
Utave = Utave / 20;

isosurface(Kx, Ky, Kz, abs(reshape(fftshift(Utave),n,n,n)), 190);
axis([-20 20 -20 20 -20 20]), grid on;

[Utmax, Utmaxi] = max(abs(fftshift(Utave)));
center = [Kx(Utmaxi), Ky(Utmaxi), Kz(Utmaxi)];

%% Find marble trajectory
tau = 0.5;
filter = reshape(exp(-tau * ((Kx-center(1)).^2 ...
    + (Ky-center(2)).^2 ...
    + (Kz-center(3)).^2)),1,n^3);
f = @(j) filter .* fftshift(fft(Undata(j, :))); % apply filter

isosurface(X, Y, Z, abs(reshape(ifft(ifftshift(f(10))),n,n,n)), 0.1);
axis([-20 20 -20 20 -20 20]), grid on;

x = zeros(1, 20); y=x; z=x;

for i=1:20
    [m, idx] = max(abs(ifft(ifftshift(f(i)))));
    x(i) = X(idx); y(i) = Y(idx); z(i) = Z(idx);
end

plot3(x, y, z);
axis([-20 20 -20 20 -20 20]), grid on;

%% Find location of marble at t=20
[x(20), y(20), z(20)]