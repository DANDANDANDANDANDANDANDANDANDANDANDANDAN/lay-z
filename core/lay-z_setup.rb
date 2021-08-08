def initialisation()
    #Gets a preliminary list of URLs from the user
    $temp_urls = $prompt.ask("[*]What URLs are we testing? (comma sep list)", required: true) do |q|
        #Splits any comma separated urls into an array
        q.convert -> (input) { input.split(/,\s*/) }
    end
    #Initialises an array for validated URLs
    $validated_urls = []
    $temp_urls.each do |url|
        #Checks each of the temporary URLs for a protocol
        protocol_checker(url)
    end
    #Once all URLs are validated, prints the list of URLs
    puts $validated_urls
    #Quick sanity check on the  URLs before any test connections are made
    sanity_check = $prompt.select("[*] Are these URLs correct?", echo: false, cycle: true) do |q|
        q.enum "."
        q.choice :Yup, 1
        q.choice :Nah, 2
    end
    if sanity_check == 2
        abort("[*]Restart the script and give it another go.")
    else 
        #If the sanity check is passed, the validated URLs are tested for connectivity
        test_connection($validated_urls)
    end
end

def protocol_checker(unvalidated_url)
    #Converts the temporary URL into a parsable URI object
    uri = URI.parse(unvalidated_url)
    #Checks the URL for a protocol
    if uri.scheme != "http" and uri.scheme != "https"
        #If it isn't http(s), prompts the user to select the appropriate protocol
        select_protocol = $prompt.select("[*] Please specifiy a protocol for for #{unvalidated_url}:", echo: false, cycle: true) do |q|
        q.enum "."
        q.choice :https, 1
        q.choice :http, 2
    end        
        if select_protocol == 1
            $validated_urls << "https://" + unvalidated_url
        else 
            $validated_urls << "http://" + unvalidated_url
        end
    else
        #Once the protocol is added, the URL is added to the validated URLs list
        $validated_urls << unvalidated_url
    end
end

def test_connection(test_urls)
    #Runs a quick test connection for each URL
    confirmed_urls = []
    test_urls.each do |url|
        begin
            res = $conn.get url
            #If the URL returns a 200, it's added to the list of confirmed URLs
            if res.status == 200
                confirmed_urls << url
                # Any that return a 30x, they're added, but the user is notified
            elsif res.status == 301 or res.status == 302
                puts "#{url} returned #{res.status} FYI!."
                confirmed_urls << url
            else
                puts "[*]#{url} returned #{res.status} - might want to double check the URL manually."
            end
        rescue
            puts "[*]Connection to #{url} failed!"
        end
    end
    #If there's at least one valid URL, the user is prompted if they want to continue testing that target
    if confirmed_urls.length > 0
        puts "[*]Successfully connected to the following URLs:"
        confirmed_urls.each do |url|
            puts " #{url}"
        end
        #Gives the user one last chance to abort testing
        sanity_check = $prompt.select("[*] Continue testing the above URLs?", echo: false, cycle: true) do |q|
            q.enum "."
            q.choice :Yup, 1
            q.choice :Nah, 2
        end
        if sanity_check == 2
            abort("[*]Sound.")
        else 
            #Confirms the working URLs as targets and creates a scope.txt file
            $urls = confirmed_urls
            create_scope($urls)
        end
    else
        abort("[*]Couldn't connect to any of the supplied URLs. Double check and try again.")
    end
end

def create_scope(scope)
    #Writes the target domains to a text file for use with other tools
    scope.each do |url|
        File.open("#{$output_dir}/scope.txt", "a") {|f| f.write("#{URI.parse(url).host.chomp}\n")}
    end
end