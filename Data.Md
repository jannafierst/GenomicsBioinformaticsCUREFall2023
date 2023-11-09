From previous sessions:

**HPCC Orientation**

We will be logging onto the HPCC and doing some preliminary navigation. You will use your panther credentials
(username and password) to connect.

Login at the FIU Panther cluster Web portal from a browser: https://hpcgui.fiu.edu
Note: Mozilla Firefox has not been working for me lately and I have to connect via Safari.

Once you are on, go to the top where it says 'Clusters' and select 'Panther Shell Access.' It will open a terminal and ask you for your panther credentials again.

Congratulations! You are officially on the server.

Type

    $ ls

and 

    $ pwd

to figure out where you are. 

I have generated some data files for you to use in your poster presentation. They are located in the directory

    /home/data/jfierst/Fall2023Data 

and there are individual directories for each sample. For example, if you sample is AB1 1E your data is located in

    /home/data/jfierst/Fall2023Data/AB1_1E/

Create a local variable with that location, for example:

    $ SAMPLE=/home/data/jfierst/Fall2023Data/AB1_1E/

BUT change the AB1_1E to your sample name.

Copy the data into your home directory:

    $ cp $SAMPLE/*stats $SAMPLE/*bed $SAMPLE/*txt ~

Here, we are using the 'wildcard' character *. It lets UNIX carry out an operation on all files that, here, start with something and end with "stats" or "bed" or "txt. Remember the '~' is a UNIX location, your home directory. Our syntax for copy is cp fromLocation toLocation.

Now you should have a number of different summary files in your home directory. Type

    $ ls

to see what's there. You should have:

    autosomes.stats  bcf.stats  X.stats
    calls.bed  mutations_in_genes.bed  mutations_not_in_genes.bed
    chromosome_location_mutation_gene.txt  chromosome_location_mutation.txt

Let's go through the files one by one. 

The .stats files are statistics. Here, bcf.stats is the whole dataset, autosomes.stats is for autosomes only and X. stats is for the X chromosome. The data is in a single file but the developers made it easy to separate with UNIX tools. For example, if you want the indel (insertion/deletion mutation) distribution you can type:

    $ cat bcf.stats | grep '^IDD' > indel.txt

Here, we are: 

1) cat bcf.stats # reading the entire bcf.stats file 
2) grep '^IDD' # searching for lines that start (the ^ character determines that) with IDD
3) \> indel.txt # writing these lines to a new file called indel.txt

Depending on the data you want to present in your poster, you can use a variant of this command to output a smaller text file for plotting. If you need help the TAs and I can help you to edit this line to get the data you want!

The .bed files are intersections; mutations that intersect with genes annotated in the genome or mutations that do not intersect with genes. You can view these files a bit:

    $ head -100 mutations_in_genes.bed

but it's apparent they are huge. To get a sense of this you can count lines:

    $ wc -l mutations_in_genes.bed

    $ wc -l mutations_not_in_genes.bed

So, I have also created smaller summary files with most of this information.

The .txt files contain columns with 

chromosome    position (nucleotide)    mutation type    gene name

Or without gene name, for the mutations that are not in genes. You can use UNIX commands to query these for data for your poster for example:

    $ cat chromosome_location_mutation_gene.txt | grep -c -w "I"

Here, we are:

1) cat chromosome_location_mutation_gene.txt # reading the entire file 
2) grep -c -w "I" # searching for lines with I (grep) and specifying it has to be an exact match (-w) and to count the occurrences (-c)

So, if you want to count the number of mutations in genes by chromosome you could enter:

    $ cat chromosome_location_mutation_gene.txt | grep -c -w "I"
    $ cat chromosome_location_mutation_gene.txt | grep -c -w "II"
    $ cat chromosome_location_mutation_gene.txt | grep -c -w "III"
    $ cat chromosome_location_mutation_gene.txt | grep -c -w "IV"
    $ cat chromosome_location_mutation_gene.txt | grep -c -w "V"
    $ cat chromosome_location_mutation_gene.txt | grep -c -w "X"

You may also be interested in how many unique genes have mutations. For that we want to reduce our dataset to a single entry, per gene. We can do that like this:

    $ cat chromosome_location_mutation_gene.txt | awk '!_[$4]++' | wc -l

Here, we are:

1) cat chromosome_location_mutation_gene.txt # reading the entire file 
2) awk '!_[$4]++' # taking the first instance of each gene name
3) wc -l # counting by line







