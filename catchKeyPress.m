function [offset] = catchKeyPress(mask, targetImage)
    h = figure; 
    
    [x, y, ~] = size(mask);
    
    shift = [0 0 0];
    set(h,'KeyPressFcn',@KeyPressCb);
    p=1;
    while p
        imshow(targetImage.*repmat(uint8(mask),[1,1,3]));
    end
    offset = shift;
    close;
    
    function KeyPressCb(~,evnt)
        %fprintf('key pressed: %s\n',evnt.Key);
        if strcmpi(evnt.Key,'leftarrow')
            shift(2) = shift(2)-4;
            mask = circshift(mask,[0 -4]);
            %I = imread('./plate_side_3.jpg');
            offset = shift;
            imshow(targetImage.*repmat(uint8(mask),[1,1,3]));

        elseif strcmpi(evnt.Key,'rightarrow')
            shift(2) = shift(2)+4;
            mask = circshift(mask,[0 4]);
            offset = shift;
            imshow(targetImage.*repmat(uint8(mask),[1,1,3]));

        elseif strcmpi(evnt.Key,'uparrow')
            shift(1) = shift(1)-4;
            mask = circshift(mask,[-4 0]);
            %I = imread('./plate_side_3.jpg');
            offset = shift;
            imshow(targetImage.*repmat(uint8(mask),[1,1,3]));

        elseif strcmpi(evnt.Key,'downarrow')
            shift(1) = shift(1)+4;
            mask = circshift(mask,[4 0]);
            offset = shift;
            %I = imread('./plate_side_3.jpg');
            imshow(targetImage.*repmat(uint8(mask),[1,1,3]));
        elseif strcmpi(evnt.Key,'space')
            %close targetImage;
            p = 0;
        elseif strcmpi(evnt.Key,'u')
            %close targetImage;
            %upscale_x = x/2;
            %upscale_y = y/2;
            shift(3) = shift(3) +1;
            mask = imdilate(mask, true(11));
         elseif strcmpi(evnt.Key,'d')
            %close targetImage;
            mask = imdilate(mask, true(0.5));
        end
    end

 end
