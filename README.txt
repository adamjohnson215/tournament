Author: Adam Johnson

This program represent my own work, pulling from course materials and online resources such as stackoverflow.com. Every keystroke in the associated files represents my own work.

This program was designed to be run on a VirtualBox environment with a Vagrant instance running a PostgreSQL database backend. No testing was implemented on other environments to check compatibility.

To run the program, open the command prompt on the Linux virtual machine. Navigate to the /vagrant/tournament/ directory. From the tournament directory connect to the vagrant (shell) database and run the command: "\i tournament.sql" to build the necessary database backend. Once the database is initiated, run the command: "python tournament_test.py". This will run the test package relating to the tournament.py code. If the output is all tests are a success, then the package works. I look forward to your feedback and comments.
