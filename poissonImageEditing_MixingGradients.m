function blended_image = poissonImageEditing_MixingGradients( source, target, source_mask, target_mask, offset )
% In this function we'll implement the mixing gradients poisson image
% editing algorithm.
% The code is almost the same of 'poissonImageEditing.m' but here we wwon't
% subtract the second order derivative to b. We will define a non-conservative
% guidance field v as a linear combination of source and destination gradient fields,
% meaning that at each point of Omega, we will keep the stronger of the variations
% so if we apply a mask in a non-smooth area we will preserve the
% non-smoothness.

    source = double(source);
    target = double(target);

    blended_image = target;
    [~, ~, channels] = size(source);
    [~, xCoordinatesTarget] = find(target_mask);
    
    n = length(xCoordinatesTarget);
    
    loc = target_mask(:);
    grid = zeros(size(target_mask));
    grid(loc) = 1:n;
    
    for channel = 1:channels
        [x, y] = find(grid);
        
        A = zeros(n,n);
        B = zeros(n,1);
        
        s = (source(:,:,channel));
        t = (target(:,:,channel));

        % we need to align the source and the target
        s = circshift(s,offset(1:2));
        
                 
        for i = 1:n %for every pixel in the mask 
            A(i, i) = 4;
            
            if target_mask(x(i)-1, y(i))  ~= 0 % if the pixel in the mask belongs to Omega
                A(i, grid(x(i)-1, y(i)) ) = -1; 
            else                               % if it doesn't add to B the target
                B(i) = target(x(i)-1, y(i),channel);
            end
            
            if target_mask(x(i)+1, y(i)) ~= 0
                A(i, grid(x(i)+1, y(i)) )  = -1;
            else
                B(i) = B(i) + target(x(i)+1, y(i),channel);
            end
            
            if target_mask(x(i), y(i)+1) ~= 0
                A(i, grid(x(i), y(i)+1) ) = -1;
            else
                B(i) = B(i) + target(x(i), y(i)+1,channel);
            end
            
            if target_mask(x(i), y(i)-1) ~= 0
                A(i, grid(x(i), y(i)-1) )  = -1;
            else
                B(i) = B(i) + target(x(i), y(i)-1,channel);
            end            
            
            % we just need to compute v as explained in the paper.
            % we have th .pdf file in the current directory.
            v = 0;
            center_p_1 = t(x(i), y(i)) ;
            center_p_2 = s(x(i), y(i)) ;
            
            %NORTH
            if magnitude(center_p_1 - t(x(i), y(i)+1)) > magnitude(center_p_2 - s(x(i), y(i)+1))
                v = v + center_p_1 - t(x(i), y(i)+1);
            else
                v = v + center_p_2 - s(x(i), y(i)+1);
            end
            %SOUTH
            if magnitude(center_p_1 - t(x(i), y(i)-1)) > magnitude(center_p_2 - s(x(i), y(i)-1))
                v = v + center_p_1 - t(x(i), y(i)-1);
            else
                v = v + center_p_2 - s(x(i), y(i)-1);
            end
            %OVEST
            if magnitude(center_p_1 - t(x(i)-1, y(i))) > magnitude(center_p_2 - s(x(i)-1, y(i)))
                v = v + center_p_1 - t(x(i)-1, y(i));
            else
                v = v + center_p_2 - s(x(i)-1, y(i));
            end
            %EAST
            if magnitude(center_p_1 - t(x(i)+1, y(i))) > magnitude(center_p_2 - s(x(i)+1, y(i)))
                v = v + center_p_1 - t(x(i)+1, y(i));
            else
                v = v + center_p_2 - s(x(i)+1, y(i));
            end
            
            B(i)= B(i) + v;
        end

        A = sparse(A);
        X=A\B;
        
        for index=1:length(X)
            [x,y] = find(grid==index);
            blended_image(x,y,channel)=X(index);
        end
    end
    blended_image = uint8(blended_image);
end