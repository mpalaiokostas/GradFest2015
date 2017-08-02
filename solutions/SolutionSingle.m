%% INITIALISING SCRIPT

  clc         % Clears the command window
  clear       % Clears the workspace (vectors etc.)
  close all   % Closes all active figures

%% SETTING PARAMETERS

  disp('DATA ANALYSIS SCRIPT')
  username='Iwannabeadoctor';         % Set your name between the single quotes
  output=['Researcher: ', username];  % Creates a string vector
  disp(output)                        % Prints the name of the user
  disp('Analysis starting...')

  %% PREPARING THE SUMMARY FILE TO SAVE THE RESULTS    
  finalresult=cell(1,7);        % Define the size of the file (rows,columns)
  filename='Summary.txt';        % Define filename
  fid = fopen(filename, 'wt');   % Open the file in "write" state

%% READING INPUT

  cd('datasets')              % Change to dataset directory
  filename='tutorial-1.dat';  % Name of the file to import
  data=dlmread(filename);     % Save the contents of the file to the matrix "data"
  cd('..')                    % Return to previous directory

%% PLOTTING ... (see the help page of "plot" for details!)

  x=data(:,1);    % Setting x-axis data
  y=data(:,2);    % Setting y-axis data

  % ... a simple figure
  figure(1)
  plot(x,y)

  % ... a proper figure 
  figure(2)
  plot(x,y,'Color','r','Marker','o','Linestyle','--')
  hold on                         % Add the following settings
  title('My first MATLAB plot!')  % Set the title
  xlabel('Time [ms]')             % Set x-axis label
  ylabel('Signal values')         % Set y-axis label
  xlim([min(x),max(x)])           % Manually set x-axis limits
  legend('File 1')                % Set the legend
  hold off                        % Stop adding settings

  % Save figure 2 as a high quality .png
  figurename='plot1';
  resolution='-r300';         % Resolution in dots per inch
  cd('figures')
  print('-f2',figurename,'-dpng',resolution)
  cd('..')

%% STATISTICAL ANALYSIS...

  % ...calculate the mean
  average=mean(data(:,2));
  output=['For ',filename,' the mean is: ',num2str(average)];
  disp(output)

  % ...calculate the standard deviation
  stdev=std(data(:,2));
  output=['For ',filename,' the standard deviation is: ',num2str(stdev)];
  disp(output)

  % ... calculate the minimum and maximum
  minValue=min(data(:,2));
  output=['For ',filename,' the minimum value is: ',num2str(minValue)];
  disp(output)
  maxValue=max(data(:,2));
  output=['For ',filename,' the maximum value is: ',num2str(maxValue)];
  disp(output)

  % ... percentage of data that are larger or smaller than the average
  dataRows=size(data,1);      % Returns the number of measurements
  counterSmaller=0;
  counterLarger=0;
  for i = 1:dataRows
    if data(i,2)<=average
	counterSmaller=counterSmaller+1; 
    else
	counterLarger=counterLarger+1;
    end    
  end
  percSmaller=(counterSmaller/dataRows)*100;
  percLarger=(counterLarger/dataRows)*100;
  output=['For ',filename,', ',num2str(percLarger),'% is higher than the average and ',num2str(percSmaller),'% is lower.'];
  disp(output)

%% FILTERING DATA...

  % ... create a new dataset with only the larger than average values
  larger=zeros(counterLarger,2);  % Create an empty matrix to store the filtered values
  counterSide=1;
  for i=1:dataRows
      if data(i,2)>average
	  larger(counterSide,1)=data(i,1);
	  larger(counterSide,2)=data(i,2);
	  counterSide=counterSide+1;
      end
  end

  % Plot only the filtered data
  figure(3)
  x=larger(:,1);
  y=larger(:,2);
  plot(x,y,'Marker','*','Color','black')
  hold on
  title('Filtered signal')
  xlabel('Time [ms]')
  ylabel('Signal values')
  legend('File 1')
  hold off

%% FITTING A FUNCTION TO NON-LINEAR DATA

  % Do the fitting
  xfit=data(:,1);
  yfit=data(:,2);
  [fitresult, gof] = fit( xfit, yfit, 'sin1');

  % Plot the fit versus original data
  figure(4)
  x=xfit;
  y=yfit;
  plot(fitresult,xfit,yfit)
  hold on
  title('Fit vs Original data')
  xlabel('Time [ms]')
  ylabel('Signal values')
  legend('File 1', 'Fitted function');
  hold off

  % Save the plot to a .png file
  figurename='plot2';
  resolution='-r300'; 
  cd('figures')
  print('-f4',figurename,'-dpng',resolution)
  cd('..')

%% COLLECTING ANALYSIS RESULTS
  finalresult{1,1}=filename;
  finalresult{1,2}=num2str(average);
  finalresult{1,3}=num2str(stdev);
  finalresult{1,4}=num2str(minValue);
  finalresult{1,5}=num2str(maxValue);
  finalresult{1,6}=num2str(percLarger);
  finalresult{1,7}=num2str(percSmaller);

%% CLOSING SCRIPT
  % Save the summary array to a file
  for i=1:size(finalresult,1)
    format='%s %s %s %s %s %s %s\r\n';
    fprintf(fid, format, finalresult{i,:});
  end
  fclose(fid);   % Close the file
  disp('Analysis completed!')