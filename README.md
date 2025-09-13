# Swiggy-Data-Analysis-SQL

This project performs end-to-end data analysis on Swiggy’s restaurant menu dataset to uncover business insights, improve data quality, and generate actionable recommendations for stakeholders.

#### The primary goals of this project were:

- Ensure data quality through profiling, cleaning, and validation.
- Conduct exploratory data analysis (EDA) and market basket analysis to find popular dishes, categories, and high-performing restaurants.
- Perform market penetration analysis to understand city-level opportunities.
- Generate business insights like restaurant performance scoring, market gaps, and customer behavior segmentation.

This project demonstrates advanced SQL skills including:  
✅ Data Quality Assessment (DQA)  
✅ Data Cleaning (removing duplicates, handling nulls)  
✅ Market Basket Analysis  
✅ Cohort & Segmentation Analysis  
✅ Statistical Analysis (percentiles, IQR, coefficient of variation)  
✅ Business Recommendations  

#### Dataset Description
Dataset is downloaded form:    https://www.kaggle.com/datasets/nikhilmaurya1324/swiggy-restaurant-data-india 

Contains information on restaurant menus, including:  
*State*	  --            State where the restaurant operates   
*City*	  --            City where the restaurant is located  
*Restaurant_Name*	 --   Name of the restaurant  
*Location*	  --        Local area / neighborhood  
*Category*	  --        Dish category (e.g., Biryani, Dessert)  
*Dish_Name*	  --        Specific dish name  
*Price_INR*	  --        Price of the dish (in INR)  
*Rating*	    --        Average rating given by customers  
*Rating_Count*--	      Number of ratings received  

#### Approach & Methodology
1️⃣ Data Quality Assessment (DQA)  
- Counted total records and unique values across columns.  
- Computed descriptive statistics (avg, min, max, stddev) for Price_INR and Rating.  
- Purpose: Understand dataset coverage and detect anomalies.  

2️⃣ Data Quality Issues (DQI)  
- Checked for missing values across categorical & numerical fields.
- Identified duplicate records using GROUP BY and HAVING cnt > 1.  

3️⃣ Data Cleaning  
- Added a primary key column (id) for better record handling.
- Removed duplicates using ROW_NUMBER() to retain only first occurrence.  

4️⃣ Market Basket Analysis (MBA)  
- Found Top 10 most frequently ordered dishes.
- Identified Top categories and Top-rated restaurants.
- Ranked Cities with highest restaurant density.  

5️⃣ Market Analysis  
- Calculated market penetration metrics:
- Market size rank (by restaurant count)
- Quality rank (by rating)
- Affordability rank (by price)
- Classified markets into Premium, Value, Quality-focused, or Emerging segments.
- Performed Rating Distribution Analysis using quartiles (Q1, Q3, IQR).  

6️⃣ Business Insights  
- Created a Restaurant Performance Score using weighted average of ratings, popularity, and pricing.
- Classified restaurants into tiers: Excellent, Good, Average, Below Average, Poor.
- Identified Market Gaps (Budget, Premium, Quality).
- Recommended Investment Strategies based on city-wise gaps.  

7️⃣ Cohort Analysis (Customer Segmentation)  
- Grouped restaurants into segments like:  
- Loyal High-Value
- Premium Seekers
- Value Hunters
- New/Experimental Users  
Calculated growth potential score for each segment using rating, CLV proxy, and market share.

#### Key Insights  





#### Business Recommendation










      
### Project workflow  
- Download the file   *swiggy_all_menus_india.csv*   from   https://www.kaggle.com/datasets/nikhilmaurya1324/swiggy-restaurant-data-india
- Run Step_1.ipynb jupyter notebook (provide correction in data format)
- Create Schema called  *swiggy_db* into your MYSQL workbench
- Load *cleaned_swiggy_menu.csv"*  as a table in *swiggy_db*  database into your MYSQL workbench (File -> Open SQL script -> file_path.....)
- Run the query and get the output
