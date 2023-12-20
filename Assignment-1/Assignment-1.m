my_image = imread('square.bmp'); 
% my_image = imread('circle.bmp');
[rows, cols] = size(my_image); 
row = -1; 
col = -1; 

% Iterating over the image to find first non-zero pixel
for i = 1:rows 
    for j = 1:cols 
        if my_image(i,j) > 0 
            row = i; 
            col = j; 
            break; 
        end 
    end 
    if row ~= -1 
        break; 
    end 
end 

%(y,x)
neighbors = [
    0, -1; 
    1, -1;
    1, 0;
    1, 1;
    0, 1;
    -1, 1;
    -1, 0;
    -1, -1];

direction = 1;
boundary_cords = [];
currentPos = [col, row];


while true % For iterating through the complete image
    for i = 1:8 % For iterating through all the 8 neighbors. These neighbors are mentioned in the neighbors array.
        nextPos = currentPos + neighbors(direction, :);
        x = nextPos(1);
        y = nextPos(2);
        if x >= 1 && x <= cols && y >= 1 && y <= rows % Checking if the coordinates of the next position that we have calculated above falls within the image boundary
            if my_image(y, x) == 1 % check if the row and col of the next pos are a part of the foreground i.e white i.e a part of the boundary that we need to draw
                boundary_cords = [boundary_cords; x, y]; % Adding the next pos x and y basically the row and col to the boundary_cords array which we created above
                currentPos = nextPos; % Our current pos will now be updated to the next pos
                direction = mod(direction + 4 , 8) + 1; % This is done to cover all 8 possible neighbors clockwise.
                break;
            end
        end
        if direction == 8    %Condition to move to the next neighbour
            direction = 1;
        else
            direction = direction + 1;
        end
    end
    if isequal(currentPos, [col, row]) %Checking if it has returned back to where it started
        break;
    end
end

%This code was provided in the question pdf and I have copied it from there
imshow(my_image); 
hold on;

X = [];
Y = [];
for k = 1:length(boundary_cords)
    x = boundary_cords(k, 1);
    y = boundary_cords(k, 2);
    X = [X, x];
    Y = [Y, y];
end

plot(X, Y, 'g', 'LineWidth', 2);

hold off;
