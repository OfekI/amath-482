%% Part 1
clear variables; close all; clc;

training_data = ["genesis", "land_of_confusion", "jesus_he_knows_me", "no_son_of_mine"; ...
    "katy_perry", "hot_n_cold", "i_kissed_a_girl", "teenage_dream"; ...
    "zac_brown_band", "chicken_fried", "toes", "whatever_it_is"];
titles = ["Genesis", "Land of Confusion", "Jesus He Knows Me", "No Son of Mine"; ...
    "Katy Perry", "Hot N Cold", "I Kissed a Girl", "Teenage Dream"; ...
    "Zac Brown Band", "Chicken Fried", "Toes", "Whatever it is"];
start_times = [2, 2, 10; 35, 2, 2; 24, 40, 2];
sampling_rate = 44100/3;
audio = zeros(3, 3, 5*sampling_rate + 1);
ffts = zeros(3, 3, 5*sampling_rate + 1);

n=5*sampling_rate;
k=(1/5)*[0:(n+1)/2 -(n+1)/2:-1];
ks=fftshift(k);

for i = 1:3
    for j = 1:3
        artist = training_data(i, 1);
        song = training_data(i, j + 1);
        audio(i, j, :) = read_audio(make_audio_path(1, artist, song), start_times(i, j), sampling_rate);
        ffts(i, j, :) = abs(fft(squeeze(audio(i, j, :))'));
        
        tslide = 0:0.1:5;
        S = squeeze(audio(i, j, :))';
        Sgt_spec = zeros(length(tslide), n+1);

        for k=1:length(tslide)
            g = exp(-20 .* ((1:n+1)/sampling_rate - tslide(k)) .^ 2);
            Sg = g .* S;
            Sgt = fft(Sg);
            Sgt_spec(k, :) = fftshift(abs(Sgt));
        end
        
        f = figure(j);
        pcolor(tslide, ks, Sgt_spec(:, :).');
        shading interp;
        set(gca,'Ylim',[0 2e3]);
        colormap(hot);
        xlabel('Time [sec]');
        ylabel('Frequency [Hz]');
        title(sprintf('%s - %s Spectrogram', titles(i, 1), titles(i, 1 + j)));
        saveas(f, sprintf('%s_%s_spectrogram.jpg', artist, song));
        close(f);
    end
end

X = [squeeze(ffts(1, :, :)); squeeze(ffts(2, :, :)); squeeze(ffts(3, :, :))];
[U,S,V] = svd(X, 'econ');

influences = zeros(9, 5*sampling_rate + 1);
for i = 1:9
    projection = S(i, i) * U(:, i) * V(:, i)';
    influences(i, :) = sign(U(:, i)'*projection) .* vecnorm(projection);
end

scores = zeros(3, 3, 9);
for i = 1:3
    for j = 1:3
        scores(i, j, :) = influences*squeeze(ffts(i, j, :));
    end
end

%% Test

test_data = ["day_that_i_die", "firework", "i_cant_dance"];
test_start_times = [2, 2, 35];
test_audio = [];
test_ffts = [];
test_scores = [];

for i = 1:size(test_data, 2)
    test_audio(i, :) = read_audio("test_data/part_1/" + test_data(i) + ".mp3", test_start_times(i), sampling_rate);
    test_ffts(i, :) = abs(fft(squeeze(test_audio(i, :))'));
    test_scores(i, :) = influences*squeeze(test_ffts(i, :))';
end

for k = 1:size(test_data, 2)
    min = 1e10;
    for i = 1:3
        for j = 1:3
            distance = sqrt(ones(1, 9)*(squeeze(test_scores(k, :)) - squeeze(scores(i, j, :))).^2);
            if distance < min
                min = distance;
                argmin = training_data(i, 1);
            end
        end
    end

    argmin
end

%% Part 2
clear variables; close all;

training_data = ["katy_perry", "hot_n_cold", "i_kissed_a_girl", "teenage_dream"; ...
    "kelly_clarkson", "piece_by_piece", "since_youve_been_gone", "stronger"; ...
    "pink", "true_love", "what_about_us", "who_knew"];
titles = ["Katy Perry", "Hot N Cold", "I Kissed a Girl", "Teenage Dream"; ...
    "Kelly Clarkson", "Piece by Piece", "Since You've Been Gone", "Stronger"; ...
    "P!nk", "True Love", "What About Us", "Who Knew"];
start_times = [35, 2, 2; 10, 2, 10; 10, 10, 10];
sampling_rate = 44100/3;
audio = zeros(3, 3, 5*sampling_rate + 1);
ffts = zeros(3, 3, 5*sampling_rate + 1);

n=5*sampling_rate;
k=(1/5)*[0:(n+1)/2 -(n+1)/2:-1];
ks=fftshift(k);

for i = 1:3
    for j = 1:3
        artist = training_data(i, 1);
        song = training_data(i, j + 1);
        audio(i, j, :) = read_audio(make_audio_path(2, artist, song), start_times(i, j), sampling_rate);
        ffts(i, j, :) = abs(fft(squeeze(audio(i, j, :))'));
        
        tslide = 0:0.1:5;
        S = squeeze(audio(i, j, :))';
        Sgt_spec = zeros(length(tslide), n+1);

        for k=1:length(tslide)
            g = exp(-20 .* ((1:n+1)/sampling_rate - tslide(k)) .^ 2);
            Sg = g .* S;
            Sgt = fft(Sg);
            Sgt_spec(k, :) = fftshift(abs(Sgt));
        end
        
        f = figure(j);
        pcolor(tslide, ks, Sgt_spec(:, :).');
        shading interp;
        set(gca,'Ylim',[0 2e3]);
        colormap(hot);
        xlabel('Time [sec]');
        ylabel('Frequency [Hz]');
        title(sprintf('%s - %s Spectrogram', titles(i, 1), titles(i, 1 + j)));
        saveas(f, sprintf('%s_%s_spectrogram.jpg', artist, song));
        close(f);
    end
end

X = [squeeze(ffts(1, :, :)); squeeze(ffts(2, :, :)); squeeze(ffts(3, :, :))];
[U,S,V] = svd(X, 'econ');

influences = zeros(9, 5*sampling_rate + 1);
for i = 1:9
    projection = S(i, i) * U(:, i) * V(:, i)';
    influences(i, :) = sign(U(:, i)'*projection) .* vecnorm(projection);
end

scores = zeros(3, 3, 9);
for i = 1:3
    for j = 1:3
        scores(i, j, :) = influences*squeeze(ffts(i, j, :));
    end
end

%% Test

test_data = ["firework", "just_like_fire", "my_life_would_suck_without_you"];
test_start_times = [2, 14, 2];
test_audio = [];
test_ffts = [];
test_scores = [];

for i = 1:size(test_data, 2)
    test_audio(i, :) = read_audio("test_data/part_2/" + test_data(i) + ".mp3", test_start_times(i), sampling_rate);
    test_ffts(i, :) = abs(fft(squeeze(test_audio(i, :))'));
    test_scores(i, :) = influences*squeeze(test_ffts(i, :))';
end

for k = 1:size(test_data, 2)
    min = 1e10;
    for i = 1:3
        for j = 1:3
            distance = sqrt(ones(1, 9)*(squeeze(test_scores(k, :)) - squeeze(scores(i, j, :))).^2);
            if distance < min
                min = distance;
                argmin = training_data(i,  1);
            end
        end
    end

    argmin
end
