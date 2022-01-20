# dtr-o21-beadando-kebelei-forma1

## About the Project
The project simulates a Formula 1 inspired car race.

## Installation and Setup Instructions
### Clone this repo
```bash
git clone https://github.com/Uni-Sopron/dtr-o21-beadando-kebelei-forma1.git
cd dtr-o21-beadando-kebelei-forma1/
```
### Install GLPK
If you are using windows, download [GUSEK](http://gusek.sourceforge.net/gusek.html) (GLPK Under Scite Extended Kit)

GLPK for Ubuntu
```bash
sudo apt-get install glpk-utils
```

## Model 1
### How to start
```bash
glpsol -m model_1.mod -d basic_data.dat
```

## Model 2
### How to start
```bash
glpsol -m model_2.mod -d basic_data.dat -d degradation.dat
```

## Model 3
### How to start
```bash
glpsol -m model_3.mod -d basic_data.dat -d stage.dat
```