Last week we logged onto the HPCC and **attempted** to submit a job. The accounts were not set up correctly but we should be okay now! We will run through our job submission example then begin to analyze our actual data!

This is adapted from last week:

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

Next up we will learn how to submit jobs on the HPCC. As Shawn explained the HPCC has an architecture composed of a head or login node and compute nodes. We submit job scripts on the head node specifying the computations to be done on the compute nodes. 

A script is a set of commands that we give the system to execute. We tell it which shell to execute under with the first line (called the ‘shebang’, for example #!/bin/bash for the bash shell) and any lines that we don’t want executed (comments) are ‘commented out’ with a # in the beginning. We will go through creating and submitting a job script.
Linux/Unix systems don’t support programs like Microsoft Word and in order to create a script on HPCC we need to use a text editor. We will use one called vi (this is my favorite) but feel free to use another one. 

Make sure you are in your home directory

    $ cd ~

and use vi to create a new file

    $ vi my_script.sh

You should see the vi window with the ~ symbols. Type ‘i’ to get into input or insertion mode and then type the following into your file (hint: you can click the two squares in the corner to copy this and then paste it into your HPCC script):

    #!/bin/bash
    
    #SBATCH --account iacc_jfierst
    #SBATCH -n 8
    #SBATCH --output=out_miniTry.log
    #SBATCH --mail-user=jfierst@fiu.edu
    #SBATCH --mail-type=ALL

    module load minimap2-2.24
   
    # place commands here
    module list
    echo "Hello World"
    echo "Hello World" > out.txt

Hit the escape button (‘esc’) to get out of insertion mode and type ‘:wq’ (without the single quotes) to save the file and exit vi. You have just written your first HPCC job script!

What’s going on here? We are telling the system

    #!/bin/bash (1)

    #SBATCH --account iacc_jfierst (2)
    #SBATCH --qos normal
    #SBATCH -n 8
    #SBATCH --output=output_miniTry.log
    #SBATCH --mail-user=jfierst@fiu.edu
    #SBATCH --mail-type=ALL
    
    module load minimap2-2.24 (3)

    #place commands here (4)
    module list (5)
    echo "Hello World" (6)
    echo "Hello World" > out.txt (7)

(1)	Which shell to use (bash)

(2)	A number of configuration commands, here which accounts to use and what resources we need. Also, an output file and an email to update us.

(3)	Which module to load

(4)	Comments for ourself (not read by the machine)

(5)	To list the loaded modules for us

(6)	to print “Hello World” to stdout

(7)	to redirect “Hello World” to a file called out.txt

The last thing is that we have to make the script executable. Type

    $ chmod +x my_script.sh

Now we can submit this script to the HPCC queue system and see what happens. Type

    $ sbatch < my_script.sh

If you need to check your job you can type

    $ squeue -u YOURUSERNAMEHERE
    
to check your jobs in the 'queue.' You should see something like this:
     
        JOBID               NAME        USER           TIME     ST        QOS
        52067   myscriptshSCRIPT        jfierst        0:05     R         class

where JOBID is your numerical job identifier, NAME is your script identifier, USER is your username, TIME is the time it has been running, ST is the state of the job (R is for running) and QOS is the ‘quality of service’ or queue it is running in (here, the class queue).

When it is finished type

        $ ls
and now you should see your script (my\_script.sh) along with a job output file (output_miniTry.log) and your output file out.txt. Look inside your output file

        $ more out.txt

What does it say? 

Now look in the job output file

        $ more output_miniTry.log

**Alignment and Variant Calling**

We started this course discussing 2 paradigms in genomic analysis, de novo assembly and alignment. I had planned for us to pursue assembly and the class actually generated amazing libraries BUT we had equipment/software issues with the Mk1Cs and didn't generate enough data to assemble. SO we are going to align our sequences to genome reference sequences and analyze the variants (mutations) that we find. We have 7 samples and ~21 people to analyze them so you will work in groups of 3.

First, identify your sample and make a note of it.

Next, copy your data to your home directory:

    $ cp /home/data/jfierst/Fall2023Data/YOURSAMPLENAMEHERE.gz ~

You will also copy the reference genome sequence for your sample. Use the commands below depending on your sample name:

    $ cp /home/data/jfierst/Fall2023Data/genomes/AB1_Cendar.genome.fa ~

for AB1 samples

    $ cp /home/data/jfierst/Fall2023Data/genomes/GCA_028201415.1_ASM2820141v1_genomic.fna ~

for CB4856 samples and

    $ cp /home/data/jfierst/Fall2023Data/genomes/caenorhabditis_elegans.PRJNA13758.WBPS18.genomic.fa ~

for N2 samples.

Next we need to load our alignment and variant calling software into our environment:

    $ module load minimap2-2.24
    $ module load samtools-1.9-gcc-4.8.5-k4xquzh
    $ module load bcftools-1.9-gcc-8.2.0-yvvwafo

We will use this script for alignment and variant calling:

            #!/bin/bash
            #SBATCH--account iacc_jfierst
            # Number of nodes
            #SBATCH -N 1
            # Number of tasks 
            #SBATCH -n 16
            ##SBATCH --threads-per-core 16
            #SBATCH --output=alignment.log
            
            export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE. $MODULESHOME/../global/profile.modules
            
            module load minimap2-2.24 # minimap is our alignment software
            module load samtools-1.9-gcc-4.8.5-k4xquzh # samtools is used to process our files
            
            FILE= YOURFILENAMEHERE
            
            minimap2 -d N2_reference.mmi caenorhabditis_elegans.PRJNA13758.WBPS18.genomic.fa # creating an indexed genome reference
            minimap2 -ax map-ont N2_reference.mmi $FILE > N2_alignment.sam # aligning our data to the reference
            
            samtools view -b N2_alignment.sam > N2_alignment.bam # bam is a binary file type
            samtools sort -o N2_alignment_sorted.bam N2_alignment.bam # sorting the file for analysis
            
            bcftools mpileup -f ./genomes/caenorhabditis_elegans.PRJNA13758.WBPS18.genomic.fa ./N2_Parent_alignment_sorted.bam | bcftools call -mv -Ob -o calls.bcf # calling variants and outputting to a binary file calls.bcf
            
            bcftools stats calls.bcf > bcf.stats # outputting statistics for our variants
    
    


