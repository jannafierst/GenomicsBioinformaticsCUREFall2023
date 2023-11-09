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





