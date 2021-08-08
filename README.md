~~~~Work In Progress~~~~

Who doesn't get bored of monotonous tasks?

This collection of scripts is designed to do the heavier lifting for some of the more mundane tasks in the earlier stages of webapp penetration tests.

For starters, it'll quickly parse a list of target URLs and run a quick test connection to each to make sure they're live. Once it's done that, it'll create an output directory and spew everything that's up into a scope.txt file for use with other tools. Once your scope is established, you'll be presented with a menu of the current test modules; including:

1. Launches all your favourite Nmap scans and some of the more common NSE scripts pertinent to Web Application vulnerabilities (SSL Ciphers, Slowloris etc)
2. Testing POST, PUT, DELETE and TRACE methods.
3. Checking for missing HTTP security headers and any headers that might give juicy version information.
4. Checking for a robots.txt file and attempting to connect to any entries found (also highlights any sitemaps found).
5. Attempts to prompt non-custom error with a junk GET request.

That's it for now, but I've got more in the pipeline that I'll add when I get round to it (Currently working on a page source code scraper to pull out any juicy info/3rd party scripts without integrity flags etc).

Ta'!

p.s run the script with -a for some sweet ascii art!