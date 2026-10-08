% ==========================================
% GAME OF DRONES
% File: GameOfDrones_VF.m
% ==========================================
%
% AUTHORS AND CONTRIBUTION:
%   GOLUBEVA Elizaveta
%   RASOLO Miangola
%   Equal contribution of the two authors.
%
% DATE: October 8th 2026
%   (format: Month Day Year)
%
% SOURCES:
%   No external image, sound or word list is used.
%   All graphics are drawn with Octave commands (plot, text, rectangle).
%   AI used: ChatGPT and Claude were used for improvement and
%   correction of the game code.
%
% VERSIONS:
%   Octave version: 11.3.0
%   Game version  : 1.3
%
%
% CONTEXT OF THE GAME:
%   A small arcade game made for a programming course in Octave.
%   It is inspired by classic "shoot'em up" games.
%
% DESCRIPTION:
%   You control a drone (cyan triangle) at the bottom of the screen.
%   Red enemies fall from the top of the screen.
%
% GOAL:
%   Shoot down 15 enemies to win and place the drone on the throne.
%
% GAME COMPONENTS:
%   - the drone (controlled by the player)
%   - bullets (shot by the drone)
%   - enemies (fall from the top of the screen)
%   - a score counter and a lives counter
%   - a start page with the rules and the controls
%   - buttons: START GAME, STOP GAME and REPLAY
%   - a win screen (the throne) and a game over screen
%
% RULES:
%   - You start with 3 lives.
%   - If an enemy reaches the bottom and touches the drone,
%     you lose one life.
%   - If you lose all 3 lives, the game is over.
%   - Each enemy hit by a bullet gives +1 point.
%   - When you reach 15 points, you win.
%
% CONTROLS (WAYS TO MOVE):
%   Left arrow  (or Q)  - move the drone left
%   Right arrow (or D)  - move the drone right
%   Down arrow          - stop the drone
%   Space               - shoot
%   (the drone keeps moving in the chosen direction until you
%    press the opposite direction or the stop key)
%   Click on the game window first so that it receives the keys.
%
% MAIN VARIABLES:
%   droneX, droneY       position of the drone
%   bulletsX, bulletsY   positions of the bullets
%   enemiesX, enemiesY   positions of the enemies
%   score                number of enemies defeated
%   lives                number of remaining lives
%   winningScore         score needed to win (15)
%   moveLeft, moveRight  direction chosen with the keyboard
%
% MAIN LOOP (repeated every 0.03 seconds while the window is open):
%   1. move the drone according to the keyboard
%   2. create a new enemy at random (4 % chance per loop)
%   3. move the enemies down and the bullets up
%   4. draw the bullets and the enemies
%   5. bullet / enemy collisions: the enemy disappears, +1 score
%   6. enemy / drone collisions: the enemy disappears, -1 life
%   7. update the score and lives displayed
%   8. test the lose condition (0 lives) and the win condition
%      (15 points)
%   9. drawnow and pause(0.03) to control the speed of the game
%
% ACROSS TRIALS (between games):
%   At the end of a game (win or game over), the REPLAY button starts
%   a new game: the score and the lives are reset, and the enemies
%   appear at new random positions, so each game is different.
%   The STOP GAME button closes the game window.
%
% ==========================================


function GameOfDrones_VF()
% Defines the main function called GameOfDrones.
% The whole game is contained inside this function.


    % ==========================================
    % GAME OF DRONES
    % ==========================================

    close all;
    % Closes all open MATLAB figure windows.
    % This ensures that we start with a clean screen.


    % ==========================================
    % STARTING PAGE
    % ==========================================

    startFig = figure( ...
        'Name', 'Game of Drones - Start', ...
        'Color', 'black', ...
        'MenuBar', 'none', ...
        'NumberTitle', 'off');
    % Creates the starting page of the game.
    %
    % 'Color' makes the background black.
    % 'MenuBar', 'none' removes the standard MATLAB menu bar.
    % 'NumberTitle', 'off' removes the default figure number.

    axis([0 100 0 100]);
    % Defines the coordinate system used by the start page.

    axis off;
    % Hides the axes because this is a menu screen.

    hold on;
    % Allows several text objects to be displayed together.

    text(50, 91, 'GAME OF DRONES', ...
        'Color', 'cyan', ...
        'FontSize', 28, ...
        'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center');
    % Displays the game title.

    text(50, 80, 'RULES', ...
        'Color', 'yellow', ...
        'FontSize', 20, ...
        'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center');
    % Displays the Rules heading.

    text(50, 71, 'Shoot down 15 enemies to win.', ...
        'Color', 'white', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'center');
    % Explains the winning condition.

    text(50, 64, 'You start with 3 lives.', ...
        'Color', 'white', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'center');
    % Explains the starting number of lives.

    text(50, 57, 'An enemy reaching the drone costs 1 life.', ...
        'Color', 'white', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'center');
    % Explains how the player loses a life.

    text(50, 50, 'Lose all 3 lives = GAME OVER.', ...
        'Color', 'white', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'center');
    % Explains the losing condition.

    text(50, 39, 'CONTROLS', ...
        'Color', 'yellow', ...
        'FontSize', 20, ...
        'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center');
    % Displays the Controls heading.

    text(50, 31, 'LEFT ARROW or Q  -  Move left', ...
        'Color', 'white', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'center');
    % Displays the command for moving left.

    text(50, 25, 'RIGHT ARROW or D  -  Move right', ...
        'Color', 'white', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'center');
    % Displays the command for moving right.

    text(50, 19, 'DOWN ARROW  -  Stop the drone', ...
        'Color', 'white', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'center');
    % Displays the command for stopping the drone.

    text(50, 13, 'SPACE  -  Shoot', ...
        'Color', 'white', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'center');
    % Displays the command for shooting.

    uicontrol(startFig, ...
        'Style', 'pushbutton', ...
        'String', 'START GAME', ...
        'FontSize', 14, ...
        'FontWeight', 'bold', ...
        'Units', 'normalized', ...
        'Position', [0.40 0.025 0.20 0.07], ...
        'Callback', @startGame);
    % Creates the START GAME button.
    %
    % When the player clicks the button, the startGame
    % function is called.

    drawnow;
    % Forces MATLAB to display the starting page immediately.

    uiwait(startFig);
    % Pauses the game until the player clicks START GAME.


    % ==========================================
    % CREATE GAME WINDOW
    % ==========================================

    % Create game window
    fig = figure( ...
        'Name', 'Game of Drones', ...
        'Color', 'black', ...
        'KeyPressFcn', @keyPressed);
    % Creates a new MATLAB figure window.
    %
    % 'Name' sets the name displayed at the top of the window.
    % 'Color', 'black' makes the background black.
    % 'KeyPressFcn' tells MATLAB what function to call
    % whenever the user presses a keyboard key.
    %
    % @keyPressed means that MATLAB will call the function
    % called "keyPressed" when a key is pressed.
    %
    % "fig" stores the figure window in a variable so that
    % we can refer to it later.


    axis([0 100 0 100]);
    % Defines the coordinate system of the game.
    %
    % X-axis goes from 0 to 100.
    % Y-axis goes from 0 to 100.


    axis manual;
    % Prevents MATLAB from automatically changing the axis limits.


    axis off;
    % Hides the X-axis and Y-axis from the player.


    hold on;
    % Allows multiple graphical objects to be displayed
    % simultaneously in the same figure.


    % ------------------------------------------
    % Drone
    % ------------------------------------------

    droneX = 50;
    % Stores the initial horizontal position of the drone.
    % The drone starts in the middle of the screen.


    droneY = 10;
    % Stores the initial vertical position of the drone.
    % The drone starts near the bottom.


    drone = plot(droneX, droneY, '^', ...
        'MarkerSize', 18, ...
        'MarkerFaceColor', 'cyan', ...
        'MarkerEdgeColor', 'white');
    % Draws the drone on the screen.
    %
    % droneX and droneY determine its position.
    % '^' creates a triangle-shaped marker.
    % 'MarkerSize' controls the size of the drone.
    % 'MarkerFaceColor' sets the inside color.
    % 'MarkerEdgeColor' sets the outline color.
    %
    % "drone" stores the graphical object so that its
    % position can be updated later.


    % Drone movement
    moveLeft = false;
    % Creates a logical variable.
    % false means that the drone is not currently moving left.


    moveRight = false;
    % Creates another logical variable.
    % false means that the drone is not currently moving right.


    % ------------------------------------------
    % Bullets
    % ------------------------------------------

    bulletsX = [];
    % Creates an empty array to store the X positions of bullets.
    %
    % [] means that the array is initially empty.


    bulletsY = [];
    % Creates an empty array to store the Y positions of bullets.


    % ------------------------------------------
    % Enemies
    % ------------------------------------------

    enemiesX = [];
    % Creates an empty array to store the X positions of enemies.


    enemiesY = [];
    % Creates an empty array to store the Y positions of enemies.


    % Number of enemies defeated
    score = 0;
    % The player starts with zero defeated enemies.


    % Lives
    lives = 3;
    % The player starts with three lives.


    % Number needed to win
    winningScore = 15;
    % The player wins after defeating 15 enemies.


    % Text displaying score
    scoreText = text(2, 95, ...
        ['Score: ' num2str(score)], ...
        'Color', 'white', ...
        'FontSize', 14);
    % Creates text showing the current score.
    %
    % (2,95) determines the position of the text.
    %
    % num2str(score) converts the numerical score into text.
    %
    % ['Score: ' num2str(score)] combines the words
    % "Score: " with the current score.


    lifeText = text(75, 95, ...
        ['Lives: ' num2str(lives)], ...
        'Color', 'white', ...
        'FontSize', 14);
    % Creates text showing the number of remaining lives.
    %
    % It is placed near the upper-right corner.

    % ------------------------------------------
    % Stop button
    % ------------------------------------------

    uicontrol(fig, ...
        'Style', 'pushbutton', ...
        'String', 'STOP GAME', ...
        'FontSize', 12, ...
        'FontWeight', 'bold', ...
        'Units', 'normalized', ...
        'Position', [0.40 0.92 0.20 0.05], ...
        'Callback', @stopGame);
    % Creates a STOP GAME button during gameplay.


    % ------------------------------------------
    % Main game loop
    % ------------------------------------------

    while ishandle(fig)
    % Starts the main game loop.
    %
    % ishandle(fig) checks whether the game window still exists.
    %
    % As long as the window is open, the game continues running.


        % Move drone
        if moveLeft
        % Checks whether moveLeft is true.


            droneX = droneX - 2;
            % Moves the drone 2 units to the left.

        end
        % Ends the move-left condition.


        if moveRight
        % Checks whether moveRight is true.


            droneX = droneX + 2;
            % Moves the drone 2 units to the right.

        end
        % Ends the move-right condition.


        % Keep drone inside screen
        droneX = max(5, min(95, droneX));
        % Prevents the drone from leaving the screen.
        %
        % min(95, droneX) prevents X from becoming larger than 95.
        %
        % max(5, ...) prevents X from becoming smaller than 5.
        %
        % Therefore:
        % 5 <= droneX <= 95.


        set(drone, 'XData', droneX, ...
                   'YData', droneY);
        % Updates the graphical position of the drone.
        %
        % XData changes the horizontal position.
        % YData changes the vertical position.


        % --------------------------------------
        % Create enemies randomly
        % --------------------------------------

        if rand < 0.04
        % rand generates a random number between 0 and 1.
        %
        % There is approximately a 4% chance that this condition
        % will be true during each game-loop iteration.


            enemiesX(end+1) = randi([5 95]);
            % Creates a new enemy.
            %
            % randi([5 95]) generates a random horizontal position
            % between 5 and 95.
            %
            % end+1 adds the new position to the end of enemiesX.


            enemiesY(end+1) = 95;
            % Places the new enemy near the top of the screen.
            %
            % The enemy starts at Y = 95.

        end
        % Ends the random enemy creation condition.


        % --------------------------------------
        % Move enemies
        % --------------------------------------

        enemiesY = enemiesY - 0.8;
        % Moves every enemy downward by 0.8 units.
        %
        % Since Y becomes smaller, enemies move toward the bottom.


        % --------------------------------------
        % Move bullets
        % --------------------------------------

        bulletsY = bulletsY + 3;
        % Moves every bullet upward by 3 units.
        %
        % Since Y becomes larger, bullets move upward.


        % --------------------------------------
        % Draw bullets
        % --------------------------------------

        delete(findobj(fig, 'Tag', 'bullet'));
        % Finds all graphical objects with the tag "bullet"
        % and deletes them.
        %
        % This prevents old bullet graphics from remaining
        % on the screen.


        for i = 1:length(bulletsX)
        % Loops through every bullet currently stored.


            plot(bulletsX(i), bulletsY(i), 'o', ...
                'Color', 'yellow', ...
                'MarkerFaceColor', 'yellow', ...
                'Tag', 'bullet');
            % Draws one bullet.
            %
            % bulletsX(i) gives its X position.
            % bulletsY(i) gives its Y position.
            % 'o' makes it circular.
            % The bullet is yellow.
            % 'Tag', 'bullet' allows us to find and delete
            % these objects later.

        end
        % Ends the bullet drawing loop.


        % --------------------------------------
        % Draw enemies
        % --------------------------------------

        delete(findobj(fig, 'Tag', 'enemy'));
        % Finds all graphical objects tagged "enemy"
        % and deletes them.
        %
        % They will then be redrawn at their new positions.


        for i = 1:length(enemiesX)
        % Loops through every enemy.


            plot(enemiesX(i), enemiesY(i), 'o', ...
                'Color', 'red', ...
                'MarkerFaceColor', 'red', ...
                'MarkerSize', 10, ...
                'Tag', 'enemy');
            % Draws an enemy as a red circle.
            %
            % enemiesX(i) = horizontal position.
            % enemiesY(i) = vertical position.
            % MarkerSize controls its size.
            % Tag "enemy" allows us to find these objects later.

        end
        % Ends the enemy drawing loop.


        % --------------------------------------
        % Bullet vs enemy collision
        % --------------------------------------

        bulletsToDelete = [];
        % Creates an empty list.
        % This will contain the bullets that hit enemies.


        enemiesToDelete = [];
        % Creates an empty list.
        % This will contain the enemies that were hit.


        for i = 1:length(bulletsX)
        % Goes through every bullet.


            for j = 1:length(enemiesX)
            % For each bullet, check it against every enemy.


                distance = sqrt( ...
                    (bulletsX(i) - enemiesX(j))^2 + ...
                    (bulletsY(i) - enemiesY(j))^2);
                % Calculates the distance between the bullet
                % and the enemy.
                %
                % This uses the distance formula:
                %
                % distance = sqrt((x1-x2)^2 + (y1-y2)^2)


                if distance < 5
                % If the distance is less than 5,
                % the bullet and enemy are considered to have collided.


                    bulletsToDelete(end+1) = i;
                    % Stores the index of the bullet that collided.


                    enemiesToDelete(end+1) = j;
                    % Stores the index of the enemy that was hit.


                    score = score + 1;
                    % Increases the score by one.


                    break;
                    % Stops checking other enemies for this bullet.
                    %
                    % This prevents the same bullet from hitting
                    % multiple enemies during this iteration.

                end
                % Ends the collision condition.

            end
            % Ends the enemy loop.

        end
        % Ends the bullet loop.


        % Remove destroyed enemies
        if ~isempty(enemiesToDelete)
        % Checks whether there are any enemies that need to be removed.
        %
        % "~" means NOT.
        % isempty checks whether the array is empty.


            enemiesToDelete = unique(enemiesToDelete);
            % Removes duplicate indices.
            %
            % This prevents trying to delete the same enemy twice.


            enemiesX(enemiesToDelete) = [];
            % Removes the destroyed enemies from their X positions.


            enemiesY(enemiesToDelete) = [];
            % Removes the destroyed enemies from their Y positions.

        end
        % Ends the enemy deletion condition.


        % Remove bullets
        if ~isempty(bulletsToDelete)
        % Checks whether any bullets need to be removed.


            bulletsToDelete = unique(bulletsToDelete);
            % Removes duplicate bullet indices.


            bulletsX(bulletsToDelete) = [];
            % Removes the destroyed bullets from their X positions.


            bulletsY(bulletsToDelete) = [];
            % Removes the destroyed bullets from their Y positions.

        end
        % Ends the bullet deletion condition.


        % --------------------------------------
        % Enemy reaches drone
        % --------------------------------------

        enemiesToDelete = [];
        % Creates an empty array for enemies that hit the drone.


        for i = 1:length(enemiesX)
        % Checks every enemy.


            if enemiesY(i) < 8
            % Checks whether the enemy has reached the bottom
            % of the screen, close to the drone.


                distance = abs(enemiesX(i) - droneX);
                % Calculates the horizontal distance between
                % the enemy and the drone.
                %
                % abs() gives the absolute value,
                % so we don't care whether the enemy is
                % to the left or right.


                if distance < 7
                % If the enemy is close enough horizontally,
                % it is considered to have hit the drone.


                    lives = lives - 1;
                    % Removes one life from the player.


                    enemiesToDelete(end+1) = i;
                    % Stores the enemy so it can be removed.

                end
                % Ends the distance condition.

            end
            % Ends the Y-position condition.

        end
        % Ends the enemy loop.


        if ~isempty(enemiesToDelete)
        % Checks whether there are enemies that hit the drone.


            enemiesToDelete = unique(enemiesToDelete);
            % Removes duplicate indices.


            enemiesX(enemiesToDelete) = [];
            % Removes those enemies from their X-position array.


            enemiesY(enemiesToDelete) = [];
            % Removes those enemies from their Y-position array.

        end
        % Ends the deletion condition.


        % --------------------------------------
        % Update score and lives
        % --------------------------------------

        set(scoreText, ...
            'String', ['Score: ' num2str(score)]);
        % Updates the score displayed on the screen.
        %
        % set() changes a property of an existing graphical object.
        % Here we change its displayed String.


        set(lifeText, ...
            'String', ['Lives: ' num2str(lives)]);
        % Updates the number of lives displayed on the screen.


        % --------------------------------------
        % Lose condition
        % --------------------------------------

        if lives <= 0
        % Checks whether the player has no lives remaining.


            cla;
            % Clears everything from the current figure.


            text(50, 55, 'GAME OVER', ...
                'Color', 'red', ...
                'FontSize', 30, ...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center');
            % Displays "GAME OVER" in the center of the screen.


            text(50, 40, ...
                ['Final Score: ' num2str(score)], ...
                'Color', 'white', ...
                'FontSize', 18, ...
                'HorizontalAlignment', 'center');
            % Displays the final score.


            % --------------------------------------
            % Replay button
            % --------------------------------------

            uicontrol(fig, ...
                'Style', 'pushbutton', ...
                'String', 'REPLAY', ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'Units', 'normalized', ...
                'Position', [0.4 0.20 0.2 0.08], ...
                'Callback', @restartGame);
            % Creates a Replay button on the Game Over screen.
            %
            % 'Style', 'pushbutton' creates a clickable button.
            % 'String', 'REPLAY' sets the text displayed on the button.
            % 'FontSize' controls the size of the button text.
            % 'FontWeight', 'bold' makes the button text bold.
            % 'Units', 'normalized' makes the position relative to the figure size.
            % 'Position' controls the button's location and size.
            % 'Callback', @replayGame tells MATLAB to run replayGame
            % when the player clicks the button.


            uicontrol(fig, ...
                'Style', 'pushbutton', ...
                'String', 'STOP GAME', ...
                'FontSize', 14, ...
                'FontWeight', 'bold', ...
                'Units', 'normalized', ...
                'Position', [0.4 0.10 0.2 0.08], ...
                'Callback', @stopGame);
            % Creates a STOP GAME button on the Game Over screen.

            break;
            % Stops the main game loop.
            % The game is finished.

        end
        % Ends the lose condition.


        % --------------------------------------
        % WIN CONDITION
        % --------------------------------------

        if score >= winningScore
        % Checks whether the player has defeated enough enemies
        % to win the game.


            showThrone(droneX);
            % Calls the showThrone function.
            %
            % This displays the winning screen.
            %
            % droneX is passed to the function, although in the
            % current version it is not actually used there.


            break;
            % Stops the main game loop because the player won.

        end
        % Ends the win condition.


        drawnow;
        % Forces MATLAB to immediately update the graphics.
        %
        % Without drawnow, the game graphics may not refresh properly.


        pause(0.03);
        % Pauses for 0.03 seconds.
        %
        % This controls the speed of the game loop.
        % A smaller number generally makes the game run faster.

    end
    % Ends the main while loop.

    % ==========================================
    % KEYBOARD CONTROL
    % ==========================================

    function keyPressed(~, event)

        key = lower(event.Key);
        % Name of the pressed key in lowercase.

        code = 0;
        if ~isempty(event.Character)
            code = double(event.Character(1));
        end
        % ASCII code of the character. Arrow keys give:
        % 28 = left, 29 = right, 30 = up, 31 = down.

        % disp(['Key: ' key ', code: ' num2str(code)]);
        % Uncomment the line above to see what your keyboard sends.

        isLeft  = any(strcmp(key, {'q', 'leftarrow',  'left'}))  || code == 28;
        isRight = any(strcmp(key, {'d', 'rightarrow', 'right'})) || code == 29;
        isStop  = any(strcmp(key, {'downarrow', 'down'}))        || code == 31;
        isShoot = strcmp(key, 'space');

        if isLeft
            moveLeft = true;
            moveRight = false;
        elseif isRight
            moveRight = true;
            moveLeft = false;
        elseif isStop
            moveLeft = false;
            moveRight = false;
        elseif isShoot
            bulletsX(end+1) = droneX;
            bulletsY(end+1) = droneY + 5;
        end

    endfunction
    % Ends the keyPressed function.

    % ==========================================
    % STOP GAME FUNCTION
    % ==========================================

    function stopGame(~, ~)
        % This function closes the current game window.
        % It works from gameplay, Game Over, and Win screens.
        if ishandle(fig)
            close(fig);
        end
    endfunction


    % ==========================================
    % START GAME FUNCTION
    % ==========================================

    function startGame(~, ~)
        % This function is called when the player clicks
        % the START GAME button.

        uiresume(startFig);
        % Allows the main GameOfDrones function to continue.

        close(startFig);
        % Closes the starting page before the game begins.

    endfunction
    % Ends the startGame function.


    % ==========================================
    % WIN SCREEN
    % ==========================================

    function showThrone(x)
    % Defines a function called showThrone.
    %
    % This function creates the screen displayed when the
    % player wins.
    %
    % "x" is an input argument containing the drone's X position.
    % It is not actually used inside this function.


        cla;
        % Clears the previous game screen.


        axis([0 100 0 100]);
        % Sets the coordinate system for the winning screen.


        axis off;
        % Hides the axes.


        hold on;
        % Allows multiple graphical objects to be drawn together.


        % Background
        set(fig, 'Color', [0.05 0.02 0.12]);
        % Changes the background color of the window
        % to a dark purple-like color.


        % Title
        text(50, 90, 'GAME OF DRONES', ...
            'Color', [1 0.85 0.1], ...
            'FontSize', 28, ...
            'FontWeight', 'bold', ...
            'HorizontalAlignment', 'center');
        % Displays the game title at the top of the winning screen.


        text(50, 78, 'YOU WIN!', ...
            'Color', 'cyan', ...
            'FontSize', 25, ...
            'FontWeight', 'bold', ...
            'HorizontalAlignment', 'center');
        % Displays "YOU WIN!" below the title.


        % --------------------------------------
        % Throne
        % --------------------------------------

        % Throne back
        rectangle( ...
            'Position', [35 25 30 40], ...
            'FaceColor', [0 0.3 1], ...
            'EdgeColor', [1 0.8 0.1], ...
            'LineWidth', 3);
        % Creates the large rectangular back of the throne.
        %
        % Position format:
        % [X Y Width Height]


        % Throne seat
        rectangle( ...
            'Position', [30 20 40 10], ...
            'FaceColor', [1 0 0], ...
            'EdgeColor', [1 0.8 0.1], ...
            'LineWidth', 3);
        % Creates the seat of the throne.


        % Throne arms
        rectangle( ...
            'Position', [28 25 7 20], ...
            'FaceColor', [1, 1, 1], ...
            'EdgeColor', [1 0.8 0.1], ...
            'LineWidth', 2);
        % Creates the left armrest of the throne.


        rectangle( ...
            'Position', [65 25 7 20], ...
            'FaceColor', [1, 1, 1], ...
            'EdgeColor', [1 0.8 0.1], ...
            'LineWidth', 2);
        % Creates the right armrest of the throne.


        % --------------------------------------
        % Winning drone
        % --------------------------------------

        plot(50, 55, '^', ...
            'MarkerSize', 25, ...
            'MarkerFaceColor', 'cyan', ...
            'MarkerEdgeColor', 'white');
        % Draws the winning drone sitting on the throne.


        % Drone rotors
        plot([42 58], [59 59], ...
            'Color', 'white', ...
            'LineWidth', 4);
        % Draws the horizontal arms connecting the two rotors.


        plot(42, 59, 'o', ...
            'MarkerSize', 7, ...
            'MarkerFaceColor', 'yellow');
        % Draws the left rotor.


        plot(58, 59, 'o', ...
            'MarkerSize', 7, ...
            'MarkerFaceColor', 'yellow');
        % Draws the right rotor.


        % Crown above drone
        plot([45 50 55], [70 70 70], ...
            'Color', [1 0.8 0], ...
            'LineWidth', 3);
        % Draws the crown above the drone.


        text(50, 12, ...
            ['Enemies defeated: ' num2str(score)], ...
            'Color', 'white', ...
            'FontSize', 16, ...
            'HorizontalAlignment', 'center');
        % Displays the final number of defeated enemies.


        % --------------------------------------
        % Replay button
        % --------------------------------------

        uicontrol(fig, ...
            'Style', 'pushbutton', ...
            'String', 'REPLAY', ...
            'FontSize', 14, ...
            'FontWeight', 'bold', ...
            'Units', 'normalized', ...
            'Position', [0.4 0.03 0.2 0.08], ...
            'Callback', @restartGame);
        % Creates a Replay button on the winning screen.
        %
        % The button calls restartGame when it is clicked.
        % restartGame is defined outside GameOfDrones so it remains
        % available after the game ends with a win or loss.

        uicontrol(fig, ...
            'Style', 'pushbutton', ...
            'String', 'STOP GAME', ...
            'FontSize', 14, ...
            'FontWeight', 'bold', ...
            'Units', 'normalized', ...
            'Position', [0.4 0.13 0.2 0.08], ...
            'Callback', @stopGame);
        % Creates a STOP GAME button on the winning screen.


        drawnow;
        % Forces MATLAB to immediately display the winning screen.

    endfunction
    % Ends the showThrone function.


endfunction
% Ends the main GameOfDrones function.

% ==========================================
% RESTART GAME FUNCTION
% ==========================================

function restartGame(~, ~)
% This function is outside GameOfDrones on purpose.
% It can still be used by the REPLAY button after the
% main GameOfDrones function has finished with a win or loss.

    % Start a completely new game.
    % GameOfDrones begins with 'close all', which closes the
    % old Game of Drones window before creating the new one.
    GameOfDrones_VF();

endfunction
% Ends the restartGame function.
