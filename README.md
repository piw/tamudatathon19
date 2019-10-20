# tamudatathon19
"Tacos vs. Burritos" project (Goldman Sachs Challenges) on TAMUDatathon 2019

(https://www.kaggle.com/datafiniti/restaurants-burritos-and-tacos)

## Inspiration

Food is the one of the best parts of life to brings everyone together,
and in Texas (or maybe the entire US?) that means **BURITTOS** and **TACOS**.
This project is inspired by a public dataset on Kaggle about taco and burrito restaurants,
to find meaningful insights in our everyday life around these delicious Mexican foods.

## What it does
The data is a list of 19,439 restaurants and similar businesses with menu items containing "burrito" or "taco" in their names,
as provided by Datafiniti's Business Database, and a full schema for the data is available in their
[support documentation](https://datafiniti-api.readme.io/docs/business-data-schema)

Using exploratory data analysis (EDA) and visualization, we bring out the "hot spot" locations,
feature restaurants, and menu highlights with tacos and burritos.

## How we built it
1. Raw taco and burrito restaurant data was imported into [Jupyter notebook](EDA.ipynb) using Pandas, and we did initial EDA
in Pandas to learn the data schema and spot the quality issues in the data.
2. We dropped all columns contains no data or one single unique value (e.g. "country" is always US).
3. The reformatted data was exported from Pandas and imported to a MySQL server for efficient data slicing and analysis.
4. We performed [SQL queries](Datathon.sql) to extract informations on top states, top cities, chain fast food restaurants, authentic Mexican restaurants, and top menu keywords related to taco and burritos.
5. Extracted data was visualized: a) as US heatmaps using GeoPandas in Jupyter [notebook1](Restaurant_Heatmap.ipynb) [notebook2](Restaurant_Taco_Heatmap.ipynb) [notebook3](Restaurant_Burrito_Heatmap.ipynb); b) as top city bar-charts in Excel [spreadsheet](TopCityinState.xlsx); and c) as wordcloud of menu names in Jupyter [notebook](EDA.ipynb).

## Challenges we ran into
* 11% of the data (8,499 records) has city/town name in the "province" column
* Unrealistic price on the menu. Can you believe a taco will cost $1,990?
* Significant ratio of missing data in most of the columns
* Several columns, e.g. “categories”, have multiple entries inserted in one cell.

## Accomplishments that we're proud of
* We leveraged the [U.S. Census public data](https://www.census.gov/data.html) to fix the errors in the "province" column
and *100% attributed the restaurant to correct city and state*.

## What we learned


## What's next for Taco or Burrito, that is the question ...
Based on our investigation, the following issues should be pursued to improve the data quality and gain more insights:
* check for misplaced decimals and other ETL errors in menu prices
* use third-party data sources (such as Yelp, Google, …) or reasonable guess to remediate 
the missing data problem in this dataset.
