
function f = output_latex_estimates(logdir,outputfile,title,xistar,SSE,...
    figs,Moments)

%============= Create Tex File =============
fid = fopen(fullfile(logdir,[outputfile '.tex']),'w');

%============= Latex Header =============
fprintf(fid,'\\documentclass[a4paper, 10pt]{article}\n');
fprintf(fid,'\\usepackage{amssymb,amsmath,amsthm,verbatim,esint,multicol,booktabs}\n');
fprintf(fid,'\\usepackage{enumitem}\n');
fprintf(fid,'\\usepackage[round]{natbib}\n');
fprintf(fid,'\\usepackage[margin=.76 in]{geometry}\n');
fprintf(fid,'\\usepackage{fancyhdr}\n');
fprintf(fid,'\\usepackage{titlesec}\n');
fprintf(fid,'\\usepackage{bbm}\n');
fprintf(fid,'\\usepackage{graphicx}\n');
fprintf(fid,'\\usepackage{color}\n');
fprintf(fid,'\\usepackage{setspace}\n');
fprintf(fid,'\\titleformat*{\\section}{\\large\\bfseries}\n');
fprintf(fid,'\\titleformat*{\\subsection}{\\bfseries}\n');
fprintf(fid,'\\titleformat*{\\subsubsection}{\\itshape}\n');
fprintf(fid,'\\pagestyle{fancy}\n');
fprintf(fid,'\\fancyhead{}\n');
fprintf(fid,'\\fancyfoot{}\n');
formatSpec =  '\\fancyhead[CO,CE]{%s}\n';
fprintf(fid,formatSpec,title{1});
fprintf(fid,'\\setlength\\parindent{24pt}\n');
fprintf(fid,'\\begin{document}\n');
fprintf(fid,'\\onehalfspacing\n');
formatSpec =  '\\section*{%s}\n';
fprintf(fid,formatSpec,title{1});

%============= Table with Estimates =============
fprintf(fid,'\\subsection*{Estimation} \n');

fprintf(fid,'\\begin{table}[h] \\centering \n');
fprintf(fid,'\\caption{Estimated Parameters} \n');
fprintf(fid,'\\begin{tabular}{l c}  \n');
fprintf(fid,'\\addlinespace  \n');
fprintf(fid,'\\toprule  \n');
fprintf(fid, 'Discount factor $\\delta$                    & %6.3f \\\\ \n', xistar(1));
fprintf(fid, 'Cost parameter of search cost $k$            & %6.2f \\\\ \n', xistar(2));
fprintf(fid, 'Curvature of search cost $\\gamma$           & %6.3f \\\\ \n', xistar(3));
fprintf(fid, 'Steady state mean - wage offer dist. $\\mu$  & %6.2f \\\\ \n', xistar(4));
fprintf(fid, 'Std. dev. - wage offer dist. $\\sigma$       & %6.2f \\\\ \n', xistar(5));
fprintf(fid, 'Period when wage offers become flat $\\pi$   & %6.2f \\\\ \n', xistar(6));
fprintf(fid, 'Slope of wage offer distribution $S$         & %6.3f \\\\ \n', xistar(7));

if length(xistar)>7
    fprintf(fid, 'Share of first type $p$    & %6.2f \\\\ \n', xistar(8));
    fprintf(fid, 'Cost of second type $k_2$  & %6.2f \\\\ \n', xistar(9));
end

fprintf(fid,'\\midrule  \n');
fprintf(fid, 'SSE   & %6.5f \\\\ \n', SSE);

fprintf(fid,'\\bottomrule  \n');
fprintf(fid,'\\end{tabular}  \n');
fprintf(fid,'\\end{table}  \n');


%============= Table with Moments =============
fprintf(fid,'\\subsection*{Actual and Predicted Moments} \n');

fprintf(fid,'\\begin{table}[h] \\centering \n');
fprintf(fid,'\\caption{Moments} \n');
fprintf(fid,'\\begin{tabular}{l c c}  \n');
fprintf(fid,'\\addlinespace  \n');
fprintf(fid,'\\toprule  \n');
fprintf(fid, ' & Actual Moments & Predicted Moments \\\\ \n');
fprintf(fid,'\\midrule  \n');
fprintf(fid, 'E[Nonemp Dur ; P=12]        & %6.3f & %6.3f \\\\ \n', Moments(1,:));
fprintf(fid, 'E[Nonemp Dur ; P=18]        & %6.3f & %6.3f \\\\ \n', Moments(2,:));
fprintf(fid, 'E[UI Benefit Dur ; P=12]    & %6.3f & %6.3f \\\\ \n', Moments(3,:));
fprintf(fid, 'E[UI Benefit Dur ; P=18]    & %6.3f & %6.3f \\\\ \n', Moments(4,:));
fprintf(fid, 'E[Reemployment Wage ; P=12] & %6.3f & %6.3f \\\\ \n', Moments(5,:));
fprintf(fid, 'E[Reemployment Wage ; P=18] & %6.3f & %6.3f \\\\ \n', Moments(6,:));
fprintf(fid, 'dD/dP                       & %6.3f & %6.3f \\\\ \n', Moments(7,:));
fprintf(fid, 'dW/dP                       & %6.3f & %6.3f \\\\ \n', Moments(8,:));

fprintf(fid,'\\bottomrule  \n');
fprintf(fid,'\\end{tabular}  \n');
fprintf(fid,'\\end{table}  \n');


%============= Figures =============
if length(figs)>=1
    fprintf(fid,'\\subsection*{Figures} \n');
    
    for i=1:length(figs)
        filename = fullfile('./',figs{i});
        fprintf(fid, ['\\includegraphics[clip=true, trim=2cm 6cm 2cm 6cm, width=.40\\textwidth]{' filename '} \\\\ \n'] );
%         fprintf(fid,'\\\\ \n');
    end
end



fprintf(fid,'\\clearpage  \n');

fprintf(fid,'\\end{document}\n');
fclose(fid);

close all;

