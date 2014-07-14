#!/usr/bin/perl -w

use strict;
use English;

#check the correct number of parameters are passed
my $paramLength = @ARGV;
if ($paramLength != 4) {
  print "PARAMETER ERROR:\nusage: script csvFile inputDir outputDir rotation
example: ./corvus_script.pl data.csv input/ output/ -90\n\n";
  exit;
}

my $csvFile = $ARGV[0];
my $inputDir = $ARGV[1];
my $outputDir = $ARGV[2];
my $rotation = $ARGV[3];
my $email = "martin.donnelley\@adelaide.edu.au";
my $taskPrefix = "WCHFlatDark";

#open the file passed as a parameter
open(CSV, $csvFile) or die "Could not open file $csvFile";
my @csvLines = <CSV>;
close(CSV);

my @jobs;

#loop for each line in the file
for (my $i = 0; $i < @csvLines; $i++){
  my $line = $csvLines[$i];
  my $taskFilename = "$taskPrefix$i";
  push(@jobs, $taskFilename);
  open(TFN, ">$taskFilename") or die "Could not open $taskFilename";

  #get an array of tokens from the line
  my @tokens = split(/,/, $line);

  my $matlabarraynum = $i + 1;
  my $exec = "echo \"Process('$inputDir', '$outputDir', '$csvFile', $rotation, $matlabarraynum)\" | /opt/shared/matlab/matlab2009a/bin/matlab -c 27000\@matlab2009b.ad.adelaide.edu.au -nodisplay -nosplash";

  print TFN "#!/bin/sh -l

#PBS -V

### Job name
#PBS -N $taskFilename

### Join queuing system output and error files into a single output file
#PBS -j oe

### Send email to user when job ends or aborts
#PBS -m ae

### email address for user
#PBS -M $email

### Queue name that job is submitted to
#PBS -q corvus

### Request nodes, memory, walltime. NB THESE ARE REQUIRED
#PBS -l ncpus=1
#PBS -l mem=4gb,vmem=4gb
#PBS -l walltime=06:00:00
### If local scratch space required, request the amount you require.
### The location of the space will be \$PBS_JOBFS when the script runs.
##PBS -l jobfs=1gb

# This job's working directory
echo Working directory is \$PBS_O_WORKDIR
cd \$PBS_O_WORKDIR
echo Running on host `hostname`
echo Time is `date`

module load matlab
# Run the executable
$exec";

  close(TFN);
  
}

#loop the system command for each of the seq jobs
foreach (@jobs){
  my $name = $_;
  system("qsub $name");
}


