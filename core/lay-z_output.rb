def log_output(output, output_file, note)
    #Logs tool output to designated file with a note for easier indexing
    open(output_file, "a") do |file|
        file.write("#{note}\n#{output}\n")
        file.close
    end
end