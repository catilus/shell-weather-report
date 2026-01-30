# Weather Report in Shell
Collect daily weather data from wttr.in and compute basic statistics on forecast accuracy using shell.

This project stems from the practice final project from Coursera's *Hands-on Introduction to Linux Commands and Shell Scripting course*.

# Table of Contents
1. [General Overview](#general-overview)
2. [Installation](#installation)
3. [Usage](#usage)
    1. [Overview](#usage-overview)
    2. [Temperature extraction and report generation](#extraction)
    3. [Forecasted Accuracies](#accuracy)
    4. [Statistics](#stats)
    5. [Output examples](#output)
4. [Integration](#integration)
5. [Design Considerations](#design) *TBD*
6. [Testing and Validation](#validation) *TBD*

## 1. General Overview <a name="general-overview"></a>
This command line program allows the user to do a variety of things:
- Pull weather data from [wttr.in](https://wttr.in) for a given city.
- Extract temperatures of interest: current and forecasted (next-day, two-days and three-days). 
- Evaluate forecast accuracy.
- Perform statistics on weekly forecast accuracies.

## 2. Installation <a name="installation"></a>
### 2.1. System Requirements
- `bash`- this program is only supported on Linux and MacOS.
- This program was developed and tested on Ubuntu 24.04.3 LTS.

### 2.2. Installation Instructions
Clone the repository:
```bash
git clone https://github.com/catilus/shell-weather-report.git
cd shell-weather-report
```
Make script executable (for user only):
```bash
chmod 744 *.sh
```
OR
```bash
chmod u+x *.sh
```
These permissions can be changed to make scripts executable to other groups.

### 2.3. Dependencies
- `bash` -- shell support
- `curl` -- scrape weather data from wttr.in
- `grep` -- extract temperature data from weather data
- `sed` -- positional extraction and text normalization
- `less` -- view generated reports

## 3. Usage <a name="usage"></a>
### 3.1. Overview <a name="usage-overview"></a>
Three different scripts can get three different things.

### 3.2. Temperature extraction and report generation <a name="extraction"></a>
This is done by **`rx_poc.sh`** in the following structure:

To run this script, type the following commands from the location of the cloned/downloaded repo:
```shell
cd ./shell-weather-report
./rx_poc.sh
```
The program will:
1. Get weather data from wttr.in for Casablanca, Morocco into `weather_report` file.
2. Extract temperature unit of the weather report for stdout formatting.
3. Extract temperature of interest (includes data validation):
3.1. Observed temperature at time of data fetch.
3.2. Next day forecasted temperature at noon.
3.3. Next 2-days forecasted temperature at noon.
3.4. Next 3-days forecasted temperature at noon.
4. Store local date (of fetched city) and extracted temperatures into `rx_poc.log`.

To view the report:
```bash
less rx_poc.log
```
Improvement ideas:                                                                     
- [ ] Ask for user input of city and country + error handling.                         
- [ ] Add an option to choose unit system (metric or US).
- [ ] Archive downloaded `weather_report` after each call.                             
- [ ] Backup and compress archive on a periodic basis.                                 
- [ ] Check if `weather_report` was generated.                                         
- [ ] Check that `weather_report` was generated for the correct city/country.          
- [ ] Create `rx_poc.log` if it doesn't already exist.                                         
- [ ] If `rx_poc.log` already exist, ask user if they want to keep or start fresh.     
- [ ] If user wants to start fresh, backup existing `rx_poc.log`.                      
- [ ] Add city/country and time to backedup `weather_report` and `rx_poc.log`.         

### 3.3 Forecasted Accuracies <a name="accuracy"></a>  
Evaluation of forecasted accuracies is performed by executing **`fc_accuracy.sh`**. 

The script has the following structure:
1. Extract current temperature and yesterday's forecasted temperature from `rx_poc.log`.
2. Calculate accuracy.
3. Assign a label to the calculated accuracy:

    | Range | Label |
    | ----- | ----- |
    | +/-1 | Excellent |
    | +/-2 | Good |
    | +/-3 | Fair |
    | +/-4 | Poor |

4. Store local date (of fetched city), today's temperature, calculate accuracy and accuracy label into `historical_fc_accuracy.tsv`.

To view the report:
```bash
less historical_fc_accuracy.tsv
```

#### Improvement ideas:
- [ ] Extract not only yesterday's forecasted temperature, but that of the other days to allow more stats to be done.
- [ ] Allow user to calculate accuracy for any pairs (or sets) of temperatures.

### 3.4 Statistics<a name="stats"></a>
Statistics on calculated forecast accuracies are performed by executing **`weekly_stats.sh`**. 

The script has the following structure:
1. Extract calculated accuracies from `historical_fc_accuracy.tsv` for the last seven (7) days.
2. Find the minimum (best) and maximum (worst) accuracies.
3. Display results in the command line.

#### Improvement ideas:
- [ ] Display days associated with best and worst accuracies.
- [ ] Ask user if they want to set the date range on which stats should be done.
- [ ] Add statistics (mean, median, std).

### 3.5 Output examples <a name="output"></a>

## 4. Integration <a name="integration"></a>
Right now, the scripts have to be run by hand by typing the following commands in the command line.
First, navigate to the downloaded folder:
```bash 
cd ./shell-weather-report  
```
Run the scripts:
```bash 
./rx_poc.sh
./fc_accuracy.sh
./weekly_stats.sh 
```

### Important considerations
- `fc_accuracy.sh` will only be run successfully if `rx_poc.log` as a minimum of three lines (including headers).
- `weekly_stats.sh` will only be run successfully if `historical_fc_accuracy.tsv` as a minimum of seven lines (including headers).

#### Improvement ideas:
- [ ] Integrate scripts so `rx_poc.sh` and `fc_accuracy.sh` run together, provided the second scripts has enough data.
- [ ] Run the integration every day at 12PM, time of the city being fetched.

## 5. Design Considerations <a name="design"></a>
### 5.1. User Requirements

### 5.2. Functional Requirements 

### 5.3. Risk Assessment


## 6. Validation and Testing <a name="validation"></a>
This section documents the validation approach taken in this project and the tests being performed.

### 6.1. User input in weather data query
Strategy:
Where do we test user input to ensure that the proper weather data is being pulled (e.g. if entering `Country = USA` and `City = Paris`, the weather report being queried is for *Paris, France* since the `curl` command only takes `City` as a variable)? 
If the user inputs nothing, weather data is queried for the user's local IP.

