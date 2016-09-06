#!/usr/bin/perl -w

use warnings;
use strict;
use LWP::UserAgent;
use Memory::Usage;

#Enable Autoflush
select(STDERR);
local $| = 1;
select(STDOUT);
local $| = 1;

my $i;

query (); #once
my $mu = Memory::Usage -> new ( keep_alive => 0 );
$mu -> record ( 'started' );

#main loop
for ( ; ; )
{
	$i++;
	query ();
	if ( $i > 9999 )
	{
		last;
	}
}
$mu -> record ( 'finished' );
$mu -> dump ();

#http query
sub query
{
	my $user_agent = LWP::UserAgent -> new;
	$user_agent -> timeout ( 60 );
	$user_agent -> agent ( "NXLog" );
	#my $headers = HTTP::Headers -> new ();
	my $http_request;
	my $http_response;
	my $url = 'http://localhost/';
	my $content = '';
	#$headers -> clear ();
	#$headers -> header ( 'Authorization', "Bearer " . "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlliUkFRUlljRV9tb3RXVkpLSHJ3TEJiZF85cyIsImtpZCI6IlliUkFRUlljRV9tb3RXVkpLSHJ3TEJiZF85cyJ9.eyJhdWQiOiJodHRwczovL21hbmFnZS5vZmZpY2UuY29tIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvZTY4MWI0OTMtMTRhOC00MzhiLThiYmYtZDY1YWJkYzgyNmMyLyIsImlhdCI6MTQ3MzE2MzM2MywibmJmIjoxNDczMTYzMzYzLCJleHAiOjE0NzMxNjcyNjMsImFwcGlkIjoiOTEyNDk3YmEtOTc4MC00NmJjLWE2YTYtM2E1NmE0YzE0Mjc4IiwiYXBwaWRhY3IiOiIyIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvZTY4MWI0OTMtMTRhOC00MzhiLThiYmYtZDY1YWJkYzgyNmMyLyIsIm9pZCI6ImVhNmY4MGRkLTdhNGQtNDRjMS04NGE4LTZlYTdiNmViYjQzYSIsInJvbGVzIjpbIlRocmVhdEludGVsbGlnZW5jZS5SZWFkIiwiQWN0aXZpdHlSZXBvcnRzLlJlYWQiLCJUaHJlYXRJbnRlbGxpZ2VuY2UuUmVhZCIsIkFjdGl2aXR5RmVlZC5SZWFkRGxwIiwiQWN0aXZpdHlSZXBvcnRzLlJlYWQiLCJTZXJ2aWNlSGVhbHRoLlJlYWQiLCJBY3Rpdml0eUZlZWQuUmVhZCJdLCJzdWIiOiJlYTZmODBkZC03YTRkLTQ0YzEtODRhOC02ZWE3YjZlYmI0M2EiLCJ0aWQiOiJlNjgxYjQ5My0xNGE4LTQzOGItOGJiZi1kNjVhYmRjODI2YzIiLCJ2ZXIiOiIxLjAifQ.jWDuVjssjkrRV4Of2sMT4Imny0W5jMuj8NisX2v-ji45WzJvaEnSMHGevMOGbIwT6L1K9sSGGVeIytgwm5EA3NnFnYpJ9syHF_iPUamM0zQ2XAN3Bsa5ep7WzaD8cE3al6_Nl7fiwchHsN5mXcs5s9JZbafwjSknfsffbXCmWxli9jZQmViKRthxOH87C588Fc0vdNuubkJyCQ_3P_ssMRuCJYarwgAfhkoAF4855BbZKy3bKTMLwwu8072NDI23yTzi1T9QKttXsW_Jaf70931atZ5vueE2wnD1r0aa01o7EzCuxsBi7EJBU0ywg8lestFX720bthVrQdAXHNAQgQ" );
	$http_request = HTTP::Request -> new ( 'GET', $url ); #, $headers );
	$http_response = $user_agent -> request ( $http_request );
	if ( $http_response -> is_success )
    {
		$content = $http_response -> content ();
		#print ( $content . "\n\n" );
	}
	else
	{
		print ( "Failed to retreive http response: " . $http_response -> status_line . " / " . $http_response -> content () . "\n" );
	}
}

=pod

Test:
python -m SimpleHTTPServer 80
./LWP_UserAgent_Memory_Usage.pl

Results:
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  51852 ( 51852)  15312 ( 15312)   4004 (  4004)      8 (     8)  11612 ( 11612) started
    69  51852 (     0)  15596 (   284)   4112 (   108)      8 (     0)  11612 (     0) finished


after 

my $user_agent = LWP::UserAgent -> new(ssl_opts => { verify_hostname => 0 });

./LWP_UserAgent_Memory_Usage.pl
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  51840 ( 51840)  15408 ( 15408)   4084 (  4084)      8 (     8)  11600 ( 11600) started
    69  51948 (   108)  15688 (   280)   4188 (   104)      8 (     0)  11708 (   108) finished
=cut

