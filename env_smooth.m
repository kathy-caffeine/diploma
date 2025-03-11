function smooth_sig = env_smooth(sig, fs, ratio, dim)
    % Check if 'dim' is provided, if not, smooth all dimensions
    if nargin < 4
        dim = 1:size(sig, 1);
    end
    
    % Initialize the smoothed signal matrix with zeros
    smooth_sig = zeros(size(sig));
    
    % Process each specified dimension for smoothing
    for i = 1:length(dim)
        cur_dim = dim(i); % Current dimension being processed
        
        % Validate if cur_dim is within the signal dimensions
        if cur_dim > size(sig, 1) || cur_dim < 1
            error('Dimension index out of range.');
        end
        
        % Compute the mean envelope for the current dimension
        [envH, envL] = envelope(sig(cur_dim, :), round(fs/ratio), 'peak');
        envM = (envH + envL) ./ 2; % Mean envelope
        
        % Assign the smoothed envelope to the output
        smooth_sig(cur_dim, :) = envM;
    end
    
    % Assign unprocessed signal values for dimensions not in 'dim'
    all_dims = 1:size(sig, 1);
    untouched_dims = setdiff(all_dims, dim); % Dimensions not to be smoothed
    for i = untouched_dims
        smooth_sig(i, :) = sig(i, :);
    end
end
