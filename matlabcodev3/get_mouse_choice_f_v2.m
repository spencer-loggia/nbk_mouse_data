% print the vertical nose poke choice for each mouse
% Step 1 - enter mouse id (string) as a variable (mouseID)
% 2 - create switch statement where each case is a mouse ID string argument
% 3 - Within each case store the mouse nose poke choice as a variable - v_poke_choice - up = 1 and down = 0

% convert the script innto a function
% pass the mouoseID to the function
% return the v_poke_choice to the calling script
% print/disp the choice in the calling script

function y= get_mouse_choice_f_v2(subject_ID)



% fname = 'asd';
% tot_corr = 190;
% tot_missed = 35;
% tot_incorr = 32;
% Tot_trials = 100;
% perc_corr_vert = 95;
% perc_corr_horz = 85;


% sprintf('Mouse ID - %s \nDate - %s \nTot trials-%d, \nTot Correct-%d, \nTot Incorr-%d, \nTot Missed-%d, \nPerc Vert Corr-%2.1f, \nPerc Horz Corr-%2.1f', ...
%         subject_ID, fname, Tot_trials, tot_corr, tot_incorr, tot_missed, perc_corr_vert, perc_corr_horz)

        switch subject_ID
          case {'MiTg01'}
%             disp('v_poke_choice - up = 1')
            y = 1;
          case {'MiTg02'}
            %disp('v_poke_choice - down = 0')
            y = 0;
          case {'MiTg03'}
           % disp('v_poke_choice - down = 0')
             y = 0;
           case {'MiTg04'}
           % disp('v_poke_choice - up = 1')
             y = 1;
           case {'MiTg05'}
            %disp('v_poke_choice - up = 1')
             y = 1;
          case {'MiTg06'}
           % disp('v_poke_choice - down = 0')
             y = 0;
           case {'MiTg07'}
          %  disp('v_poke_choice - down = 0')
             y = 0;
          case {'MiTg08'}
          %  disp('v_poke_choice - up = 1')
             y = 1;
          case {'MiTg09'}
           % disp('v_poke_choice - up = 1')
            y = 1;
          case {'MiTg10'}
           % disp('v_poke_choice - down = 0')
            y = 0;
           case {'MiTg11'}
           % disp('v_poke_choice - down = 0')
           y = 0;
           case {'MiTg12'}
            %disp('v_poke_choice - up = 1')
            y = 1;
          case {'SCB_2'}
            %disp('v_poke_choice - up = 1')
            y = 1;
          case {'SCB05'}
            %disp('v_poke_choice - up = 1')
            y = 1;
          case {'SCB06'}
            %disp('v_poke_choice - up = 1')
            y = 1;
            
            
                
          otherwise
            disp('Unknown method.')
        end
      

        
        % Use if statement to convert the mouses vertical percent correct to up or down correct
        
        
end

