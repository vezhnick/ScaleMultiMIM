% to be parameters

for i = 1 : 150    
    if exist( ['./Trees/tree_' num2str(i) '.mat'] );
        disp(num2str(i));
        system(['bsub -J ' 'job' num2str(i) ' -oo "./Output/%J.out"  -R "rusage[mem=5110]" -W 01:00 ./MAPTestTree' ' ./Trees/tree_' num2str(i) '.mat' ' ./Pred/prediction_' num2str(i) '.mat']);
    end    
end