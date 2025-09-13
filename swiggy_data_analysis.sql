-- =============================================================================
-- 1. DATA Inspection
-- =============================================================================

SELECT *
FROM swiggy_db.cleaned_swiggy_menu;




-- =============================================================================
-- 2. DATA QUALITY ISSUES (DQI)
-- Identifies potential data quality issues such as missing values, Duplicate values, Outliers etc.
-- =============================================================================

-- 2.1 Missing values identification
SELECT  SUM(CASE WHEN State IS NULL OR State = '' THEN 1 ELSE 0 END) AS missing_states,
        SUM(CASE WHEN City IS NULL OR City = '' THEN 1 ELSE 0 END) AS missing_cities,
        SUM(CASE WHEN Restaurant_Name IS NULL OR Restaurant_Name = '' THEN 1 ELSE 0 END) AS missing_restaurant_names,
        SUM(CASE WHEN Location IS NULL OR Location = '' THEN 1 ELSE 0 END) AS missing_locations,
        SUM(CASE WHEN Category IS NULL OR Category = '' THEN 1 ELSE 0 END) AS missing_categories,
        SUM(CASE WHEN Dish_Name IS NULL OR Dish_Name = '' THEN 1 ELSE 0 END) AS missing_dish_names,
        SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END) AS missing_prices,
        SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS missing_ratings,
        SUM(CASE WHEN Rating_Count IS NULL THEN 1 ELSE 0 END) AS missing_rating_counts
        
FROM swiggy_db.cleaned_swiggy_menu;


-- 2.2 Duplicate records identification
SELECT COUNT(*) AS duplicate_records
FROM (
    SELECT State, City, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count, COUNT(*) AS cnt
    FROM swiggy_db.cleaned_swiggy_menu
    GROUP BY State, City, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count
    HAVING cnt > 1
) AS duplicates;




-- =============================================================================
-- 3. DATA CLEANING 
-- Remove duplicate records 
-- =============================================================================

-- 3.1 Add the id column with AUTO_INCREMENT
ALTER TABLE swiggy_db.cleaned_swiggy_menu 
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;


-- 3.2 Delete duplicate records
DELETE t1 FROM cleaned_swiggy_menu t1
INNER JOIN (
    SELECT id,
           ROW_NUMBER() OVER (
               PARTITION BY State, City, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count 
               ORDER BY id
           ) as row_num
    FROM swiggy_db.cleaned_swiggy_menu
) t2 ON t1.id = t2.id
WHERE t2.row_num > 1;




-- =============================================================================
-- 4. DATA QUALITY ASSESSMENT (DQA)
-- Retrieves all records from the table and provides a summary of key statistics for data quality assessment. 
-- =============================================================================

SELECT  COUNT(*) AS total_records, 
        COUNT(DISTINCT State) AS unique_states, 
        COUNT(DISTINCT City) AS unique_cities,
        COUNT(DISTINCT Restaurant_Name) AS unique_restaurant,
        COUNT(DISTINCT Location) AS unique_locations,
        COUNT(DISTINCT Category) AS unique_categories,
        COUNT(DISTINCT Dish_Name) AS unique_dishes,
        ROUND(AVG(Price_INR), 2) AS avg_price,
        MIN(Price_INR) AS min_price,
        MAX(Price_INR) AS max_price,
        ROUND(STDDEV(Price_INR), 2) AS std_price,
        MIN(Rating) AS min_rating,
        MAX(Rating) AS max_rating,
        MIN(Rating_Count) AS min_rating_count,
        MAX(Rating_Count) AS max_rating_count,
        ROUND(AVG(Rating_Count), 1) AS avg_rating_count

FROM swiggy_db.cleaned_swiggy_menu;




-- =============================================================================
-- 5. MARKET BASKET ANALYSIS (MBA)
-- Perform Exploratory Data Analysis
-- =============================================================================

-- 5.1 Identifies the top 10 most frequently ordered dishes across all restaurants.
SELECT Dish_Name, COUNT(*) AS order_count
FROM swiggy_db.cleaned_swiggy_menu
GROUP BY Dish_Name
ORDER BY order_count DESC
LIMIT 10;   


-- 5.2 Identifies the top 10 most popular categories of dishes based on the number of orders.
SELECT Category, COUNT(*) AS order_count
FROM swiggy_db.cleaned_swiggy_menu
GROUP BY Category
ORDER BY order_count DESC
LIMIT 10;       


-- 5.3 Identifies the top 10 restaurants with the highest average rating.
SELECT Restaurant_Name, MAX(City) AS City, ROUND(AVG(Rating), 2) AS avg_rating
FROM swiggy_db.cleaned_swiggy_menu
GROUP BY Restaurant_Name
ORDER BY avg_rating DESC
LIMIT 10;


-- 5.4 Identifies the top 10 cities with the highest number of restaurants.
SELECT City, COUNT(DISTINCT Restaurant_Name) AS restaurant_count
FROM swiggy_db.cleaned_swiggy_menu
GROUP BY City
ORDER BY restaurant_count DESC
LIMIT 10;   





-- =============================================================================
-- 6. MARKET ANALYSIS 
-- =============================================================================

-- 6.1 Market Penetration Analysis
WITH city_metrics AS (
    SELECT 
        City AS city,
        COUNT(DISTINCT Restaurant_Name) as restaurant_count,
        ROUND(AVG(Rating), 1) as avg_rating,
        ROUND(AVG(Price_INR), 2) as avg_price,
        SUM(Rating_Count) as total_rating,
        SUM(CASE WHEN rating >= 4.5 THEN Rating_Count END) as high_rated_count
    FROM swiggy_db.cleaned_swiggy_menu
    WHERE rating IS NOT NULL
    GROUP BY city
),
city_rankings AS (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY restaurant_count DESC) as market_size_rank,
        ROW_NUMBER() OVER (ORDER BY avg_rating DESC) as quality_rank,
        ROW_NUMBER() OVER (ORDER BY avg_price ASC) as affordability_rank,
        ROUND(high_rated_count * 100.0 / total_rating, 2) as quality_percentage
    FROM city_metrics
)
SELECT 
    city,
    restaurant_count,
    ROUND(avg_rating, 1) as avg_rating,
    ROUND(avg_price, 2) as avg_price,
    quality_percentage,
    market_size_rank,
    quality_rank,
    affordability_rank,
    CASE 
        WHEN market_size_rank <= 10 AND quality_rank <= 20 THEN 'Premium Market'
        WHEN market_size_rank <= 20 AND affordability_rank <= 20 THEN 'Value Market'
        WHEN quality_rank <= 10 THEN 'Quality Focused'
        ELSE 'Emerging Market'
    END as market_category
FROM city_rankings
ORDER BY restaurant_count DESC;




-- =============================================================================
-- 7. BUSINESS INSIGHTS
-- =============================================================================

-- 7.1 Restaurant Performance Scoring 
WITH performance_metrics AS (
    SELECT 
        Restaurant_Name,
        City,
        ROUND(AVG(Rating), 2) AS avg_rating,
        ROUND(SUM(Rating_Count), 2) AS rating_count,
        ROUND(AVG(Rating_Count), 2) AS avg_popularity,
        ROUND(AVG(Price_INR), 2) AS avg_value
    FROM swiggy_db.cleaned_swiggy_menu
    GROUP BY Restaurant_Name,City
),
comprehensive_score AS (
    SELECT *,
        -- Weighted composite score
        ROUND((avg_rating * 0.5) + (avg_popularity * 0.3) + (avg_value * 0.2), 2) as performance_score
    FROM performance_metrics
),
performance_tiers AS (
    SELECT *,
        NTILE(10) OVER (ORDER BY performance_score) as performance_decile,
        CASE 
            WHEN performance_score >= 80 THEN 'Excellent'
            WHEN performance_score >= 65 THEN 'Good'
            WHEN performance_score >= 50 THEN 'Average'
            WHEN performance_score >= 35 THEN 'Below Average'
            ELSE 'Poor'
        END as performance_tier
    FROM comprehensive_score
)
SELECT 
    performance_tier,
    COUNT(*) as restaurant_count,
    ROUND(AVG(avg_rating), 2) as avg_rating,
    ROUND(AVG(rating_count), 0) as avg_review_count,
    ROUND(AVG(avg_popularity), 0) as avg_popularity,
    ROUND(AVG(avg_value), 0) as avg_price,
    ROUND(MIN(performance_score), 2) as min_score,
    ROUND(MAX(performance_score), 2) as max_score,
    ROUND(AVG(performance_score), 2) as avg_score
FROM performance_tiers
GROUP BY performance_tier
ORDER BY avg_score DESC;


-- 7.2 Market Opportunity Analysis
WITH restaurant_performance AS(
	SELECT 
        City,
        Restaurant_Name,
        ROUND(AVG(Rating), 2) as rating,
        MAX(Price_INR) as price
        
    FROM swiggy_db.cleaned_swiggy_menu
    GROUP BY City, Restaurant_Name
),
market_gaps AS (
    SELECT 
        City,
        -- Current market analysis
        COUNT(DISTINCT Restaurant_Name) as current_restaurants,
        ROUND(AVG(rating), 2) as market_quality,
        
        -- Price segment analysis
        COUNT(CASE WHEN price < 500 THEN 1 END) as budget_options,
        COUNT(CASE WHEN price BETWEEN 500 AND 2500 THEN 1 END) as mid_range_options,
        COUNT(CASE WHEN price > 2500 THEN 1 END) as premium_options,
        
        -- Quality distribution
        COUNT(CASE WHEN rating >= 4.0 THEN 1 END) as high_quality_restaurants,
        COUNT(CASE WHEN rating < 3.5 THEN 1 END) as low_quality_restaurants
    FROM restaurant_performance
    GROUP BY City
    
),
opportunity_score AS (
    SELECT *,
        -- Calculate opportunity metrics
        ROUND(budget_options * 100.0 / current_restaurants, 2) as budget_market_share,
        ROUND(premium_options * 100.0 / current_restaurants, 2) as premium_market_share,
        ROUND(high_quality_restaurants * 100.0 / current_restaurants, 2) as quality_market_share,
        
        -- Identify gaps (opportunities)
        CASE 
            WHEN budget_options * 100.0 / current_restaurants < 40 THEN 'Budget Gap'
            WHEN premium_options * 100.0 / current_restaurants < 2 THEN 'Premium Gap'
            WHEN high_quality_restaurants * 100.0 / current_restaurants < 20 THEN 'Quality Gap'
            ELSE 'Saturated Market'
        END as primary_opportunity
    FROM market_gaps
)
SELECT 
    city,
    current_restaurants,
    ROUND(market_quality, 2) as avg_market_rating,
    budget_market_share,
    premium_market_share,
    quality_market_share,
    primary_opportunity,
    CASE 
        WHEN primary_opportunity = 'Budget Gap' AND current_restaurants >= 50 THEN 'High Priority - Budget Expansion'
        WHEN primary_opportunity = 'Premium Gap' AND market_quality >= 3 THEN 'High Priority - Premium Entry'
        WHEN primary_opportunity = 'Quality Gap' THEN 'Medium Priority - Quality Improvement'
        ELSE 'Low Priority - Market Saturation'
    END as investment_recommendation
FROM opportunity_score
ORDER BY current_restaurants DESC, market_quality DESC;





-- =============================================================================
-- 8. COHORT ANALYSIS (Customer Behavior Simulation)
-- Segmentation and behavioral analytics
-- =============================================================================

WITH customer_segments AS (
    SELECT 
		City,
        Restaurant_Name,
        ROUND(AVG(Rating), 1) AS rating,
        SUM(Rating_Count) as rating_count,
        ROUND(AVG(Price_INR), 2) as price,
        -- Simulate customer behavior patterns based on restaurant characteristics
        CASE 
            WHEN SUM(Rating_Count) >= 20000 AND AVG(rating) >= 3.5 THEN 'Loyal High-Value'
            WHEN SUM(Rating_Count) >= 10000 AND AVG(Price_INR) >= 300 THEN 'Premium Seekers'
            WHEN SUM(Rating_Count) >= 1000 AND AVG(Price_INR) <= 200 THEN 'Value Hunters'
            WHEN SUM(Rating_Count) < 500 THEN 'New/Experimental'
            ELSE 'Standard Users'
        END as customer_segment,
        
        -- Calculate engagement metrics
        CASE 
            WHEN SUM(Rating_Count) >= 10000 THEN 'High Engagement'
            WHEN SUM(Rating_Count) >= 5000 THEN 'Medium Engagement' 
            ELSE 'Low Engagement'
        END as engagement_level
        
    FROM swiggy_db.cleaned_swiggy_menu
    GROUP BY City, Restaurant_Name
),
segment_analysis AS (
    SELECT 
        customer_segment,
        engagement_level,
        COUNT(*) as restaurant_count,
        ROUND(AVG(rating), 1) as avg_segment_rating,
        ROUND(AVG(price), 1) as avg_segment_cost,
        ROUND(AVG(rating_count), 1) as avg_review_volume,
        
        -- Calculate customer lifetime value proxy
        ROUND(AVG(rating_count * price * 0.01), 2) as estimated_clv_proxy,
        
        -- Market penetration metrics
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() as market_share_percent
    FROM customer_segments
    GROUP BY customer_segment, engagement_level
),
segment_performance_matrix AS (
    SELECT *,
        -- Performance quadrant analysis
        CASE 
            WHEN avg_segment_rating >= 3.5 AND estimated_clv_proxy >= 10000 THEN 'Star Performers'
            WHEN avg_segment_rating >= 3.5 AND estimated_clv_proxy < 10000 THEN 'Quality Leaders'
            WHEN avg_segment_rating < 3.5 AND estimated_clv_proxy >= 10000 THEN 'Revenue Generators'
            ELSE 'Improvement Opportunities'
        END as performance_quadrant,
        
        -- Growth potential scoring
        ROUND(
            (avg_segment_rating / 5.0 * 40) + 
            (LEAST(estimated_clv_proxy / 2000, 1) * 35) + 
            (market_share_percent / 100 * 25)
        , 2) as growth_potential_score
    FROM segment_analysis
)
SELECT 
    customer_segment,
    engagement_level,
    restaurant_count,
    ROUND(avg_segment_rating, 2) as avg_rating,
    ROUND(avg_segment_cost, 0) as avg_cost,
    ROUND(market_share_percent, 2) as market_share_pct,
    estimated_clv_proxy,
    performance_quadrant,
    growth_potential_score,
    RANK() OVER (ORDER BY growth_potential_score DESC) as growth_rank
FROM segment_performance_matrix
ORDER BY growth_potential_score DESC;



    