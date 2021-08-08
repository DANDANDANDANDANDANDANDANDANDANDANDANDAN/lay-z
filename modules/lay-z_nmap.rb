def nmap_scans(targets)
    puts "[*] FYI this only works on MacOS atm..."
    #Creates output directory
    FileUtils.mkdir_p "#{$output_dir}/nmap" unless File.exists? "#{$output_dir}/nmap"
    #This variable just makes the rest of the script look a little cleaner
    base_command = "osascript -e 'tell app \"Terminal\"' -e 'do script \""
    b = 1
    while b > 0
        #Presents menu of Nmap scan types
        action = $prompt.select("\n[*] What scan? (Scans will be launched in a new window)", cycle: true) do |menu|
            menu.enum "."  
            menu.choice :"Fast TCP scan", "1" 
            menu.choice :"Standard TCP scan", "2"
            menu.choice :"Full TCP scan", "3"
            menu.choice :"Full TCP scan with scripts", "4"
            menu.choice :"Top 200 UDP", "5"
            menu.choice :"Top 200 UDP with scripts", "6"
            menu.choice :"Back", "0"
        end
        #Lanches relevant scan in a new window or returns to previous menu
        if action == "0"
            b = 0
        elsif action == "1"
            system("#{base_command}nmap -F -Pn -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/tcpfast\"' -e 'end tell'")
        elsif action == "2"
            system("#{base_command}nmap -Pn -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/tcpstandard\"' -e 'end tell'")
        elsif action == "3"
            system("#{base_command}nmap -p- -Pn -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/tcpall\"' -e 'end tell'")
        elsif action == "4"
            system("#{base_command}nmap -p- -A -Pn -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/tcpall_allscripts\"' -e 'end tell'")
        elsif action == "5"
            system("#{base_command}sudo nmap -sU -Pn --top-ports=200 -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/udp200\"' -e 'end tell'")
        elsif action == "6"
            system("#{base_command}sudo nmap -sU -Pn -A --top-ports=200 -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/udp200_allscripts\"' -e 'end tell'") 
        end
    end
end

#Exact same as above, but with NSE scripts
def nmap_scripts(targets)
    FileUtils.mkdir_p "#{$output_dir}/nmap" unless File.exists? "#{$output_dir}/nmap"
    base_command = "osascript -e 'tell app \"Terminal\"' -e 'do script \""
    b = 1
    while b > 0
        action = $prompt.select("\n[*] What scan? (Scans will be launched in a new window)", cycle: true) do |menu|
            menu.enum "."  
            menu.choice :"HTTP enum", "1" 
            menu.choice :"Slowloris check", "2"
            menu.choice :"SSL Ciphers", "3"
            menu.choice :"SSL Certificate", "4"
            menu.choice :"WAF detection", "5"
            menu.choice :"Back", "0"
        end
        if action == "0"
            b = 0
        elsif action == "1"
            system("#{base_command}nmap -Pn -p 80,443 --script http-enum -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/http-enum\"' -e 'end tell'")
        elsif action == "2"
            system("#{base_command}nmap -Pn -p 80,443 --script http-slowloris-check -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/slowloris\"' -e 'end tell'")
        elsif action == "3"
            system("#{base_command}nmap -Pn -p 80,443 --script ssl-enum-ciphers -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/ciphers\"' -e 'end tell'")
        elsif action == "4"
            system("#{base_command}nmap -Pn -p 80,443 --script ssl-cert -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/ssl-cert\"' -e 'end tell'")
        elsif action == "5"
            system("#{base_command}nmap -Pn -p 80,443 --script http-waf-detect,http-waf-fingerprint -T4 -iL #{$output_dir}scope.txt -oA #{$output_dir}nmap/waf\"' -e 'end tell'")
        end
    end
end