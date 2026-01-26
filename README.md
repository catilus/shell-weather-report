# Weather report generation in Shell
This project stems from the practice final project from Coursera's *Hands-on Introduction to Linux Commands and Shell Scripting course*.

## 1. Concept
The following scripts do the following:
- pull weather data from [wttr.in]wttr.in for a given city. 
- extract temperatures of interest (current and forecasted). 
- evaluate forecast accuracy.
- perform statistics on weekly forecast accuracies.

## 2. Scripts
### Extraction of temperatures and building of the report
This is done by **`rx_poc.sh`** in the following structure:

#### Now:
1. Get weather data from wttr.in for Casablanca, Morocco into `weather_report` file.
2. Extract temperature unit of the weather report for stdout formatting.
3. Extract temperature of interest (includes data validation):
3.1. Observed temperature at time of data fetch.
3.2. Next day forecasted temperature at noon.
3.3. Next 2-days forecasted temperature at noon.
3.4. Next 3-days forecasted temperature at noon.
4. Store local date (of fetched city) and extracted temperatures into `rx_poc.log`.

#### Improvement ideas:
- [ ] Ask for user input of city and country + error handling.
- [ ] Archive downloaded `weather_report` after each call.
- [ ] Backup and compress archive on a periodic basis.
- [ ] Check if `weather_report` was generated.
- [ ] Check that `weather_report` was generated for the correct city/country.
- [ ] Create `rx_poc.log` if it doesn't already exist.
- [ ] If `rx_poc.log` already exist, ask user if they want to keep or start fresh.
- [ ] If user wants to start fresh, backup existing `rx_poc.log`.
- [ ] Add city/country and time to backedup `weather_report` and `rx_poc.log`.

### Evaluation of accuracy of forecasted accuracies  
This is done by **`fc_accuracy.sh`** using the following structure:

#### Now:
1. Extract current temperature and yesterday's forecasted temperature from `rx_poc.log`.
2. Calculate accuracy.
3. Assign a label to the calculated accuracy:
| Range | Label |
|:-----:|:-----:|
| +/-1 | Excellent |
| +/-2 | Good |
| +/-3 | Fair |
| +/-4 | Poor |
4. Store local date (of fetched city), today's temperature, calculate accuracy and accuracy label into `historical_fc_accuracy.tsv`.

#### Improvement ideas:
- [ ] Extract not only yesterday's forecasted temperature, but that of the other days to allow more stats to be done.
- [ ] Allow user to calculate accuracy for any pairs (or sets) of temperatures.

### Statistics on accuracies 
This is done by **`weekly_stats.sh`** using the following structure:

#### Now:
1. Extract calculated accuracies from `historical_fc_accuracy.tsv` for the last seven (7) days.
2. Find the minimum (best) and maximum (worst) accuracies.
3. Display results in the command line.

#### Improvement ideas:
- [ ] Display days associated with best and worst accuracies.
- [ ] Ask user if they want to set the date range on which stats should be done.
- [ ] Add statistics (mean, median, std).

## 3. Integration
Right now, the scripts have to be run by hand by typing the following commands in the command line.
First, navigate to the downloaded folder:
``` cd ./shell-weather-report  ```
Run the scripts:
``` ./rx_poc.sh ```
``` ./fc_accuracy.sh ```
``` ./weekly_stats.sh ```

### Important considerations
- `fc_accuracy.sh` will only be run successfully if `rx_poc.log` as a minimum of three lines (including headers).
- `weekly_stats.sh` will only be run successfully if `historical_fc_accuracy.tsv` as a minimum of seven lines (including headers).

#### Improvement ideas:
- [ ] Integrate scripts so `rx_poc.sh` and `fc_accuracy.sh` run together, provided the second scripts has enough data.
- [ ] Run the integration every day at 12PM, time of the city being fetched.



