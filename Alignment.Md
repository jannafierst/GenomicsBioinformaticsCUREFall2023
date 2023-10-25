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

You should see the vi window with the ~ symbols. Type ‘i’ to get into input or insertion mode and then type the following into your file (hint: you can click the square in the corner to copy this and then paste it into your HPCC script):

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


