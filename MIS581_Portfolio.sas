data Capstone_Portfolio;
	infile '/folders/myfolders/sasuser.v94/PORTFOLIO CSV.csv' dlm=',' firstobs=2;
	input Stock_Number $ Dealer $ Dealer_Code $ Inventory_Type $ Year $ Make $ Model $ Sale_Price Front_Gross 
	Back_Gross Total_Gross Sold_Date State $ Postal_Code $ Birthday Tracking_Code $ Lead_Source $ Adjusted_Response_Time_Min 
	Last_Attempted_Email_Contact Age Sold_Count;
RUN;

PROC MEANS DATA=WORK.Capstone_Portfolio;
RUN;

PROC MEANS DATA=WORK.Capstone_Portfolio;
	CLASS Lead_source;
	VAR total_gross sold_count;
	Where lead_source in ('TrueCar' 'AutoTrader' 'CARFAX' 'CarGurus.com' 
	'Cars.com' 'Costco' 'Edmunds' 'KBB');
RUN;

proc glm data=WORK.Capstone_Portfolio;
	class Lead_Source;
	model Total_Gross=Lead_Source;
	means Lead_Source / hovtest=levene welch plots=none;
	lsmeans Lead_Source / adjust=tukey pdiff alpha=.05;
	WHERE lead_source in ('TrueCar' 'AutoTrader' 'CARFAX' 'CarGurus.com' 
	'Cars.com' 'Costco' 'Edmunds' 'KBB');
RUN; 

proc corr data=WORK.Capstone_Portfolio pearson nosimple noprob 
		plots=scatter(ellipse=none);
	var Sale_Price Adjusted_Response_Time_Min Age;
	with Back_Gross Total_Gross;
run;

proc glmselect data=WORK.Capstone_Portfolio plots=(criterionpanel);
	model Back_Gross=Sale_Price / selection=stepwise
(select=sbc) hierarchy=single;
run;