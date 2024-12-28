## Project Overview

This study examines the relationships between socioeconomic, health, and educational indicators in U.S. counties using data from the County Health Rankings & Roadmaps program and IPUMS. We analyze how factors such as residential segregation, health insurance coverage, access to healthy foods, and region impact life expectancy, and how residential segregation and region affect school funding adequacy. Our findings reveal that life expectancy is influenced by residential segregation and uninsured rates, though these effects are minor compared to the more substantial influence of household income and regional differences. Life expectancy averages are highest in the Northeast, followed by the Midwest, West, and South. Region also plays the most significant role out of all included variables in determining the likelihood of school funding adequacy, with schools in the Northeast and Midwest being far more likely to receive adequate funding than those in the South. Other factors, such as residential segregation, property taxes, and household income, show statistically significant but smaller effects. These results highlight the complex interplay between socioeconomic variables and geographic location in shaping public well-being. By identifying key disparities in health and education, this study underscores the importance of equitable resource allocation and targeted policies to address regional and socioeconomic inequalities.

## Research Questions
1. What is the impact of residential segregation, access to healthy foods, and health insurance coverage on a county’s average life expectancy?
2. Do residential segregation and region impact the likelihood of a school being adequately funded?

## Methodology
### Data Sources
- County Health Rankings & Roadmaps program, associated with the University of Wisconsin Population Health Institute, which consolidates the latest county-level measurements of various population health, economic, demographic, and social factors from the American Community Survey, the USDA Food Environment Atlas, Small Area Income and Poverty Estimates, and other reliable government sources into publicly available datasets every year.
- IPUMS, for median poverty tax data for every county from 2018-2022.
- U.S. Census Bureau’s Regions and Divisions of the United States, which maps every U.S. to one of four geographic regions, and also a division within the regions. This data was loaded into R using this public [repository](https://github.com/cphalpert/census-regions).

### Analytical Frameworks
For our first research question, a multiple linear regression model was fit, regressing average life expectancy on residential segregation index, percentage with limited access to healthy foods, percentage uninsured adults, region, and median household income. Linear regression assumptions were assessed
using diagnostic plots, especially residual vs. fitted and quantile-quantile plots. The adjusted R-squared value was used to evaluate the fit of the model, and the effect of region as an interaction term with residential segregation was evaluated using nested F tests. We also calculated VIF to check for multicollinearity and Cook’s distance to identify influential points.

For our second research question, a binary logistic regression model was fit with school funding adequacy (categorical) as the outcome and residential segregation index, region, median property tax, and median household income as predictors. The model was assessed using a confusion matrix, an ROC curve, and a comparison of deviance between the full model and a reduced model that excluded region as a predictor. VIF and Cook’s distance were again used to evaluate multicollinearity and influential points.

## Key Findings
Based on the multiple linear regression results, residential segregation, percentage of uninsured adults, region, and median household income all showed statistically significant effects on life expectancy, with region having the most substantial impact. Life expectancy is on average 1.96 years higher in the West region compared to the South, 2.92 years higher in the Northeast compared to the South, and 1.92 years higher in the Midwest compared to the South, even when controlling for income, uninsured population, and racial diversity. The percentage of population with limited access to healthy foods predictor was not statistically significant in our model, suggesting that the effect of this environmental factor is minor or intertwined with economic variables, such as income, rather than being a standalone influence. 

In Research Question 2, results showed that region has the greatest impact on school funding adequacy, with schools in the Northeast and Midwest being significantly more likely to receive adequate funding than those in the South. While residential segregation, property taxes, and household income have statistically significant effects, their influence is minimal compared to that of region.

## Limitations
- Missing data, which restricted the dataset to 33 states and reduced the generalizability of our findings.
- Some variables were drawn from different years between 2018 and 2022, requiring us to assume that trends remained consistent over a 1–5 year period and that time was an insignificant factor; however, this may not actually be the case.
