---
title: Software Maintainability Prediction by Applying Machine Learning On Open Source Abandonware
author: Terry
date: Feb 23, 2017
...

# Abstract

It takes many years to grow a mature open source community, such as the Ruby
community.  The majority of contributions come in the form of specialized
software packages developed to solve a specific need, and over time, this
collection  evolves into a large third party packages ecosystem.  Many popular
open source software projects are continuously developed and maintained.  But
there are also once popular software components that get abandoned by the
authors, leaving people who depend on them in an unexpected situation.
[IVZ: I'd move the above paragraph to Introduction]

The source code contains all the efforts that went into making the software.
With a typical open source package management system, we can find the source
code of all the packages and associated versions.  In this research, we tried to
find a way to apply machine learning to the source code change history.  The
primary goal of this study was to develop a model for predicting the risk of
abandonware.  The secondary objective was to determine the reasons why some
software projects are abandoned while others are well-maintained.  This work is
based on data obtained from RubyGems.org -- the principal repository of Ruby
packages.  Terabytes of Ruby source code have been explored and analyzed. The
result of this research might not be deterministic because the scope of this
research is limited to source code. The reasons why some authors gave up their
open source projects are not always found in the source code.

# Acknowledgments

# Introduction

As Jack Reeves pointed out in "What is software design" (1992), "the design" of
software is the source code itself. In other words, the source code contains all
the knowledge and efforts that went into creating valuable working software.
Programming languages like Ruby are distributed in the form of source code. We
can find the history of open source software projects from public package
management systems. This research tries to find a way of applying machine
learning to the source code change history in the Ruby package management system
in order to make predictions on software maintainability.

## Scope

The scope of this research is limited to the RubyGems.org package management
system. It contains terabytes of ruby source code. We have created
criteria for "abandoned" and "well-maintained" software, and focused the
analysis on packages that fit those criteria. Both the static state of
projects and their change histories were analyzed. However, the change
history was limited to the versions managed by RubyGems.org. More complete and
detailed change history could be found from the software configuration
management system (SCM). However, the SCM was not within the scope of this
research. [IVZ: is SCM an accepted general term for version control system?]

Simple statistics and machine learning methods were applied to data metrics
extracted from projects' source code. This was done using custom software which
can download and calculate all the metrics based on project's source code in
parallel. The purpose of this software was to automate the data collection
process. But it is more a proof of concept prototype developed without any
intentions for making it a commercially usable tool. It is also not intended to
be generalized to making other predictions based on source code analysis.


## Problem Statement

I'm trying to ask and find the answers to the following two questions:

1. Why some open source software projects are abandoned by their maintainers?
   [IVZ: do you distinguish mainteners and authors?]
2. What makes some open source software projects more maintainable than the others?

Exploration of these two questions will be within the above scope.


## Approach

Several data science methods are used in this work. Massive amount of data from
open source package management system will be processed, analyzed and then used
in conjunction with several machine learning methods to find one or more
predictive models for assessing the chance of maintainability or adandoning of
open source projects.

## Outcomes

The outcomes of this work include:

* A summary of discovered differences between abandoned and well-maintained open source projects.
  This information could be useful to people who care about software maintainability.
* An attempt to prove the theory of using software package change history to
  predict software maintainability.
* The prototype software tool.
* Processed and labeled data in the JSON format.

# Background and review of literature

## Background

Ruby is a popular programming language. It is widely used for development of Web
services and infrastructure automation. There is also a large open source ruby
community. `RubyGems.org` is the place where most ruby developers release their
software packages. Ruby packages are called "gems". At the beginning of 2017,
there were about 13908 gems with 1126308 different versions. A lot of software
developers are working on their gems all the time. In 2016, there were 44 new
gems and 332 new versions of existing gems released per day (Ćilimković, 2017).

With such rich collection of ruby gems, people can do their job much faster.
But depending on an open source library  introduces future risks. Some software
packages are focused on simple things. They tend to stabilize after a period of
active development and do not need much active maintenance subsequently. But
most non-trivial software libraries do need ongoing maintenance to address new
features, fix bugs, and adjust to new environments. When the developers of a
library stop maintaining it, the users who depend on that library often find it
very painful.

* There are 1132 Ruby gems without new versions since 2015, but
  which had been actively maintained for more than ten months before that.
  We labeled them as "abandoned" gems.
* There are also many Ruby gems that have been actively maintained for a long
  time with many releases. From software maintainability perspective, they are
  at least "maintainable" code some releases back from the recent.
  We labeled them as "maintained."
  [IVZ: I'm not sure how to rephrase the above. In the current form
  it is very unclear how "maintained" is defined.]

There could be different reasons why certain Ruby project are abandoned, while
others continue to be maintained. Most developers of ruby gems tend to release
new version often, and RubyGems.org store all versions. Perhaps we can find a
behavioral trace in the history of gem's releases. Ruby libraries are
distributed in the form of source code. If there is a pattern or we can get a
model, then we can use it to evaluate Ruby source code or learn how to increase
software maintainability.

### On maintainability

Software maintainability is an important factor in the cost of owning a
codebase. IEEE defines it as “the ease with which a software system or component
can be modified to correct faults, improve the performance or other attributes,
or adapt to a changed environment” (IEEE, 1990). Here we will try to define
maintainable software from the perspective of the development activity.
Let's consider a software component in a maintained state at a certain point of
time *T*.  If this component continues to be actively maintained to correct
faults, improve the performance or other attributes, for a subsequent period
*P*, then we can say the state of the software at the time *T* has at least some
maintainability. We can also make an assumption that if a software system is not
maintained at *T*, it tends to have less maintainability in the future.
Especially, it is so when there's evidence based on the software development
history before *T* that continuous maintenance is required.

Based on the above assumption, we can label a version of software as
"maintainable" or "not maintainable" by analyzing its release history.

### On open source "Abandonware"

Khong (2007) defined abandonware as copyrighted work that is still owned by
an owner, but because the owner ignored the work, it is no longer commercially
available to the public. One problem caused by abandonware, as pointed out by
Khong (2007) is that some software may need continual support from the vendors
or producers. Many open source software also fit in the definition of
abandonware, that is the source code is still available to the public, but the
owner of the project ignores it.
[IVZ: I'd use author instead of owner above]

Khong (2007) also mentioned, "A related problem of abandonment of computer
software is the unavailability of source codes to correct or modify a computer
program." It is no longer the case for open source abandonware. However, having
the source of origin doesn't solve the problem completely. It still requires
domain knowledge, knowledge of software structure, interest and actual effort to
maintain the software, which the user of the software might not have. And the
original access point (the library server, the version control system) might
still be owned by the original author. In this case it is hard to continue the
project and share maintainance work with others.

In my research of Ruby open source abandonware, I found some projects that have
over a hundred open issues on Github. Some people depending on the software are
desperate for support. Some of the abandonware have tens of pull requests
(offers of bug fixes of new features by other developers) , but the owners just
ignore them. A prominent example is the CanCan Ruby gem created by Ryan Bates.
It was released in 2009 and quickly became very popular (over 6000 stars on
Github as of today). It's an enhancement for the Ruby on Rails framework to
support authorization. Since it was intended to be part of the framework,
projects depending on CanCan tend to have a tight coupling with it. In 2013, all
development activity on Github stopped suddenly, creating a big problem. We can
conclude this from more than eight hundred forks of the CanCan project. Some
people chose to take the source code and maintain it by themselves. Eventually,
a group of people formed the "CanCanCan Community" to continue the "CanCan"
project (https://github.com/CanCanCommunity/cancancan).

Abandonware doesn't always indicate unmaintainable software. For example, "why
the lucky stiff" (2017) is the nickname of a Ruby programmer who was considered
one of the best Ruby programmers in the world (Spolsky 2005). He mythically
disappeared since 2009. It's probably not right to call his legacy
"unmaintainable."
[IVZ: why? is everything this guy wrote still used and maintained by somebody else?]

## Literature Review

Riaz et al. (2009) did a systematic review of software maintainability
prediction and metrics. They found that commonly used maintainability models
were based on algorithmic techniques, and that the methods could be specific to
maintenance type. Size, complexity and coupling are collected at source code
level only. There is a lack of accuracy measures and cross-validation. They also
found that expert judgment plays an important role when designing these metrics.

Riaz et al. (2009) suggested creation of a more robust and reliable software
maintainability prediction models. This is precisely what I'm trying to achieve
in this work. Although the underlying data is also mostly from the source code,
my prediction model includes time scale and uses several metric extraction tools
to avoid prejudice. I intended to use machine learning to replace expert
opinion.

Beller et al. (2016) conducted research on the usage of Automated Static
Analysis Tools (ASATs). In their study, they found that 60% of the most popular
open source projects use ASATs, although they do not embed them as part of their
workflow. This may introduce some bias into my data since it includes some
popular projects, and therefore a fraction of projects may have been already
optimized towards certain tool. However, I'm confident that this will not have a
big impact because I only consider code older than 2015. All static analysis
tools used in this work have many new features since 2015.

My open source Static Analyzer "lizard" has been used in many large projects,
including the ATLAS project at CERN (Kluth, et al. 2016). The ATLAS Experiment
(Anelli et al. 2008) use it to get the cyclomatic complexity metrics in their
C++ and Python code. Lizard supports many other programming languages
including Ruby.

I use the counts of automatically detected "code smells" as part of the data
extracted from projects' source code. Code smells, as defined by Fowler & Beck
(1999), are symptoms of poor design and implementation choices. They are
considered anti-patterns, and consequently, code smells are likely to affect the
maintainability of software. Tufano et al. (2015) found that "Code artifacts
becoming smelly as consequence of maintenance and evolution activities are
characterized by peculiar metrics’ trends." A similar conclusion was reached by
Lozano (2009). Palomba et al. (2013) also used the change history of source code
to detect code smells, similar to the work by Rapu et al. (2004). These paper
gave me the starting points for building maintainability prediction model based
on machine learning. 

Moser et al. (2008)'s research strongly supports the use of source code change
for building predictors of defects. The change data and process-related metrics
contain more information

Data mining the software code change history has been a hot research topic (Ying
et al. 2004) (Zimmermann et al. 2005) (Hassan, 2006, 2008). Palomba has several
reports on mining code change history and code smells (Palomba et al. 2015)
(Palomba et al. 2013) (Tufano, et al .2015). However, the above-mentioned work
did not use machine learning techniques for studing code change history.

There is some very recent research based on machine learning and code change
history. Elish et al. (2015) compared three empirical studies on
predicting software maintainability using ensemble methods. Their work turned
out extremely useful for my own research.
[IVZ: can you say what was actually useful?]

Inspired by Lohn (2016)'s keynote presentation at the Python Conference, I will
also try to apply fractal dimension metrics on the code change history. Fractal
dimension is a complexity ratio showing how details in a pattern changes with
the scale at which it is measured (Mandelbrot 1967). One of Lohn (2016)'s
example is the application of fractal dimension to Firefox crash reports. The
stack trace of a crash report can be regarded as a sequence of offsets in
computer memory. By getting the fractal dimension metrics of these sequences,
Lohn claimed that sometimes he found seemingly unrated [IVZ: unrelated?]
software bugs with similar fractal dimension to have the same cause.

## Theory

**Assumption 1**: We can derive a useful predictive model of abandonware by
applying machine learning to a large variety of metrics generated from the
source code of a vast number of open source projects using a subset of projects
that are labeled as abandoned or well-maintained. This model can be used to
predict the probability for a software projects to become abandonned.

**Assumption 2**: The accuracy of the prediction model should improve if change
history is considered in addition to simple static view of one version of the
software. I assume the change data and process-related metrics contain more
information about the defect distribution in software than the source code
itself (Moser 2008).

**Prototype software**: A prototype software is built to implement and verify
the above assumptions. The software project is hosted at
https://github.com/terryyin/rubygem_digger under the MIT License (Rosen 2005).
[IVZ: is this needed under Theory?]

Hayes (2014)'s data science process model divides the process into raw data
collection, data processing, data cleaning, exploratory data analysis (EDA),
machine learning and the final data product. In my prototype software, each part
may be built with a different programming language.

Raw data collection, data processing, and data cleaning parts were built using
the Ruby programming language. The choice of Ruby was mainly because of the
on the focus on RubyGems. It's easier to use the same programming
language to extract information.
[IVZ: Weak argument. Downloading and data pre-processing should be mostly
language independent. You also say above that your own tool (lizard) handles
multiple languages]

Another reason for choosing Ruby is the Ruby on Rails web service framework
(Bächle & Kirchberg 2007). Downloading, parsing and analyzing the source code of
all the packages on RubyGems requires significant computational resources.
Ruby on Rails allowed me to build a simple distributed computing system with
relative ease.

The exploratory data analysis (EDA), machine learning and the final data product
was developed using Python programming language. The reason for choosing Python
is because of its rich collection of big data and machine learning libraries. I
mainly used the scikit-learn library (Pedregosa et al. 2011) which is built on
top of the NumPy library. Another reason for using Python is the Jupyter
platform (Kluyver et al. 2016).  Jupyter is an interactive platform for creating
reproducible computational workflows.  Scikit-learn library works perfectly in
Jupyter. Jupyter is a nearly perfect EDA platform for me.

In addition to scikit-learn and numpy, Pandas and Matplotlib were used in the
EDA process. The Python code that imports these libraries is:

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sea
%matplotlib inline
```

[IVZ: you need to add specific versions of numpy and scikit-learn somewhere in
the document]

The Python code that imports scikit-learn library:


```python
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier

from sklearn.preprocessing import binarize
from sklearn.cross_validation import train_test_split, cross_val_score
from sklearn import metrics
from sklearn.grid_search import GridSearchCV
```


## Terms

**Data science process** In this work I use the data science process
defined by Hayes (2014). It includes: raw data collection, data processing, data
cleaning, exploratory data analysis (EDA), machine learning and final data
product.

![](process.png)

**Ruby** is a programming language designed by Matsumoto
(2002) in the mid-1990s.

**Ruby on Rails** is a web application framework implemented in Ruby (Bächle et al. 2007)

**Python** is a programming language designed by Van Rossum (2007) in early
1990s. It is currently very popular in data science. It has many open
software tools supporting data processing tasks and machine learning.

**Code Smells** are the symptoms of poor design and implementation choices
(Fowler et al. 1999).

**Software Metrics**:

* **NLOC**: The net length of source code, i.e number of lines of source code
  excluding comments and empty lines. (Gilb 977)

* **Cyclomatic Complexity**: is a measurement of how complicated a software routine is (McCabe 1976).
  It measures the number of linearly-independent paths in the source code.
  It is typically applied at the function or method level.
  I will use CCN for Cyclomatic Complexity Number.

**RubyGems terms**

To avoid confusion, I used the following terms when describing a software package on RubyGems:

* A **Gem** is a software project hosted on RubyGems.org.
  It has a unique name and may have multiple versions.
* A **version** is one snapshot of the code that has a version number.
  We will sometimes also call it a "**Release**"
* A **package** is a cohesive data related to one version of a gem.
  It includes the specification and all the code.
  One thing needs to be emphasized is a package's file extension is `.gem`.


# Analysis and Design

## The working process

I use the data science process defined by Hayes (2014) and tailored it to my own process.

![](myprocess.png)

The steps are:

1. *Ruby gem with versions*: Mirror all the packages from RubyGems.org, create
   the software tool to get the collections information and extract source code
   for any package.
2. *Find gems that can be labeled as abandoned or well-maintained*: It includes
   refining the criteria.
3. *Analyze code*: Generate analysis data from the labeled Ruby gems. It
   includes both the last version of observation and historical versions.
4. *Machine learning*: Apply machine learning tools to select and build a
   classifying model. Unlike prior steps, this step and the following step
   will be done with the Python programming language. (The previous ones are in
   Ruby, for the convenience of working with Ruby gems.)
5. *Regression and model evaluation*: Fine tuning of the classifier and
   selection of features.
6. *Evaluate popular Ruby projects*: Build a usable software tool and use
   it to predict the likelihood of Being abandoned.

## The software structure

### The data processor

The avoid repeated work, interim data are cached with versions. This is a
general ability needed by several different types of data. Below is a UML class
diagram of the prototype software.

![](uml.png)

This class diagram uses the UML notions defined by Larman (2012).

* The `Digger` class defines the process of "digging" the source code.
  It includes a spec for the digging and several `Step`s for the digging work.
* The `Step`s are defined with a common `Step` super class, which is cacheable.
  If a step has been done previously and the spec from the `Digger` didn't change,
  it will use the cached data instead of recalculating everything.
  `Step`s ask the `GemSpecs` to do the real work.
* `GemSpecs` is the collection of all the gems found in the RubyGems mirror and
  all the versions information. It includes tens of thousands of ruby Gems.
* `GemWithHistory` represents a gem, and it's history. It is not just one
  software package, but a list of software packages with different versions.
* `PackageWrapper` represents the package, which is the basic unit in the
  RubyGems library. Source code can be extracted out of a package. The
  `PackageWrapper` knows how to get raw analysis data from the third-party
  static analysis tools. It also knows how to collection extra information from
  Github.com, if the package indicates that it is hosted on github.com.
* `Dispatcher` and `Client` are RESTful APIs implemented in Ruby on Rails.
  The `Dispatcher` communicates with the `Digger` to see which packages need to be
  analyzed, then stores that information in the `WorkingItems` database. 
* When the `Client` requests a job from the `Dispatcher`, the `Dispatcher` will
  get a item from the `WorkingItems`, if there is any. The `Client`s, which are
  running on many physical machines will use the same library to do the analysis
  and submit to the `Dispatcher` when the job is done.
* `Dispatcher` will check the `Digger` for any remaining work.
  If there is no more, the `Digger` will save the data to a file in JSON
  format for further analysis.

The data flows as indicated in the following figure:

![](flow.png)

### EDA and Machine Learning

EDA and machine learning are done using the Python programming language and
scikit-learn library inside the Jupyter platform. The main steps include:

* Data importer to read data from JSON file.
* Simple analysis to get the mean, standard deviation, max and min.
* A framework to evaluate different EDA models.
* A tool to apply machine learning results to do predictions.

# Implementation

## Collecting raw data

RubyGems is a package-management system for Ruby applications and libraries
(Berube 2007). A "gem" is a Ruby application or library being managed.
RubyGems.org is an instance of such a system, and it is the biggest host for
open source Ruby gems. After installing Ruby, a simple command will down and
unpack a Ruby gem of a certain version from the remote server (by default
RubyGems.org):

    gem unpack <gem name> -v<gem version>

But given the network and service speed, it is impractical to fetch the gems
from RubyGems.org. The entire RubyGems.org database can be mirrored using the
open source tool (https://github.com/rubygems/rubygems-mirror). The whole
database is around 300GB as of the beginning of 2017, but after decompression,
it is about 1.4TB and about twenty billion lines of Ruby source code.  Then
using the Ruby Gem library (https://github.com/rubygems/gems), we can get all
the gems specifications, and unpack packages when needed.

### Versions simplification

To simplify and normalize the data, I keep only the last version for a gem in a
month, if there are multiple versions in that month.

After this simplification, I made the assumption that if a gem has more than 10
months with versions, it means they are the kind of software that needs
continuous updates.

### Labeling the data

A gem will be labeled as "abandoned" if it:

* Has more than `maintained_months` months with new [IVZ: latest?] versions
* Has no new releases for two years
* Has more than `min_nloc` NLOC in its last version

A gem will be labeled as "maintained" if it:

* Has more than `well_maintained_months` months with new versions
* Has more than `min_nloc` NLOC in its last version

`well_maintained_months` (20 ~ 32) is a much large number than `maintained_month` (10 ~ 20). 
[IVZ: why use different nb of months?]

### Remove recent months for "well maintained" gems

For the data that is labeled as `maintained`, I remove the last 15 months.  We
know that this software is "maintainable" since it is actually actively
maintained, but we need to compare it with the other group at the same time
point when we suspect that a projects may become abandoned.


### Complicated enough

To further reduce data irregularities, I removed the gems that have less than a
certain number of NLOC.

Different specifications are used to label data.

| index | description | min. months | min. NLOC | Well maintained | Hist. months | ignored recent months |
|---|---|---|---|---|---|---|
| 1| most data| 10| 2000| 20| 20| 10|
| 2| less months| 10| 2000| 20| 12| 12|
| 4| more code| 10| 5000| 20| 20| 10|
| 5| long maintained but stopped| 15| 2000| 20| 20| 10|
| 7| longer maintained for good| 12| 2000| 30| 15| 15|
| 8| balanced| 15| 3000| 30| 10| 15|

It is still quite objective to define which Ruby gem is "abandonware" or "well
maintained". I will compare the results generated by different labeling
specifications.

### Manual confirmation

Using labeling specification index 1, out of 387 abandonned but complicated
enough gems, 199 were found with Github URL as gem's homepage.  Among these
gems, 80 have open issues on Github after the last version was released, which
means there are still needs that are not fulfilled for these gems. But 
maintenance of these gems has stopped.

Here is an incomplete list for gems having at least ten open issues on Github
after the last version was released.

| Index | Gem | Open Issues | Years stopped | URL | Possible Reason For Stopping |
|---|---|---|---|---|---|
| 1 | axlsx | 131 | 3.4 | https://github.com/randym/axlsx | Still actively being developed, but having too many open issues and pull requests. |
| 2 | cancan | 205 | 3.7 | https://github.com/ryanb/cancan | Became very popular when released in 2009 but the author stopped all development activity in 2013. To keep the gem going, the community forked it and created CanCanCan (https://github.com/CanCanCommunity/cancancan). |
| 3 | chronic | 99 | 3.4 | https://github.com/mojombo/chronic | Nearly no development activity for 3 years. |
| 4 | fakeweb | 30 | 6.4 | https://github.com/chrisk/fakeweb | Just stopped. |
| 5 | fnordmetric | 96 | 3.6 | https://github.com/paulasmuth/fnordmetric | Just stopped. Has over 400 forks, but only 6 pull requests. |
| 6 | i18n | 29 | 2.1 | https://github.com/svenfuchs/i18n | Wrong label. Stable popular component. Will have a new release soon. |
| 7 | jsduck | 81 | 3.3 | https://github.com/senchalabs/jsduck | Little development activity. |
| 8 | ooor | 22 | 3.7 | https://github.com/akretion/ooor | Still maintained (38 commits in 2016). But somehow no new release. |
| 9 | redcar | 20 | 5.0 | https://github.com/danlucraft/redcar | Just stopped. |
| 10 | surveyor | 32 | 3.8 | https://github.com/NUBIC/surveyor | Just stopped. |
| 11 | taps | 63 | 4.7 | https://github.com/ricardochimal/taps | Just stopped. |
| 12 | veewee | 86 | 2.3 | https://github.com/jedi4ever/veewee | Code still maintained with about 20 commits each year. With over 800 forks. |
| 13 | webrat | 22 | 6.1 | https://github.com/brynary/webrat | Just stopped. |
| 14 | youtube_it | 22 | 2.5 | https://github.com/kylejginavan/youtube_it | Just stopped. |

Most of the above 14 gems that were checked manually stopped being actively
maintained in a way that would surprise an outsider who depend on the gem with
the following exceptions:

* `i18n` is mistakenly marked as *bad*. It has a new release (January 31, 2017) right after I mirror the RubyGems. It provides internationalization support for Ruby since 2008.
* `axlsx`, `ooor` and `veewee` still have some maintenance activity on their Github repositories. But they have not published any new release for more than two years, and people have to fork their code to make changes.

After manually checking 14 gems, I found 11 of them just stopped in a surprising
way, 3 of them still have development activities, but stopped releasing new
versions despite the many open issues.

## Getting the Static Code Analysis

Static code analyzers generate the basic building blocks for the processed data.

Before making any judgment regarding the usefulness of the metrics, I try to
collect as many of them as possible. The efficiency will be checked later when
doing simple statistics and machine learning. The conclusions can be found
in the part On Static Code Analyzing.

Three open source software tools were employed for static code analysis:
Lizard, RuboCop and Reek.

**Lizard** (Kluth, et al. 2016) is an open source static code analyzer focusing
primarily on cyclomatic complexity counting. It supports a large number of
different programming languages including Ruby. It also has an easy to use
interface for extending its analyzing features. As I am the main author and
owner of the lizard project, new requirements can be added when needed without
waiting.

**RuboCop** (Batsov, 2012) is a Ruby static code analyzer. It reports a large
variety of potential code problems, but mostly focuses on coding styles. It is
hard to prevent a static code analyzer focusing on coding styles to be
opinionated. RuboCop is so opinionated that it even has a `-a` option to
automatically 'correct' some of the problems it discovers. My hope for RuboCop
wasn't high when getting it involved. As mentioned above, I just wanted to get
as much metrics as possible without judgment. But the results surprised me.

**Reek** is a code smell detector for Ruby by Rößner (2008). Ruby is a
dynamically typed programming language (Paulson 2007). It is not as easy to get
the meaning behind the code by a static analyzer compared to statically typed
languages like Java. A side effect of this research was evaluation of the
efficiency of Reek in discovering meaningful code smells.

### Distributed Computing

There are twenty billion lines of code in the RubyGems database. After removing
the less frequently updated gems, considering only one version per month and
removing unwanted months, there is still nearly a billion lines of code to be
processed by static analyzers. It would take several days to process this data
once. An update of the static analyzis configuration might require to go through
the whole data processing several times. In fact, since this work was done as
exploratory data analysis, I had to run through the process tens of times to
retrieve new data and fix bugs.

A simple client/server style distributed computing system has been developed to
accelerate the computing using Ruby on Rails.

### Output of the data processing and cleaning

The processed data will be stored in a JSON file that contains the spec for
labeling, information about every gem including its label, version and all the
metrics from the static analyzers.

For each labeling spec, two JSON files will be generated. One containing only
the last version of the gem; the other containing multiple versions. The first
one is used for machine learning based on static data; the latter one is for
mining the dynamic data. Loading data from the first JSON file is done as
follows:

```python
from learner2 import RubygemLearner, Trainer
import json

fn = 'RubygemDigger--Steps--GenerateJsonForLastVersions--1.data.json'
with open(fn) as f: data = json.load(f)
simple_analysis = data["simple_analysis"]
keys = simple_analysis.keys()
d = data["data"]

learner = RubygemLearner(fn)  # [IVZ: learner is not needed here]

df = pd.io.json.json_normalize(d)

# fix column names for later use.
old_new_cols = {}
for name in df.columns:
    if name.startswith('stat'):
        old_new_cols[name] = name.split('.')[1]

df.rename(columns=old_new_cols, inplace=True)
df.head()
```

<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>label</th>
      <th>name</th>
      <th>Attribute</th>
      <th>BooleanParameter</th>
      <th>ClassVariable</th>
      <th>ControlParameter</th>
      <th>DataClump</th>
      <th>DuplicateMethodCall</th>
      <th>FeatureEnvy</th>
      <th>InstanceVariableAssumption</th>
      <th>...</th>
      <th>metrics_perceivedcomplexity</th>
      <th>nloc</th>
      <th>nloc_rate</th>
      <th>performance_</th>
      <th>reek_total</th>
      <th>security_</th>
      <th>style_</th>
      <th>total</th>
      <th>warning_count</th>
      <th>version</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>maintained</td>
      <td>actionwebservice</td>
      <td>4.284949</td>
      <td>0.357079</td>
      <td>0.000000</td>
      <td>1.785395</td>
      <td>1.249777</td>
      <td>36.779147</td>
      <td>7.498661</td>
      <td>7.855740</td>
      <td>...</td>
      <td>1.249777</td>
      <td>5601</td>
      <td>0.24</td>
      <td>0.535619</td>
      <td>164.792001</td>
      <td>0.000000</td>
      <td>62.131762</td>
      <td>0.714158</td>
      <td>6.248884</td>
      <td>1.2.6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>maintained</td>
      <td>active_metadata</td>
      <td>3.319109</td>
      <td>1.422475</td>
      <td>0.474158</td>
      <td>0.948317</td>
      <td>0.000000</td>
      <td>23.233760</td>
      <td>2.844950</td>
      <td>6.638217</td>
      <td>...</td>
      <td>0.948317</td>
      <td>2109</td>
      <td>0.03</td>
      <td>0.000000</td>
      <td>83.451873</td>
      <td>2.370792</td>
      <td>84.400190</td>
      <td>3.319109</td>
      <td>1.422475</td>
      <td>0.8.9</td>
    </tr>
    <tr>
      <th>2</th>
      <td>maintained</td>
      <td>acts_as_ferret</td>
      <td>2.336449</td>
      <td>1.298027</td>
      <td>1.817238</td>
      <td>1.038422</td>
      <td>0.778816</td>
      <td>100.467290</td>
      <td>7.268951</td>
      <td>6.230530</td>
      <td>...</td>
      <td>1.557632</td>
      <td>3852</td>
      <td>0.12</td>
      <td>0.259605</td>
      <td>218.068536</td>
      <td>0.259605</td>
      <td>84.112150</td>
      <td>0.000000</td>
      <td>4.932503</td>
      <td>0.5.4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>maintained</td>
      <td>adapi</td>
      <td>4.763099</td>
      <td>1.504136</td>
      <td>0.501379</td>
      <td>1.504136</td>
      <td>0.000000</td>
      <td>21.308599</td>
      <td>1.754826</td>
      <td>4.011030</td>
      <td>...</td>
      <td>2.256205</td>
      <td>3989</td>
      <td>0.47</td>
      <td>0.250689</td>
      <td>68.187516</td>
      <td>0.501379</td>
      <td>61.920281</td>
      <td>1.504136</td>
      <td>5.264477</td>
      <td>0.2.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>maintained</td>
      <td>adaptation</td>
      <td>2.103492</td>
      <td>0.000000</td>
      <td>0.841397</td>
      <td>2.103492</td>
      <td>1.262095</td>
      <td>38.283551</td>
      <td>9.255364</td>
      <td>4.206984</td>
      <td>...</td>
      <td>3.786285</td>
      <td>2377</td>
      <td>0.28</td>
      <td>3.365587</td>
      <td>161.968868</td>
      <td>3.365587</td>
      <td>121.161127</td>
      <td>3.365587</td>
      <td>8.834666</td>
      <td>1.0.1</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 57 columns</p>
</div>

All the metrics are listed as below.

```python
reek_columns =[
 'Attribute','BooleanParameter','ClassVariable','ControlParameter',
 'DataClump','DuplicateMethodCall','FeatureEnvy','InstanceVariableAssumption',
 'IrresponsibleModule','LongParameterList','LongYieldList',
 'ManualDispatch','ModuleInitialize','NestedIterators','NilCheck',
 'PrimaDonnaMethod','RepeatedConditional','SubclassedFromCoreClass',
 'TooManyConstants','TooManyInstanceVariables','TooManyMethods',
 'TooManyStatements','UncommunicativeMethodName','UncommunicativeModuleName',
 'UncommunicativeParameterName','UncommunicativeVariableName',
 'UnusedParameters','UtilityFunction',
 'reek_total'  # the total number of all reek warnings per KNLOC
]
lizard_columns = [
 'avg_ccn',        # average cyclomatic complexity number
 'avg_nloc',       # average NLOC per function
 'avg_token',      # average number of token per function
 'fun_count',
 'fun_rate',       # percentage of functions that are considered complicated
 'warning_count',  # warning count per KNLOC
]

rubocop_columns = [
 'style_',               # the sum of all coding style warnings per KNLOC.
                         #    there are about 200 different style warnings
 'lint_',                # the sum of all lint warnings per KNLOC
 'lint_duplicate',
 'metrics_',             # the sum of all metrics warnings per KNLOC
 'metrics_abcsize','metrics_blocklength','metrics_blocknesting',
 'metrics_classlength','metrics_cyclomaticcomplexity','metrics_linelength',
 'metrics_methodlength','metrics_modulelength','metrics_parameterlists',
 'metrics_perceivedcomplexity',
 'total',                # the total number of all rubocop warnings per KNLOC
 ]
```

## Simple statistics

After getting the labeled data, I started with simple statistics to see if would
already provide any useful information. To make data comparable, I normalized
all counts using KNLOC, and then compared the mean and standard deviation of all
the metrics. At this point, the "maintained" data already excluded the most
recent 10 to 18 months, which indicates that they are really "maintainable." And
the simple statistics are done on the metrics obtained from the latest version
in our data collection.

From Appendix B we can see that the "maintained" average metrics are better
compared to the "abandoned" in almost all the areas. It indicates at least some
sanity in the labeling. But the standard deviation of most of the metrics makes
it hard to make any sense using the singular metrics.

I developed a simple method to calculate the error rate of each field alone:


```python
def error_rate(field):
    return  - abs(improved_rate(field)) /average_stddev_percent(field)

def improved_rate(field):
    return (field["abandoned"]["avg"] - field["maintained"]["avg"]) * 100 / field["maintained"]["avg"]

def stddev_percent(data):
    return data["stddev"] * 100 / data["avg"]

def average_stddev_percent(field):
    return (stddev_percent(field["maintained"]) + stddev_percent(field["abandoned"])) / 2
```

Then use the `error_rate` function to get the top 10 metrics:


```python
def print_label(name, f):
    print("   %s:\tavg: %6.1f\tstddev: %6.1f\tstddev percent:%6.1f%%" %(name, f[name]["avg"], f[name]["stddev"], stddev_percent(f[name])))
    # [IVZ: no need for 3 digits of precision]
    
impacts = {k: error_rate(simple_analysis[k]) for k in keys}

for key in (sorted(impacts.items(), key=lambda x: x[1]))[:10]:
    k = key[0]
    f = simple_analysis[k]
    print("Metrics: %s\tImprovement:%6.1f%%\tError rate:%6.1f%%" % (key[0],improved_rate(f), key[1]))
    for name in ('maintained', 'abandoned', 'with_issues'):
        print_label(name, f)

```

    Metrics: style_	Improvement:  24.8%	Error rate:  -0.5%
       maintained:	avg: 48.401	stddev: 26.349	stddev percent:  54.4%
       abandoned:	avg: 60.395	stddev: 28.462	stddev percent:  47.1%
       with_issues:	avg: 56.487	stddev: 30.394	stddev percent:  53.8%
    Metrics: lint_	Improvement:  26.6%	Error rate:  -0.5%
       maintained:	avg:  6.688	stddev:  4.296	stddev percent:  64.2%
       abandoned:	avg:  8.467	stddev:  4.570	stddev percent:  54.0%
       with_issues:	avg:  6.913	stddev:  3.918	stddev percent:  56.7%
    Metrics: metrics_	Improvement:  20.1%	Error rate:  -0.3%
       maintained:	avg:  6.766	stddev:  4.183	stddev percent:  61.8%
       abandoned:	avg:  8.123	stddev:  4.529	stddev percent:  55.8%
       with_issues:	avg:  7.851	stddev:  5.327	stddev percent:  67.8%
    Metrics: lint_duplicate	Improvement:  77.8%	Error rate:  -0.3%
       maintained:	avg:  0.070	stddev:  0.184	stddev percent: 264.7%
       abandoned:	avg:  0.124	stddev:  0.263	stddev percent: 212.7%
       with_issues:	avg:  0.055	stddev:  0.103	stddev percent: 188.1%
    Metrics: ClassVariable	Improvement:  66.3%	Error rate:  -0.3%
       maintained:	avg:  0.508	stddev:  1.074	stddev percent: 211.3%
       abandoned:	avg:  0.846	stddev:  1.909	stddev percent: 225.8%
       with_issues:	avg:  0.805	stddev:  1.021	stddev percent: 126.8%
    Metrics: metrics_perceivedcomplexity	Improvement:  26.3%	Error rate:  -0.3%
       maintained:	avg:  0.770	stddev:  0.765	stddev percent:  99.3%
       abandoned:	avg:  0.973	stddev:  0.881	stddev percent:  90.5%
       with_issues:	avg:  1.106	stddev:  0.884	stddev percent:  79.9%
    Metrics: metrics_cyclomaticcomplexity	Improvement:  24.8%	Error rate:  -0.3%
       maintained:	avg:  0.837	stddev:  0.817	stddev percent:  97.7%
       abandoned:	avg:  1.044	stddev:  0.933	stddev percent:  89.3%
       with_issues:	avg:  1.036	stddev:  1.074	stddev percent: 103.7%
    Metrics: metrics_classlength	Improvement:  23.0%	Error rate:  -0.2%
       maintained:	avg:  0.701	stddev:  0.703	stddev percent: 100.3%
       abandoned:	avg:  0.862	stddev:  0.792	stddev percent:  91.9%
       with_issues:	avg:  1.082	stddev:  0.954	stddev percent:  88.2%
    Metrics: performance_	Improvement:  23.3%	Error rate:  -0.2%
       maintained:	avg:  0.865	stddev:  0.847	stddev percent:  98.0%
       abandoned:	avg:  1.066	stddev:  1.051	stddev percent:  98.6%
       with_issues:	avg:  1.202	stddev:  1.105	stddev percent:  92.0%
    Metrics: metrics_abcsize	Improvement:  19.7%	Error rate:  -0.2%
       maintained:	avg:  1.019	stddev:  0.945	stddev percent:  92.7%
       abandoned:	avg:  1.219	stddev:  1.092	stddev percent:  89.5%
       with_issues:	avg:  1.187	stddev:  1.023	stddev percent:  86.2%

[IVZ: it'd be good to have the above inside a table]

```python
import json
fn = 'RubygemDigger--Steps--GenerateJsonForLastVersions--1.data.json'
with open(fn) as f: data = json.load(f)
simple_analysis = data["simple_analysis"]
keys = simple_analysis.keys()
d = data["data"]

df = pd.io.json.json_normalize(d)
df = df[df["stat.avg_nloc"]<20]
abdf = df[df["label"]=="abandoned"]
mtdf = df[df["label"]=="maintained"]
x = np.random.randn(100, 2)
field = 'stat.style_'
for k in (sorted(impacts.items(), key=lambda x: x[1]))[:10]:
    field='stat.'+k[0]
    plt.figure(field)
    plt.title(field)
    means = np.array([mtdf[field].mean(), abdf[field].mean()])
    maxes = np.array([mtdf[field].max(), abdf[field].max()])
    mins = np.array([mtdf[field].min(), abdf[field].min()])
    std = np.array([mtdf[field].std(), abdf[field].std()])
    plt.xticks(np.arange(2), ['maintained', 'abandoned'])

    # create stacked errorbars:
    plt.errorbar(np.arange(2), means, std, fmt='ok', ecolor=['green', 'red'], lw=20)
    plt.errorbar(np.arange(2), means, [means - mins, maxes - means],
                 fmt='.k', ecolor=['green','red'], lw=2)
    plt.xlim(-1, 2)
```


![png](output_41_0.png)

![png](output_41_1.png)

![png](output_41_2.png)

![png](output_41_3.png)

![png](output_41_4.png)

![png](output_41_5.png)

![png](output_41_6.png)

![png](output_41_7.png)

![png](output_41_8.png)

![png](output_41_9.png)


It was surprising to find `style_` at the top of the list. `style_` is the sum
of all coding style issues detected by RuboCop. The "abandoned" gems have 25%
more coding style warnings compared to the well-maintained ones. The 
standard deviation of 50% is still relatively small.

Similarly, the second biggest single factor is `avg_ccn`, which is the average
cyclomatic complexity per function. RuboCop's `metrics_perceivedcomplexity` and
`metrics_cyclomaticcomplexity` are also in the top ten metrics, but both have
68% error rate. It is probably because the default configuration for cyclomatic
complexity in RuboCop is too high, 7 for perceived complexity and 6 for
cyclomatic complexity.

Reek doesn't perform very well except `reek_total` which is the total number of
Reek warnings per KNLOC. One of the Reek metrics that seems to make an impact is
`DuplicateMethodCall`, but it has 69% error rate. As Martin (2009) famously said:
"duplication is perhaps the root cause of all evils in software." Reek seems to
perform  well with the particular collection of "abandoned" projects which still
have issues on Github.

The above result might suffer from the accuracy of the labeling if we want to
approximate "long abandoned" software to "unmaintainable" software. When using
different labeling specifications, the results are slightly different, as listed
below. But the "maintained" ones are consistently better compared to the
"abandoned" ones, with an exception for `Reek Total` with spec 4.

| Spec Index | Style | Avg CCN | Lint | Metrics | Reek Total |
|---|---|---:|---:|---:|----:|----:|
|1| 48.4/60.4 | 1.76/1.81 | 6.69/8.46 | 6.77/8.12 | 101/110 |
|3| 48.8/61.0 | 1.79.1.81 | 6.75/8.62 | 6.74/8.25 | 104/111 |
|4| 31.3/35.7 | 1.76/1.79 | 4.43/5.37 | 3.88/3.95 | 102/100 |
|5| 43.3/58.8 | 1.80/1.85 | 5.86/8.18 | 5.81/7.80 | 103/111 |
|7| 47.0/60.0 | 1.81/1.81 | 65.3/84.0 | 6.40/8.20 | 106/111 |
|8| 40.2/45.6 | 18.1/18.5 | 57.4/62.6 | 5.23/5.40 | 104/109 |

### Machine Learning for code metrics without change history

The next step is to apply machine learning tools to our data.  The goal is to
develop a prediction model for abandonware by splitting the labeled data into
training and evaluation (test) datasets. The source code is listed in Appendix
C. By using only the latest gem version in our collection, we can apply machine
learning to the static state of the software code. The JSON file name that
begins with `RubygemDigger--Steps--GenerateJsonForLastVersions--` is the one
record per gem data file.

```python
fn = 'RubygemDigger--Steps--GenerateJsonForLastVersions--1.data.json'
learner = RubygemLearner(fn)
trainer = Trainer(learner)
```

#### Classify using kNN

I first tried the k-nearest neighbors algorithm (Shakhnarovich 2006) using the
`KNeighborsClassifier` class from scikit-learn and compared classification
accuracy with increasing number of neighbours from 1 to 30.

```python
nb_range = np.arange(1, 31)
a_scores = []

for nb in nb_range:
    model = KNeighborsClassifier(n_neighbors=nb)
    a_scores.append(trainer.train_and_test(model))
    
plt.plot(nb_range, a_scores, 'o-')
plt.ylabel('Testing accuracy')
plt.xlabel('k neighbours')
```

![png](output_48_2.png)


#### More Algorithms

Prediction accuracy using kNN did not improve a lot with increased number of
neighbors. The best it can get is around 60%. Therefore, I tried applying other
machine learning methods provided by scikit-learn: 

| index | Learning Algorithm |
|---|---|
|AG1 |    LogisticRegression |
| AG2 |    DecisionTreeClassifier |
| AG3|    BaggingClassifier with DecisionTreeRegressor |
| AG4|    BaggingClassifier with LogisticRegression |
| AG5|    BaggingClassifier with KNeighborsClassifier |
| AG6|    RandomForestClassifier with n_estimators=20 |
| AG7|    AdaBoostClassifier with n_estimators=100 |
| AG8|    GradientBoostingClassifier with n_estimators=100 |
| AG9|    LinearSVC |
| AG10|    MLPClassifier |


| | AG1 | AG2 | AG3 | AG4 | AG5 | AG6 | AG7 | AG8 | AG9 | AG10 | Average |
|--|--|--|--|--|--|--|--|--|--|--|
| Spec 1| 0.618| 0.552| 0.614| 0.613| 0.575| 0.609| 0.614| 0.601| 0.616| 0.626| 0.604 |
| Spec 3| 0.622| 0.590| 0.584| 0.617| 0.585| 0.612| 0.620| 0.599| 0.630| 0.611| 0.607 |
| Spec 4| 0.622| 0.568| 0.589| 0.625| 0.590| 0.609| 0.610| 0.594| 0.607| 0.580| 0.599 |
| Spec 5| 0.617| 0.554| 0.581| 0.615| 0.595| 0.623| 0.611| 0.585| 0.632| 0.602| 0.601 |
| Spec 7| 0.611| 0.556| 0.600| 0.620| 0.606| 0.603| 0.604| 0.606| 0.612| 0.610| 0.603 |
| Spec 8| 0.626| 0.551| 0.583| 0.616| 0.575| 0.608| 0.599| 0.607| 0.603| 0.591| 0.596 |
| **Average** | 0.619| 0.562| 0.592| 0.618| 0.588| 0.611| 0.610| 0.599| 0.617| 0.603| **0.602** |

The table above shows that no combination of labeling specification and
algorithm leads to a much higher accuracy rate. All algoritms perform within 55%
to 63% accurary. The decision tree classifier seems to have the worst
performance with our data.


### Machine Learning for code metrics with change history

While the first machine learning result was unsatisfactory, I moved on to
trying to add dynamic data (change history) to see if it helps with
prediction modeling (Moser 2008).

One potential solution would be to choose a sequence labeling algorithm (Nguyen
et al. 2007). However, I decided to begin with something simpler. I used the
same algorithm as with the code metrics without change history, but with some
additional data fields and enhanced prediction method.

Assume the last version of a gem has the metrics: `V(0) = {v(0).m1, v(0).m2 ... v(0).mn}`,<br>
and a version of the gem `x` month ago has: `V(-x) = {v(-x).m1, v(-x).m2 ... v(-x).mn}`,<br>
then we can have a record for that version including `{V(-x), V(0) - V(-x), age: x}`
and give it the same label as `V(0)`. It indicates that a version of gem has the metrics
`V(-x)` after `x` months of maintenance it gained `V(0) - V(-x)`,
then became abandoned or still maintained.

![](data.png)

The ensemble technique employed here is bagging, as proposed by Elish et al.
(2015). Bagging is a short name for bootstrap aggregating (Breiman 1996)

| Model | Lizard | RuboCop | Reek | All but no delta | Altogether |
|---|---:|---:|---:|---:|---:|
| LogisticRegression() | 0.655 | 0.645 | 0.649 | 0.653 | 0.650 |
| kNN | 0.623 | 0.615 | 0.631 | 0.623 | 0.614 |
| ensemble_bagging_with(DecisionTreeRegressor()) | 0.595 | 0.673 | 0.560 | 0.589 | 0.573 |
| ensemble with kNN | 0.673 | 0.672 | 0.673 | 0.672 | 0.670 |
| ensemble with LR | 0.674 | 0.672 | 0.679 | 0.670 | 0.659 |

[IVZ: neeed to discuss the results in the table above] 

One issue here is that the data is quite redundant. Metrics do not change very
much every month, and the data for each month is not too different. When using
random train/test splitting, the training and the testing sets still have quite
redundant information. That could lead to incorrect accuracy. So I had to do
manual splitting to make sure that the sequence from one gem does not end up in
both the training and testing sides (See the `my_train_test_split` method in
Appendix C).

After classifier training, the prediction behavior also changes. For a
gem with multiple versions, the record for each version is predicted
respectively. Then the final prediction depends on the consolidated result of
all the predictions (See the `predict_sequence` method in Appendix C).

Below is the accuracy result for difference machine learning algorithms with
different labeling specs.

| | AG1 | AG2 | AG3 | AG4 | AG5 | AG6 | AG7 | AG8 | AG9 | AG10 | Average |
|--|--|--|--|--|--|--|--|--|--|--|
| Spec 1 | 0.622| 0.562| 0.590| 0.608| 0.601| 0.616| 0.604| 0.592| 0.605| 0.591| 0.599 |
| Spec 3 | 0.623| 0.556| 0.585| 0.619| 0.614| 0.616| 0.601| 0.608| 0.623| 0.573| 0.602 |
| Spec 4 | 0.616| 0.583| 0.580| 0.600| 0.591| 0.608| 0.629| 0.617| 0.610| 0.592| 0.603 |
| Spec 5 | 0.597| 0.586| 0.602| 0.603| 0.580| 0.621| 0.612| 0.603| 0.616| 0.583| 0.600 |
| Spec 7 | 0.620| 0.568| 0.597| 0.614| 0.581| 0.624| 0.598| 0.608| 0.632| 0.585| 0.603 |
| Spec 8 | 0.631| 0.574| 0.617| 0.606| 0.576| 0.605| 0.601| 0.612| 0.601| 0.579| 0.600 |
| **Average** | 0.618| 0.571| 0.595| 0.608| 0.590| 0.615| 0.608| 0.607| 0.614| 0.584| **0.601** |

# Results and prediction

We failed to find a combination of data labeling strategy and a machine learning
algorithm to do meaningful prediction of abandonware. The prototype software we
build is capable of using the model to do prediction, but it is not useful
unless we have prediction accuracy of at least 75%.

This doesn't mean we totally failed in this experiment. The simple analysis
still shows there are consistent differences between the labeled data. But there
is too much noise in the data, and we have not found the best algorithm yet.

# Conclusions

Based on the results of simple statistics and machine learning, we can see that
the is some commonality among the well maintained and abandoned open source
software at least in the Ruby community. However, the accuracy of the result is
not good enough to make a precise prediction. From my research, we can at least
draw the following conclusions.

## Coding style matters, complexity matters

The biggest finding is not from complicated machine learning or mining the
change history. Using just averaging and the standard deviation, we can see the
well-maintained gems have 25% less coding style warnings.  "Attractive things
work better…" as explained by Norman (2005) in his Emotional Design, is not a
myth because we are all humans. In the end, there might be more emotional
reasons explaining why people give up maintaining open source software they
were once passionate about.

Cyclomatic complexity remains a very relevant static code analysis metrics when
looking at abandoned and maintained software.

## Automatically detected code smells matters, but the results need improvement

We can see that the overall amount of code smells detected from the abandoned
software is higher than the well-maintained ones. However, none of the
individual code smells has significant impact on the classification.
`TooManyStatements` has greater impact compared to the others. But it is again
more about style than the code structure. I believe this doesn't make the
concept of "code smells" less useful, but we can see that automatic code smell
detection for dynamically typed languages like Ruby still need a lot of
improvement.


## Machine learning can be used to predict abandonware, to some degree

With more specific criteria (e.g. Spec 4 and 8) to label the `maintained` and
`abandoned` gem, we can get better prediction accuracy than generic spec (e.g.
Spec 1). Similar to Elish et al. (2015)'s conclusion that ensemble methods
perform better than LR and kNN. Also, I found that using change history improved
the prediction result, similar to Moser et al. (2008) suggestion.


## Limitation of this research

The well-maintained software projects probably use some of the static analyzers
already. As Beller et al (2016) discovered that 60% of the popular open source
projects use some sort of static analysis tool. However, lizard is not known in
the Ruby community; both Rubocop and Reek has been developed actively in the
recent years. Most of the warnings they produce did not exist before the version
we examined. The impact on prediction accuracy might be bigger when predicting
more recent Ruby software as Rubocop is getting more popular among the Ruby
developers.

The change metrics I have is simply get the ago [IVZ: age?] and the delta of
each metrics. Perhaps some other metrics e.g. number of changed lines, test rate
or the number of authors can improve it. Also, there must be better sequence
labeling technique. Some gems might just need occasional typo fix, update the
version of dependencies or other trivial maintenance chores.

In the end, the "on-line" information we can find in the code history is only
part of the story of an abandoned Ruby gem. The off-line reasons for open source
developers to give up their once exciting project are not considered here. As
the mysteriously disappeared Ruby developer, "why the lucky stiff"'s last
message on twitter said: "programming is rather thankless. u see your works
become replaced by superior ones in a year. unable to run at all in a few more."
(why the lucky stiff, 2017)


## Recommendations / Prospects  for Future Research / Work

Similar works can be done for the Python Package Index (Van Rossum 2007),
JavaScript npm (Wittern et al. 2016) and many other package management systems
for open source software.

In my processed data, I use the "age" until a software component became
"abandoned" or still "maintainable" as a feature. Perhaps future research can
use the age as indicator for how far the state of the observed code base is away
from being abandoned.




share the json file

Use lower max for RuboCop cyclomatic complexity and perceived complexity.
Sequence labeling

instead of using binary label

use age as label
