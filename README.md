
#### Player Auction Strategy with SQL Analysis:

1. **High Strike Rate Batsmen:**
   - Identified players with a high strike rate who have faced at least 500 balls.
   - Ensured effective bidding strategies to stay within the budget during the auction.

2. **Consistent Players with Good Average:**
   - Selected players with a good average who have played more than 2 IPL seasons.
   - Created a list of potential biddings while considering budget constraints.

3. **Hard-Hitting Players with Boundary Scoring:**
   - Targeted players with the most runs in boundaries who have played more than 2 IPL seasons.
   - Developed a bidding list ensuring cost-effectiveness in the auction.

4. **Economical Bowlers:**
   - Identified bowlers with a good economy who have bowled at least 500 balls in IPL.
   - Created a list for auction bidding, keeping budget constraints in mind.

5. **Bowlers with Best Strike Rate:**
   - Selected bowlers with the best strike rate who have bowled at least 500 balls in IPL.
   - Developed a bidding list ensuring budget compatibility.

6. **All-rounders with Balanced Batting and Bowling:**
   - Identified all-rounders with the best batting and bowling strike rates who have faced at least 500 balls and bowled a minimum of 300 balls.
   - Created a list for auction bidding while considering budget constraints.

#### Additional & Detailed Analysis:

- **Count of Cities Hosting IPL Matches:**
  - Fetched the count of cities that have hosted an IPL match.

- **Deliveries Table Transformation:**
  - Created a table named `deliveries_v02` with additional column `ball_result` categorizing each ball as boundary, dot, or other.

- **Boundary and Dot Ball Statistics:**
  - Retrieved the total number of boundaries and dot balls from the `deliveries_v02` table.
  - Fetched the total number of boundaries scored by each team.
  - Fetched the total number of dot balls bowled by each team.

- **Dismissal Kinds Statistics:**
  - the total number of dismissals by dismissal kinds where dismissal kind is not NA.

- **Top Bowlers Conceding Extra Runs:**
  - Identified the top 5 bowlers who conceded the maximum extra runs from the `deliveries` table.

- **Year-wise Runs at Eden Gardens:**
  - Fetched the year-wise total runs scored at Eden Gardens and order it in descending order.

- **Table Join and Transformation:**
  - Created a table named `deliveries_v03` with data from `deliveries_v02` and additional columns from the `matches` table (venue and match_date).

- **Venue-wise Total Runs:**
  - Fetched the total runs scored for each venue and order it in descending order.

- **Year-wise Total Runs at Eden Gardens:**
  - Fetched the year-wise total runs scored at Eden Gardens and order it in descending order.

Note :- These SQL queries cover player auction strategy, statistical analysis, and additional data transformations, providing insights for IPL team management and enthusiasts.
