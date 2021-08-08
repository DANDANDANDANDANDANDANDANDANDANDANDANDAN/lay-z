def get_headers(targets)
    targets.each do |url|
        #Sends request to receive headers from each URL
        res = $conn.head url
        puts "\n#{url}\n\n"
        #Prints response headers to screen before outputting them to a file
        res.headers.each do |header, value|
            puts "#{header}: #{value}"
            output_file = $output_dir+URI.parse(url).host+"_headers.txt"
            open(output_file, "a") do |file|
                file.write("#{header}: #{value}\n")
                file.close
            end
        end
        puts
        #Checks for important missing security headers
        missing_headers(res.headers)
        #Checks for any 'risky' response headers - server/version information etc
        risky_headers(res.headers)
    end
end

def missing_headers(response_headers)
    security_headers = [
        "Content-Security-Policy",
        "Strict-Transport-Security",
        "X-Content-Type-Options",
        "X-Frame-Options"]
    #Iterates through each security header, if it isn't found in the list of response headers, the missing header is printed to screen 
    security_headers.each do |security_header|
        found = false
        response_headers.each do |header, value|
            if security_header.downcase == header
                found = true
            end
        end
        if found == false
            puts "Security header ::#{security_header}:: is missing."
        end
    end
    puts
end

def risky_headers(response_headers)
    risky_headers = [
        "Server",
        "X-AspNet-Version",
        "X-AspNetMvc-Version",
        "X-Powered-By",]
    #Iterates through each 'risky' header, if it's found in the list of response headers, the 'risky' header and it's value is printed to screen
    risky_headers.each do |risky_header|
        found = false
        response_headers.each do |header, value|
            if risky_header.downcase == header and value != "max-age=31536000"
                puts "Header misconfiguration identified: #{risky_header}: #{value}"
            end
        end
    end
    puts
end