function [distr, image] = req_distr_from_image(file_name, distr_size, is_max_white)
    arguments
       file_name string = []
       distr_size double = []
       is_max_white = true
    end

    if (isempty(file_name))
        [f, p] = uigetfile({'*.*', 'Image files (*.*)'}, 'Import required image');
        file_name = [p f];
    end
    [I,~,alpha_channel] = imread(file_name);

    if ~isempty(distr_size)
        I = imresize(I,distr_size);
        
        if ~isempty(alpha_channel) && any(alpha_channel(:))
            alpha_channel = imresize(alpha_channel,distr_size);
        end
    end
    image = I;

    distr = mean(I,3);
    if ~is_max_white
        max_val = max(image(:));
        image = max_val - image;
    end

    if ~isempty(alpha_channel) && any(alpha_channel(:))
        distr_mask = alpha_channel > 0;
        distr(~distr_mask) = 0;
    end
    
    distr = distr / sum(distr(:));
end

