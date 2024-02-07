proc import datafile="/home/u62173996/final project/biopics_data - Copy.csv" dbms=csv out=biopic_data1;
run;
*getting rid of missing data/;
*https://www.statology.org/sas-delete-rows/ code citation/;
*any errors that may appear when the import occurs have not caused any issues with my data analysis/;
*and have not caused any issues with getting output data/;
data biopic_data2;
    set biopic_data1;
    if box_office = "-" then delete;
run;
proc print data=biopic_data2;

*proc means/;
*Use global TITLE statements to display the title of generated tables./;
proc means data=biopic_data2;
	title "Biopics Analysis";
run;

*Use PROC CONTENTS steps to display important attributes of your data./;
proc contents data=biopic_data2;

*Use PROC FREQ steps to generate frequency tables./;
proc freq data=biopic_data2;
	tables country;
	title "Frequency of Countries";
run;
proc freq data=biopic_data2;
	tables person_of_color;
	title "Frequency of Inclusion";
run;

*Demonstrate filtering of the data using the WHERE statement./;
*Demonstrate filtering of the columns of your dataset using DROP and/or KEEP./;
data poc_biopics;
	set biopic_data2;
	where person_of_color=1;
	keep title box_office year_release type_of_subject;
run;

*USE PROC SORT to reveal the minimum or maximum row of a variable in yourdata./;
proc sort data=biopic_data2 out=sorted_bio;
	by box_office;
run;

*Create a new (small) dataset using DATALINES./;
data biopics_sample1;
	length ID Title $20 Box_Office 8;
	input ID Title $ Box_Office;
	infile datalines dsd dlm = ',';
	datalines;
	1, 20 Dates, 537000
	2, 21,	81200000
	3, 24 Hour Party People, 1130000
	4, 42,	95000000
	5, 8 Seconds, 19600000
	6, 84 Charing Cross Road, 1080000
	7, A Beautiful Mind, 171000000
	;
run;
data biopics_sample2;
	length ID POC $16;
	input ID POC;
	infile datalines dsd dlm = ',';
	datalines;
	1, White
	2, Asian American
	3, White
	4, African American
	5, Unknown
	6, Unknown
	7, White
	;
run;
*Combine two datasets using the MERGE statement./;
data biopics_sample3;
	merge biopics_sample1 biopics_sample2;
	by ID;
run;

*Use PROC PRINT steps (with formatting) to output your data in a way that is different than the default./;
proc print data=biopics_sample3;
	var Title Box_Office POC;
	format Box_Office dollar13.2;
	title "Formatted Sample of Data";
run;

*Demonstrate conditional processing in SAS (using if statements)./;
data biopics_sample_org;
	set biopic_data2;
	if person_of_color=1 then Demographics= "Inclusive";
	if person_of_color=0 then Demographics= "Exclusive";
	keep Title box_office year_release Demographics;
	
proc freq data = biopics_sample_org;
	tables Demographics / PLOT = FREQPLOT;
	title "Diversity Analysis";
run;
*Create visualizations using different charts (at least two)/;
proc sgplot data=biopic_data2;
	vbar type_of_subject;
	title "Graphic Dist. of Movies by Subject";
run;

proc sgplot data=poc_biopics;
	vbar type_of_subject;
	title "Graphic Dist. of POC Movies by Subject";
run;
data excl_biopics;
	set biopic_data2;
	where person_of_color=0;
	keep title box_office year_release type_of_subject;
run;

proc sgplot data=excl_biopics;
	vbar type_of_subject;
	title "Graphic Dist. of non-POC Movies by Subject";
run;
proc freq data=biopic_data2;
	tables type_of_subject;
	title "Distribution of Movies by Subject";
proc freq data=poc_biopics;
	tables type_of_subject;
	title "Distribution of POC Movies by Subject";
run;

proc freq data=excl_biopics;
	tables type_of_subject;
	title "Distribution of non-POC Movies by Subject";
run;

