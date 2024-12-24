choice = menu('Choose the scenario', '1-Suspension during 2nd inning and no further play is possible.', '2-Suspension during 2nd inning and further play is possible.','3-Two suspensions during 2nd innings and further play is possible.','4-Delay to start of innings.(both or one)','5-Suspension during 1st inning.','6-Suspension and termination of 1st inning mid-over and delay to 2nd inning.');

prompt = {'Enter the team batting first', 'Enter the team batting second'};
dlg_title = 'Match';
num_lines = [1 50];
def = {'', ''};
answer = inputdlg(prompt, dlg_title, num_lines, def);

team1=answer{1};
team2=answer{2};

filename = 'DLS ball by ball.xlsx';
sheet = 'Sheet1';
[~, ~, raw] = xlsread(filename, sheet);

switch choice
    case 1
        
       prompt = {sprintf('%s score', team1), sprintf('%s overs remaining', team2), sprintf('%s wicket loss', team2), sprintf('%s score', team2)};
       
       
       answer = inputdlg(prompt, 'Match Details', [1 50; 1 50; 1 50; 1 50]);
        
        t1_s= str2double(answer{1});
        t2_o= str2double(answer{2});
        t2_w = str2double(answer{3});
        t2_s= str2double(answer{4});
        
        row2 = round(301-((t2_o-floor(t2_o))*10+floor(t2_o)*6));
        col2 = round(t2_w+1);
        R1 = 100;
        R2 = 100-raw{row2, col2};
        par_score=floor(t1_s*(R2/R1));
        win=par_score-t2_s;
        [cdata,map] = imread('bat.tif'); 
        
     
        if win>0
            S = msgbox(sprintf('D/L Par score is %d \n %s is won by %d runs.', par_score,team1,win),'Result','custom',cdata,map);
            
        elseif win<0
            S = msgbox(sprintf('D/L Par score is %d \n %s is won by %d wickets.', par_score,team2,10-t2_w),'Result','custom',cdata,map);
           
        else
            S = msgbox(sprintf('D/L Par score is %d \nMatch tied', par_score),'Result','custom',cdata,map);
           
        end
        
    case 2
        prompt = {sprintf('%s score', team1), sprintf('%s overs remaining', team2), sprintf('%s wicket loss', team2), sprintf('%s score', team2),sprintf('Overs lost from %s inning', team2)};
        answer = inputdlg(prompt, 'Match Details', [1 50; 1 50; 1 50; 1 50;1 50]);
       
       
        
        t1_s= str2double(answer{1});
        t2_o= str2double(answer{2});
        t2_w = str2double(answer{3});
        t2_s= str2double(answer{4});
        o_l= str2double(answer{5});

        
        R1=100;
        row2 = round(301-((t2_o-floor(t2_o))*10+floor(t2_o)*6));
        col2 = round(t2_w+1);
        row3 = round(row2+o_l*6);
        R2=100-(raw{row2, col2}-raw{row3, col2});
        target=floor((t1_s*R2/R1))+1;
        
        h = msgbox(sprintf('%s revised target is %d and %s needs %d more runs to win from %.1f overs.', team2, target,team2,target-t2_s,floor((301-row3)/6)+rem((301-row3),6)/10));
                
    case 3
        
        prompt = {sprintf('%s score', team1), sprintf('%s Overs remaining before first suspention', team2), sprintf('%s Wickets loss before first suspention', team2), sprintf('%s Score before first suspention:', team2),sprintf('Overs lost for first suspention in %s inning', team2)};
        answer1 = inputdlg(prompt, 'Match Details for first suspension', [1 50; 1 50; 1 50; 1 50;1 50]);
       
       
        
        t1_s= str2double(answer1{1});
        t2_o1= str2double(answer1{2});
        t2_w1 = str2double(answer1{3});
        t2_s1= str2double(answer1{4});
        o_l1= str2double(answer1{5});
        R1=100;
        
        row2 = round(301-((t2_o1-floor(t2_o1))*10+floor(t2_o1)*6));
        col2 = round(t2_w1+1);
        row3 = round(row2+o_l1*6);
        R2=100-(raw{row2, col2}-raw{row3, col2});
        target1=round((t1_s*R2/R1))+1;
        o_r=floor((301-row3)/6)+rem((301-row3),6)/10;
        
        
        h1 = msgbox(sprintf('%s revised target after the first suspension is %d and %s needs %d more runs to win from %.1f overs.', team2, target1,team2,target1-t2_s1,o_r));
        
        
        prompt = {sprintf('%s Overs remaining before second suspention', team2), sprintf('%s Wickets loss before second suspention', team2), sprintf('%s Score before second suspention:', team2),sprintf('Overs lost for second suspention in %s inning', team2)};
        answer2 = inputdlg(prompt, 'Match Details for second suspension', [1 50; 1 50; 1 50; 1 50]);
        

        t2_o2= str2double(answer2{1});
        t2_w2= str2double(answer2{2});
        t2_s2= str2double(answer2{3});
        o_l2=str2double(answer2{4});
        
        row4 = round(301-((t2_o2-floor(t2_o2))*10+floor(t2_o2)*6));
        col4 = round(t2_w2+1);
        row5 = round(row4+o_l2*6);
        R3=R2-(raw{row4, col4}-raw{row5, col4});
        target2=floor((t1_s*R3/R1))+1;
        o_r2=floor((301-row5)/6)+rem((301-row5),6)/10;
        
        h = msgbox(sprintf('%s revised target after the second suspension is %d and %s needs %d more runs to win from %.1f overs.', team2, target2,team2,target2-t2_s2,o_r2));
   
    case 4
        prompt = {sprintf('overs remaining to %s after the delay(If no delay type 50)', team1), sprintf('%s Score', team1), sprintf('Overs remaining to %s after the delay', team2)};
        answer = inputdlg(prompt, 'Match Details', [1 50; 1 50; 1 50]);
        
        
        
        t1_o= str2double(answer{1});
        t1_s= str2double(answer{2});
        row1=round(301-t1_o*6);
        R1=raw{row1,1};
        t2_o=str2double(answer{3});
        
        row2=round(301-t2_o*6);
        R2=raw{row2, 1};
        target= floor(t1_s*R2/R1)+1;
        
        h = msgbox(sprintf('%s revised target after delay is %d from %d overs.', team2,target,t2_o));
       
    case 5
        G50=245;
        prompt = {sprintf('%s overs remaining before suspention', team1), sprintf('%s Wickets loss before suspention', team1),'Overs lost from whole match'};
        answer = inputdlg(prompt, 'Match Details upto suspension', [1 50; 1 50; 1 50]);
        
        
        
        
        t1_o= str2double(answer{1});
        t1_w= str2double(answer{2});
        row1=round(301-((t1_o-floor(t1_o))*10+floor(t1_o)*6));
        col1=round(t1_w+1);
        o_l=str2double(answer{3});
        row2=round(row1+o_l*3);
        R1=100-(raw{row1,col1}-raw{row2,col1});
        
        prompt = {sprintf('%s score after %d overs done:', team1,50-o_l/2)};
        answer1 = inputdlg(prompt, 'Match Details after 1st inning', [1 10]);
        
        t1_s=str2double(answer1{1});
        
        R2=raw{301-(50-o_l/2)*6,1};
        target=floor(t1_s+G50*(R2-R1)/100)+1;
        
        h = msgbox(sprintf('%s needs %d more runs to win from %d overs.', team2,target,50-o_l/2));
       
        
     case 6 
        prompt = {sprintf('%s score upto termination', team1), sprintf('%s overs remaining upto termination', team1), sprintf('%s Wickets loss upto termination', team1)};
        answer = inputdlg(prompt, 'Match Details upto termination', [1 50; 1 50; 1 50]);

         
        t1_s= str2double(answer{1});
        t1_o= str2double(answer{2});
        t1_w= str2double(answer{3});
        row1=round(301-((t1_o-floor(t1_o))*10+floor(t1_o)*6));
        col1=round(t1_w+1);
        R1=100-raw{row1,col1};
        
        prompt = {sprintf('Overs lost from %s inning', team2)};
        answer1 = inputdlg(prompt, 'Match Details after 1st inning', [1 10]);
         
        o_l=str2double(answer1{1});
        
        row2=301-(50-o_l)*6;
        
        R2=raw{row2,1};
        target=floor(t1_s*R2/R1+1);
        
        
        h = msgbox(sprintf('%s needs %d more runs to win from %d overs.', team2,target,50-o_l));
         
end