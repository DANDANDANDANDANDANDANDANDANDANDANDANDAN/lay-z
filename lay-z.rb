require "Faraday"
require "nokogiri"
require "tty-prompt"
require "fileutils"
#Loads all core/module files
Dir["modules/*.rb"].each {|file| require_relative file }
Dir["core/*.rb"].each {|file| require_relative file }

#Initialises the tty-prompt menu
$prompt = TTY::Prompt.new(symbols: {marker: "💤"}, active_color: :cyan)
#Initialises the Faraday connection
$conn = Faraday.new

#Launches the script with the ascii easter egg if 'a' argument is passed
if ARGV[0] == "-a"
    sweet_ascii()
end
puts "[*] I got 99 problems and the most crippling is laziness..."
puts "[*] Who's the client? (or what do you want to call the output directory?)"
#Gets the title of the project and makes the relevant output directories
title = STDIN.gets.chomp
$output_dir = "#{Dir.pwd}/lay-z_output/#{title}/"
FileUtils.mkdir_p $output_dir unless File.exists? $output_dir

#Initialises the project (gets URLS, validates/tests connection, creates scope file etc...)
initialisation()
a = 1
#Presents the 'main menu' to launch test modules
while a > 0
    action = $prompt.select("\n[*] Waddayawannado?", cycle: true) do |menu|
        menu.enum "."  
        menu.choice :"Nmap scans", "nmap_scans" 
        menu.choice :"Nmap scripts", "nmap_scripts"
        menu.choice :"Spider robots.txt", "get_robots"
        menu.choice :"Inspect HTTP Response headers", "get_headers"
        menu.choice :"Check for risky HTTP methods", "risky_methods"
        menu.choice :"Probe for custom error messages", "prompt_error"
        menu.choice :"Quit", "quit"
    end
    #Exits script when told to
    if action == "quit"
        abort "Bye!"
    else
        #Launches selected module
        send(action, $urls)
    end
end