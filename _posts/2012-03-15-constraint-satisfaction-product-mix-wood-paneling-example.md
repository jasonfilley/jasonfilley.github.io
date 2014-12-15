---
layout: post
title: Constraint Satisfaction - Product Mix - Wood Paneling Example
permalink: /2012/03/15/constraint-satisfaction-product-mix-wood-paneling-example/
---

Operations Research / Optimization / Constraint Satisfaction is the Holy Grail of computing.

Sample in Minizinc (no comparison to Hakan's) ...

<!--excerpt-->

{% highlight text %}
% minizinc product mix model from http://www.solver.com/stepbystep.htm
% 2012 Jason Filley (jason@snakelegs.org)

%%%% parameters
int: glue = 5800;               % glue (quarts)
int: pressing = 730;    % pressing time (hours)
int: pine = 29200;              % pine chips (pounds)
int: oak = 32500;               % oak chips (pounds)


constraint assert(glue >= 0,'Invalid datafile: ' ++
        'glue must be non-negative.');
constraint assert(pressing >= 0,'Invalid datafile: ' ++
        'pressing must be non-negative.');
constraint assert(pine >= 0,'Invalid datafile: ' ++
        'pine must be non-negative.');
constraint assert(oak >= 0,'Invalid datafile: ' ++
        'oak must be non-negative.');


%%%% decision variables
var 0..100: tahoe;
var 0..100: pacific;
var 0..100: savannah;
var 0..100: aspen;

%%%% constraints

% glue
constraint  50*tahoe + 50*pacific + 100*savannah + 50*aspen <= glue;

% pressing time
constraint  5*tahoe + 15*pacific + 10*savannah + 5*aspen <= pressing;

% pine chips
constraint  500*tahoe + 400*pacific + 250*savannah + 200*aspen <= pine;

% oak chips
constraint  500*tahoe + 750*pacific + 250*savannah + 500*aspen <= oak;

%%%% objective function -- maximize profit
var 0..100000: profit;
profit = 450*tahoe + 1150*pacific + 800*savannah + 400*aspen;
solve maximize profit;


output ['Tahoe: ', show(tahoe), '\n',
                'Pacific: ', show(pacific), '\n',
                'Savannah: ', show(savannah), '\n',
                'Aspen: ', show(aspen), '\n',
                'Profit: ', show(profit), '\n'];

% minizinc.exe product_mix_wood_paneling.mzn
% Tahoe: 23
% Pacific: 15
% Savannah: 39
% Aspen: 0
% Profit: 58800
% ----------
{% endhighlight %}



