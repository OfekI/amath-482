function [y, Fs] = read_audio(path, secondsOffset, sampling_rate)
    [y, Fs] = audioread(path);
    y = resample(y, sampling_rate, Fs);
    Fs = sampling_rate;
    length = 5 * Fs;
    start = secondsOffset * Fs;
    y = y(start:start+length);
end