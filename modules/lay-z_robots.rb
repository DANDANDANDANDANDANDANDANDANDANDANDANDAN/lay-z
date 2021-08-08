def get_robots(targets)
    targets.each do |url|
        #Checks each target for /robots.txt and logs the contents of any such file found
        res = $conn.get url+"/robots.txt"
        if res.status == 200
            puts "\n#{url}\n"+res.body+"\n"
            output_file = $output_dir+URI.parse(url).host+"_robots.txt"
            open(output_file, "wb") do |file|
                file.write(res.body)
                file.close
            end
            #Spiders the robots.txt file and attempts to connect to each URL
            parse_robots(url, output_file)
        else
            puts "#{url}/robots.txt not found!"
        end
    end
end

def parse_robots(url, input_file)
    File.open(input_file, "r").each_line do |line|
        #For each line in the robots.txt file, locates any starting with 'Disallow', pulls out the value, then attempts to browse to that file on the target.
        entry = line.split
        if entry[0].to_s == "Disallow:"
            #Alerts the user of any wildcard values found instead of browsing to them to cut out bloat
            if entry.to_s.include? "*"
                puts "#{url}/#{entry[1].to_s} contains a wildcard. Investigate manually."
            else
                #Informs the user of any successful connections to the entries
                res = $conn.get url.+entry[1].to_s
                if res.status == 200
                    puts "Successful connection to #{url}#{entry[1].to_s}"
                end
            end
        #Also lets the user know if any sitemaps are found
        elsif entry[0] == "Sitemap:"
            puts "Sitemap found at #{entry[1].to_s}"
        end
    end
end