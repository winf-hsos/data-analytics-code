# Data Analytics Code Examples

This repository contains code examples for my courses on data analytics with R and Python.

## Overview

The code is structured into folders, each folder adressing a specific aspects of exploratory data analysis:

- [intro](intro): Small cases to introduce the topic of exploratory data analysis (currently Monty Hall Problem, R Murder Mystery)
- [part_01](part_01)

## Setup a virtual R environment

You first need to install the `renv` package in your global R installation, if you don't have it yet.

```
install.packages("renv")
```

Then, you can initialize a new virtual R environment in your project folder. Open the R console in Positron (or RStudio) and type:

```
renv::init()
```

This will create a new folder `renv/` in your project root. Also, a new file `.Rprofile` is added. This file is executed when you open your project and it takes care of activating your virtual R environment on startup. So next time you open Positron (or RStudio), the environment should be activated for you.

You can check this with:

```
renv::project()
```

If this returns the value `NULL`, then your environment is not active currently. If it returns the path of your current project, then it is active.

You can manually activate it the virtual R environment:

```
renv::activate()
```

And if you want to manually deactivate it:

```
renv::deactivate()
```` 


[![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg