# MIS581 Final Code
Capstone Class MIS581

## This is the final code run for the MIS581 Portfolio Assignment

[Creating this for the MIS581 Final](https://csuglobal.instructure.com/courses/17325/assignments/351198?module_item_id=850636)

## create table in SAS from CSV ##
data vehicle_sales;
	infile '/folders/myfolders/sasuser.v94/PORTFOLIO CSV.csv' dlm=',' firstobs=2;
	input Stock_Number $ Dealer $ Dealer_Code $ Inventory_Type $ Year $ Make $ Model $ Sale_Price Front_Gross 
	Back_Gross Total_Gross Sold_Date State $ Postal_Code $ Birthday Tracking_Code $ Lead_Source $ Adjusted_Response_Time_Min 
	Last_Attempted_Email_Contact Age Sold_Count;
RUN;

## Generic Process Means to understand data ##
	
PROC MEANS DATA=WORK.vehicle_sales;
RUN;

## Process means on specific third party lead ##

PROC MEANS DATA=work.vehicle_sales;
	CLASS Lead_source;
	VAR total_gross sold_count;
	Where lead_source in ('TrueCar' 'AutoTrader' 'CARFAX' 'CarGurus.com' 
	'Cars.com' 'Costco' 'Edmunds' 'KBB');
RUN;


## ANOVA analysis to compare means of differnect third party sources ##
proc glm data=WORK.VEHICLE_SALES;
	class Lead_Source;
	model Total_Gross=Lead_Source;
	means Lead_Source / hovtest=levene welch plots=none;
	lsmeans Lead_Source / adjust=tukey pdiff alpha=.05;
	WHERE lead_source in ('TrueCar' 'AutoTrader' 'CARFAX' 'CarGurus.com' 
	'Cars.com' 'Costco' 'Edmunds' 'KBB');
RUN; 


## Correlation analysis focused on sale price and back gross but with other variables added ##
proc corr data=WORK.VEHICLE_SALES pearson nosimple noprob 
		plots=scatter(ellipse=none);
	var Sale_Price Adjusted_Response_Time_Min Age;
	with Back_Gross Total_Gross;
run;

## Predictive regression model to determine back gross based off of price ##
proc glmselect data=WORK.VEHICLE_SALES plots=(criterionpanel);
	model Back_Gross=Sale_Price / selection=stepwise
(select=sbc) hierarchy=single;
run;
