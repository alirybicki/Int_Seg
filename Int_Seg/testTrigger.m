
sendTrigger = intialiseParallelPort();

for ii = 0:7
    sendTrigger(power(2, ii))
    WaitSecs(1);
end