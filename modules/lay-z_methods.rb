def risky_methods(targets)
    #Iterates through each URL and makes POST, PUT and TRACE requests before printing the responses to the output file 
    targets.each do |url|
        output_file = $output_dir+URI.parse(url).host+"_methods.txt"
        puts "\n#{url}\n"
        post_request(url, output_file)
        put_request(url, output_file)
        trace_request(url, output_file)
    end
end

def post_request(url, output_file)
    #Makes a POST request without a body to the target URL and logs anything other than a 200 response
    res = $conn.post(url)
    puts "\nEmpty POST request returned a #{res.status}:"
    if res.status != 200
        puts res.body
        risky_headers(res.headers)
        log_output(res.body, output_file, "POST EMPTY")
    end   
    #Makes a POST request with a 'junk' body to the target URL and logs anything other than a 200 response
    res = $conn.post(url, PENTEST: 'PENTEST')
    puts "\nPOST request with junk body returned a #{res.status}:"
    #We also check for any risky headers on any response other than a 200
    if res.status != 200
        puts res.body
        risky_headers(res.headers)
        #Logs any responses other than a 200
        log_output(res.body, output_file, "POST JUNK BODY")
    end   
end

def put_request(url, output_file)
    #Attempts to PUT a junk file 'PENTEST.html' onto target
    res = $conn.put("#{url}/PENTEST.html")
    puts "\nPUT 'PENTEST.html' returned a #{res.status}:"
    #As this never works, if we get a 200 response, we immediately check for a false positive by browsing to the file
    if res.status == 200
        puts "Checking for false positive..."
        fp = $conn.get ("#{url}/PENTEST.html")
        #If the file is found, the user is prompted to shell the box
        if fp.status == 200
            puts "\n\n\n\n**** PENTEST.html found (wtf?). Go get that shell! ****\n\n\n\n"
            puts "Attempting to clean up..."
            #We then attempt to DELETE the junk file
            fp = $conn.delete ("#{url}/PENTEST.html")
            if fp.status == 200
                puts "\n'PENTEST.html' successfully removed. DELETE is enabled."
            else
                puts "Could not clean up!!"
                puts "\nDELETE 'PENTEST.html' returned a #{res.status}:"
            end
            puts fp.body
            #Logs DELETE responses
            log_output(fp.body, output_file, "DELETE PENTEST.html")
        else
            puts "False positive confirmed. GET '/PENTEST.html' returned #{fp.status} :("
        end
    end
    puts res.body
    #We also check for any risky headers on any response other than a 200
    risky_headers(res.headers)
    #Logs responses
    log_output(res.body, output_file, "PUT PENTEST.html")
end

def trace_request(url, output_file)
    res = $conn.trace(url)
    puts "\nTRACE request returned a #{res.status}:"
    if res.status == 200
        puts "TRACE method supported."
    end
    puts res.body
    #We also check for any risky headers on any response other than a 200
    risky_headers(res.headers)
    #Logs responses
    log_output(res.body, output_file, "TRACE")
end