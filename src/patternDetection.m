observations = csvread('../input/observations.csv');

series1=zeros(3000,100);ctr1=1;indexSeries1=zeros(3000,1);
series2=zeros(3000,100);ctr2=1;indexSeries2=zeros(3000,1);
series3=zeros(3000,100);ctr3=1;indexSeries3=zeros(3000,1);

for i=1:3000
    for j=1:85
        
        %         Pattern of 3
        if(observations(i,j) == observations(i,j+3))
            if((observations(i,j+1) == observations(i,j+4)) && (observations(i,j+2) == observations(i,j+5)) )
                series1(ctr1,:)=observations(i,:);
                indexSeries1(ctr1,1)=i;
                ctr1=ctr1+1;
                break;
            end;
        end;
        
        %         Pattern of 5
        if(observations(i,j) == observations(i,j+5))
            if((observations(i,j+1) == observations(i,j+6)) && (observations(i,j+2) == observations(i,j+7)) && (observations(i,j+3) == observations(i,j+8)) && (observations(i,j+4) == observations(i,j+9) ))
                series2(ctr2,:)=observations(i,:);
                indexSeries2(ctr2,1)=i;
                ctr2=ctr2+1;
                break;
            end;
        end;
        %         Pattern of 8
        if(observations(i,j) == observations(i,j+8))
            if((observations(i,j+1) == observations(i,j+9)) && (observations(i,j+2) == observations(i,j+10)) && (observations(i,j+3) == observations(i,j+11)) && (observations(i,j+4) == observations(i,j+12)) && (observations(i,j+5) == observations(i,j+13)) && (observations(i,j+6) == observations(i,j+14)) && (observations(i,j+7) == observations(i,j+15)) )
                series3(ctr3,:)=observations(i,:);
                indexSeries3(ctr3,1)=i;
                ctr3=ctr3+1;
                break;
            end;
        end;
        
    end;
end;

seriesOne = series1(1:ctr1-1,:);
indexSeriesOne = indexSeries1(1:ctr1-1,:);
csvwrite('series1.csv',seriesOne);
csvwrite('indexSeries1.csv',indexSeriesOne);

seriesTwo = series2(1:ctr2-1,:);
indexSeriesTwo = indexSeries2(1:ctr2-1,:);
csvwrite('series2.csv',seriesTwo);
csvwrite('indexSeries2.csv',indexSeriesTwo);

seriesThree = series3(1:ctr3-1,:);
indexSeriesThree = indexSeries3(1:ctr3-1,:);
csvwrite('series3.csv',seriesThree);
csvwrite('indexSeries3.csv',indexSeriesThree);

