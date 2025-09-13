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
*State*	  ---            State where the restaurant operates   
*City*	  ---            City where the restaurant is located  
*Restaurant_Name*	 ---   Name of the restaurant  
*Location*	  ---        Local area / neighborhood  
*Category*	  ---        Dish category (e.g., Biryani, Dessert)  
*Dish_Name*	  ---        Specific dish name  
*Price_INR*	  ---        Price of the dish (in INR)  
*Rating*	    ---        Average rating given by customers  
*Rating_Count* ---	      Number of ratings received  

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
| Insight                    | Example Finding                                                                                                      |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Top Dish**               | **Biryani** is the most frequently ordered dish across multiple cities, followed by Pizza and Paneer Butter Masala   |
| **Top Category**           | **North Indian cuisine** dominates across restaurants, accounting for \~40% of total menu items                      |
| **City Ranking**           | **Bangalore, Hyderabad, and Delhi** have the highest restaurant density and diverse offerings                        |
| **Pricing Insights**       | The **average dish price is \~₹350**, with premium dishes averaging ₹2,000+ in Tier-1 cities                         |
| **Market Gaps**            | **Premium dining options are underpenetrated in Tier-2 cities**, signaling growth opportunities                      |
| **Restaurant Performance** | Only **15% of restaurants are in the "Excellent" tier**, while 30% are "Below Average" or "Poor"                     |
| **Customer Segments**      | **Loyal High-Value customers** contribute over 40% of total rating counts, making them key revenue drivers           |
| **Engagement Insights**    | Restaurants with **higher rating counts also have higher average prices**, suggesting willingness to pay for quality |
| **Quality Distribution**   | Cities like **Chandigarh & Pune** show the highest share of 4.5+ rated restaurants                                   |
| **Investment Opportunity** | **Budget segment expansion** recommended in Jaipur, **premium entry** recommended in Lucknow & Indore                |

  
  
  
  
#### Business Recommendation
| Area                     | Recommendation                                                                                                           |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| **Menu Strategy**        | Focus on **expanding top-performing categories** (e.g., North Indian, Chinese) across more cities to meet demand.        |
| **Pricing Optimization** | Introduce **dynamic pricing** — lower prices during off-peak hours and offer premium bundles for high-value dishes.      |
| **City Expansion**       | Prioritize **Tier-2 cities** like Jaipur, Lucknow, Indore for premium dining experiences to capture unmet demand.        |
| **Quality Improvement**  | Support **below-average restaurants** with training or promotional incentives to improve ratings and retain customers.   |
| **Customer Engagement**  | Launch **loyalty programs** targeting "Loyal High-Value" and "Premium Seekers" segments to increase repeat orders.       |
| **Marketing Focus**      | Promote **top-rated restaurants** and offer discounts for underperforming ones to improve visibility and balance supply. |
| **Data-Driven Insights** | Regularly track **market penetration**, price sensitivity, and rating distribution to adjust city-level strategies.      |
| **Investment Planning**  | Allocate higher marketing spend in **markets with Budget Gap or Premium Gap**, as identified in the market analysis.     |










      
### Project workflow  
- Download the file   *swiggy_all_menus_india.csv*   from   https://www.kaggle.com/datasets/nikhilmaurya1324/swiggy-restaurant-data-india
- Run Step_1.ipynb jupyter notebook (provide correction in data format)
- Create Schema called  *swiggy_db* into your MYSQL workbench
- Load *cleaned_swiggy_menu.csv"*  as a table in *swiggy_db*  database into your MYSQL workbench (File -> Open SQL script -> file_path.....)
- Run the query and get the output
