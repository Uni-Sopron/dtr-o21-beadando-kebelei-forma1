# dtr-o21-beadando-kebelei-forma1

## About the Project

The project simulates a Formula 1 inspired car race. There are three different models to choose from. Each has advantages but disadvantages as well. The result of a model is an optimal tyre strategy that shows in which lap which tyre compounds are worth using. The goal is to complete the race in the shortest possible time.

<details>
<summary>Example output</summary>
<p>

```
Lap tyres:
Start-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-medium-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-soft-Finish

Total time: 4742.58 second
```

</p>
</details>

The basic data of the race is in the `basic_data.dat` file.

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
glpsol -m model_3.mod -d basic_data.dat -d tyre_change.dat
```
