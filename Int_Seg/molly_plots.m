clear all % clear all from workspace 
close all % close all plots 
clc % clear command window 

load('P_22_data.mat') % load data in 



block_acc = []
int_acc = []
seg_acc = [] 

seg = [1,3,5,7,9] % segregation trials
int = [2,4,6,8,10] % integration trials

% loop through data structure and get mean accuracy for every block (b) 
for b = 1:length(data)
    blo = mean(data(b).correct)
    block_acc = [block_acc, blo] % save

end


blocks = [1:10] % 10 blocks

plot(blocks, block_acc) % plot accuracy per block to see how much better people are getting
title('acc over blocks')
ylim([0 1])

% plot int and seg 
for i = 1:length(int)
    int_blo = mean(data(i).correct)
    int_acc = [int_acc, int_blo]
end


for s = 1:length(seg)
    seg_blo = mean(data(s).correct)
    seg_acc = [seg_acc, seg_blo]
end

mean_seg = mean(seg_acc) 
mean_int = mean(int_acc)

% look at mean acc per condition

str = {'seg'; 'int'};
figure;
bar([mean_seg, mean_int]) %bar([mean_seg, mean_int])
hold on
set(gca, 'Ylim' , [0 3])
ylabel('accu (%)')
xlabel('task version')
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))

title('acc per cond')

% look at distribution of RT 

% loop through data structure and get mean RT for every block (b)
block_rt = []
for r = 1:length(data)
    rt = mean(data(r).tmeasure.ChoiceTime) % if this is RT
    block_rt = [block_rt, rt] % save

end
figure;
plot(blocks, block_rt) % plot accuracy per block to see how much better people are getting
title('mean rt over blocks') % are people getting faster? 
%ylim([0 2.5])

% look at distribution of RT over all trials 

RT = data(10).tmeasure.ChoiceTime % take out all RTS 

figure
hist(RT)
hold on
set(gca, 'Xlim' , [0 3])
set(gca, 'Ylim' , [0 300])
ylabel('trials')
xlabel('RT')
title('RT')

% take out all of any coloumn in the data e.g. correct answers

corrects = {data.correct}.' 

Block1 = data(1).correct;
Acc_Block1 = (sum(Block1)/length(Block1))*100

Block2 = data(2).correct;
Acc_Block2 = (sum(Block2)/length(Block2))*100

Block3 = data(3).correct;
Acc_Block3 = (sum(Block3)/length(Block3))*100

Block4 = data(4).correct;
Acc_Block4 = (sum(Block4)/length(Block4))*100

Block5 = data(5).correct;
Acc_Block5 = (sum(Block5)/length(Block5))*100

Block6 = data(6).correct;
Acc_Block6 = (sum(Block6)/length(Block6))*100

Block7 = data(7).correct;
Acc_Block7 = (sum(Block7)/length(Block7))*100

Block8 = data(8).correct;
Acc_Block8 = (sum(Block8)/length(Block8))*100

Block9 = data(9).correct;
Acc_Block9 = (sum(Block9)/length(Block9))*100

Block10 = data(10).correct;
Acc_Block10 = (sum(Block10)/length(Block10))*100


% close all  
