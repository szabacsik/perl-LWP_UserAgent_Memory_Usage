#!/usr/bin/perl -w

use warnings;
use strict;
use LWP::UserAgent;
use LWP::Simple;
use HTTP::Tiny;
use AnyEvent::HTTP;
use Memory::Usage;
use feature qw(say);
use Data::Dumper qw(Dumper);

#Enable Autoflush
select(STDERR);
local $| = 1;
select(STDOUT);
local $| = 1;

#call once
#use_LWP_UserAgent ();
#use_LWP_Simple ();
#use_HTTP_Tiny ();
use_AnyEvent_HTTP ();

my $mu = Memory::Usage -> new;
$mu -> record ( 'started' );

#main loop
my $i;
for ( ; ; )
{
	$i++;
	#use_LWP_UserAgent ();
	#use_LWP_Simple ();
	#use_HTTP_Tiny ();
	use_AnyEvent_HTTP ();
	if ( $i > 100000 )
	{
		last;
	}
}
$mu -> record ( 'finished' );
$mu -> dump ();


sub use_LWP_UserAgent
{
	my $user_agent = LWP::UserAgent -> new ( keep_alive => 0, ssl_opts => { verify_hostname => 0 } );
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

sub use_LWP_Simple
{
	my $url = 'http://localhost';
	my $html = get $url;
}

sub use_HTTP_Tiny
{

	my $url = 'http://localhost/';
 
	my $response = HTTP::Tiny->new->get($url);
	if ($response->{success}) {
	    while (my ($name, $v) = each %{$response->{headers}}) {
	        for my $value (ref $v eq 'ARRAY' ? @$v : $v) {
	            #say "$name: $value";
	        }
	    }
	    if (length $response->{content}) {
	        #say 'Length: ', length $response->{content};
			delete $response->{content};
	    }
		#print "\n";
		#print Dumper $response;
	} else {
	    #say "Failed: $response->{status} $response->{reasons}";
	}

}


sub use_AnyEvent_HTTP
{

	my $exit_wait = AnyEvent -> condvar;

	my $handle = http_request
	GET => "http://localhost/",
	headers => { "user-agent" => "nxlog" },
	sub
	{
		my ( $body, $headers ) = @_;
	    #print Dumper $body, $headers;
	    $exit_wait -> send;
	};

	$exit_wait -> recv;

}

=pod

Test:
python -m SimpleHTTPServer 80
./LWP_UserAgent_Memory_Usage.pl

use_LWP_UserAgent

Results:
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  51852 ( 51852)  15312 ( 15312)   4004 (  4004)      8 (     8)  11612 ( 11612) started
    69  51852 (     0)  15596 (   284)   4112 (   108)      8 (     0)  11612 (     0) finished

my $user_agent = LWP::UserAgent -> new(ssl_opts => { verify_hostname => 0 });

./LWP_UserAgent_Memory_Usage.pl
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  51840 ( 51840)  15408 ( 15408)   4084 (  4084)      8 (     8)  11600 ( 11600) started
    69  51948 (   108)  15688 (   280)   4188 (   104)      8 (     0)  11708 (   108) finished

use_LWP_Simple

  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  58900 ( 58900)  18372 ( 18372)   4132 (  4132)      8 (     8)  14536 ( 14536) started
    57  58900 (     0)  18556 (   184)   4192 (    60)      8 (     0)  14536 (     0) finished

use_HTTP_Tiny

  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  46032 ( 46032)  13752 ( 13752)   3948 (  3948)      8 (     8)  10100 ( 10100) started
    31  46032 (     0)  13780 (    28)   3948 (     0)      8 (     0)  10100 (     0) finished

use_AnyEvent_HTTP

  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  55796 ( 55796)  17284 ( 17284)   4068 (  4068)      8 (     8)  13504 ( 13504) started
   346  55796 (     0)  17284 (     0)   4068 (     0)      8 (     0)  13504 (     0) finished

=cut
