def prompt_error(targets)
    targets.each do |url|
        #Creates output file
        output_file = $output_dir+URI.parse(url).host+"_errors.txt"
        puts "\n#{url}\n"
        #Attempts to prompt a non-customer error by browsing to ' |.aspx'
        pipe_aspx(url, output_file)
    end
end

def pipe_aspx(url, output_file)
    puts "Sending request for '/ |.aspx'..."
    #Sends payload request
    res = $conn.get("#{url}/%20%7C.aspx")
    #Checks response status code
    if res.status != 200
        #If a 404 is returned, displays disclaimer instead of response to cut down on bloat. Outputs to file.
        if res.status == 404
            puts "404 returned. Manually inspect output file for more information."
            log_output("#{res.headers}\n#{res.body}", output_file, "' |.aspx 404'")
        else
            #If a response other than 200 or 404 is returned, prints the status code and response body to screen before outputting to file
            puts "#{res.status} returned:\n\n#{res.headers}\n#{res.body}"
            log_output("#{res.headers}\n#{res.body}", output_file, "' |.aspx' #{res.status}")
        end
    else
        #Informs user if a 200 is returned without outputting to file - likely some sort of filter/wildcard is in place.
        puts "200 returned."
    end
end