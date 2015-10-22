# Sam Scheiner 6/29/15 NSS track plugin script generator 1.1
# returns list of random coordinates between initial and final coordinates in lat long NSS compatible format
# generates basic png to visualize randomization of track points 
#1.1: Output file is timestamped

use 5.14.1;
use strict;
use warnings;
#use GD::Simple;
#use Data::Dumper qw(Dumper); #use for debugging



#####example starting and ending points

my($self,$region)=@_;
my $initialPointX = 38.850853; 	#hardcoded x/y example
my $initialPointY =  -77.039836;
my $finalPointX = 44.806728;
my $finalPointY =-68.817607;
my $intervals = 0;	
my $maxRandOffset = 0;
my $speed = 0.0; 		#you can change this via input
my $horizOffset = 0.0; 
my $verOffset = 0.0;
my $incrCounter = 1;
my $randX = 0;
my $randY  = 0;
my $finalX = 0.0;
my $finalY = 0.0;
my $execute = 0; #for checking input, algorithm wont run until divide by 0 errors are ruled out
(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isDST) = localtime();
my $time = "$mon$mday$year$hour$min$sec";
my $returnData = " ";

########


print "Enter offset multiplier:\n";
$maxRandOffset = <stdin>;
chomp $maxRandOffset;

while($execute == 0)
	{
		print "Enter number of intervals:\n";
		$intervals = <stdin>;
		chomp $intervals;
		if($intervals < 1)
			{
			 print "Interval value must be greater than or equal to 1\n";
			}
		else{
		$execute = 1;	
		}
	}
$execute = 0;
while($execute == 0)
	{
		print "Enter speed:\n";
		$speed = <stdin>;
		chomp $speed;
		if($speed <= 0)
			{
			 print "Speed must be greater than 0\n";
			}
		else{
		$execute = 1;	
		}
	}
$horizOffset = $finalPointX - $initialPointX;
$verOffset = $finalPointY - $initialPointY;

###### abandon hope, all ye who enter here


#the algorithm works by taking the delta x and delta y, then placing points along the line fractions of delta x/y at a time and palcing reference points at these intervals. A random offset is then added to these points 

### draw initial line based off initial and final point data
=draw
my $img = GD::Simple->new(500, 500);
$img->moveTo($initialPointX, $initialPointY); # (x, y)
$img->lineTo($finalPointX, $finalPointY); # (x, y)
$img->bgcolor('blue'); #make endpoint square blue

$img->rectangle(($initialPointX - 5),($initialPointY - 5),($initialPointX + 5),($initialPointY + 5)); #(top_left_x, top_left_y, bottom_right_x, bottom_right_y) identifies initial and final point
$img->rectangle(($finalPointX - 5),($finalPointY - 5),($finalPointX + 5),($finalPointY + 5)); #(top_left_x, top_left_y, bottom_right_x, bottom_right_y)

$img->bgcolor('red'); # make reference points red
=cut
$returnData = "return([";

	while($incrCounter < $intervals) #generate reference points at defined intervals
	{
		$randX = rand($maxRandOffset);
		$randX = $randX - ($maxRandOffset/2);		#subtract half of absolute value 
		$randY = rand($maxRandOffset);
		$randY = $randY - ($maxRandOffset/2); 
		
	
		$finalX = ($initialPointX + $incrCounter * ($horizOffset/($intervals)) ) + ($randX);
		$finalY = ($initialPointY + $incrCounter * ($verOffset/($intervals)) ) + ($randY);

	
=draw
		$img->rectangle(		#visualization tool
				$finalX - 5, 	
				$finalY - 5, 
				$finalX + 5,
				$finalY + 5,
				); 	#(top_left_x, top_left_y, bottom_right_x, bottom_right_y)
=cut				
		$returnData .= "[$finalY, $finalX, 0, $speed, 0],";
		$incrCounter++;
	}

=draw		
open my $out, '>', 'img.png' or die "$!";
binmode $out;
print $out $img->png;
=cut
$returnData .= "],[[\"PATROL\",0]])";


open(my $write, '>', "generatedNSSPlugin$time.txt") or die "$!"; #create text file to write to
	print $write "sub init_track {\n\n";	
	print $write "$returnData\n";
	print $write "\n\n}";
close $write;
print "Done\n";
