function data = moving_average(abs, window)

window_half = (window - 1)/2;
[m, n] = size(abs);
data = zeros(m, n);

for i = 1:m
    for j = 1:n
        if (j <= window_half)
            pts = zeros(1, window_half + j);
            pts(1, 1:end) = abs(i, 1:(j + window_half));
            data(i, j) = mean(pts(1, :));
        elseif (n - j <= window_half - 1)
            pts = zeros(1, window_half + n - j + 1);
            pts(1, 1:end) = abs(i, (j - window_half):end);
            data(i, j) = mean(pts(1, :));
        else
            data(i, j) = mean(abs(i, (j - window_half):(j + window_half)));
        end
    end
end
end