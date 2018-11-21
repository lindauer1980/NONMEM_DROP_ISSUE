
I would like to share with the group an issue that I encountered using NONMEM and which appears to me to be an undesired behavior. Since it is confidential matter I can’t unfortunately share code or data.

I have run a simple PK model with 39 data items in $INPUT. After a successful run I started a covariate search using PsN. To my surprise the OFVs when including covariates in the forward step turned out to be all higher than the OFV of the base model. I mean higher by ~180 units.
I realized that PsN in the scm routine adds =DROP to some variables in $INPUT that are not used in a given covariate test run. 
I then ran the base model again with DROPPING some variables from $INPUT. And indeed the run with 3 or more variables dropped (using DROP or SKIP) resulted in a higher OFV (~180 units), otherwise being the same model.
In the lst files of both models I noticed a difference in the line saying “0FORMAT FOR DATA” and in fact when looking at the temporarily created FDATA files, it is obvious that the format of the file from the model with DROPped items is different. 
In my concrete case the issue only happens when dropping 3 or more variables. I get the same behavior with NM 7.3 and 7.4.2. Both on Windows 10 and in a linux environment.
The problem is fixed by using the WIDE option in $DATA.
I’m not aware of any recommendation or advise to use the WIDE option when using DROP statements in the dataset. But am happy to learn about it in case I missed it.


Included in this repository are 4 model files, 

1) without dropping 
2) 3 variables dropped, 
3) with the WIDE option and 3 dropped variables
4) 3 dropped variables and variables in input file rounded

#1, #3 and #4 give the same OFV, while #2 results in a 220 units higher OFV


The datasets contain made up data and has no link to real measurements.
